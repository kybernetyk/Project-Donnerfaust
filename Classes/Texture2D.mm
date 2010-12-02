/*
 *  Texture2D.cpp
 *  SpaceHike
 *
 *  Created by jrk on 6/11/10.
 *  Copyright 2010 flux forge. All rights reserved.
 *
 */

#include "Texture2D.h"
#import <OpenGLES/ES1/gl.h>
#include <string>
#include <vector>
#include <iostream>
#include <fstream>
#include "SOIL.h"
namespace mx3 
{
		
	std::string pathForFile2 (const char *filename)
	{
		
		
		NSString *relPath = [NSString stringWithFormat: @"%s",filename];
	//	NSLog(@"%@",relPath);
		
		
		NSMutableArray *imagePathComponents = [NSMutableArray arrayWithArray:[relPath pathComponents]];
		NSString *file = [imagePathComponents lastObject];
		
		[imagePathComponents removeLastObject];
		NSString *imageDirectory = [NSString pathWithComponents:imagePathComponents];
		
		NSString *ret = [[NSBundle mainBundle] pathForResource:file ofType:nil inDirectory:imageDirectory];	
		
	//	NSLog(@"ret: %@",ret);
		if (!ret)
		{
			NSLog(@"%s wurde nicht gefunden! pathForFile()",filename);
			abort();
		}
		const char *c = [ret cStringUsingEncoding: NSASCIIStringEncoding];
		
		return std::string (c);
		
	}

	unsigned int Texture2D::boundTexture = 0;

	Texture2D::Texture2D (std::string filename)
	{
		//printf("0x%x: Texture2D::Texture2D(%s)\n",this,filename.c_str());
		w = h = 0;
		if (!this->loadFromFile(filename))
		{
			CV3Log ("could not load texture: %s!\n",filename.c_str());
			abort();
		}
	}

	Texture2D::~Texture2D ()
	{
		glDeleteTextures (1, &_openGlTextureID);
	}

	bool Texture2D::loadFromFile (std::string filename)
	{
		
		filename = pathForFile2(filename.c_str());
		
		//printf("LOADING %s ...\n",filename.c_str());
		
		GLuint tex_2d = SOIL_load_OGL_texture2
		(
		 filename.c_str(),
		 SOIL_LOAD_AUTO,
		 SOIL_CREATE_NEW_ID,
		 SOIL_FLAG_COMPRESS_TO_DXT,
		// SOIL_FLAG_MIPMAPS | SOIL_FLAG_INVERT_Y | SOIL_FLAG_NTSC_SAFE_RGB | SOIL_FLAG_COMPRESS_TO_DXT
		 //SOIL_FLAG_MIPMAPS | SOIL_FLAG_COMPRESS_TO_DXT
	//	 SOIL_FLAG_INVERT_Y | SOIL_FLAG_NTSC_SAFE_RGB | SOIL_FLAG_COMPRESS_TO_DXT
		 &w,&h
		 );
		
		/* check for an error during the load process */
		if( 0 == tex_2d )
		{
			CV3Log ( "SOIL loading error: '%s' - %s\n", SOIL_last_result(),filename.c_str());
			
			abort();
		}
		
		_openGlTextureID = tex_2d;
		
		_filename = filename;
		
		setAliasTexParams();
		return true;
	} 



	void Texture2D::makeActive ()
	{
		if (boundTexture == _openGlTextureID) //20 frames worth with 256 same rebindings oO
			return;
		
		boundTexture = _openGlTextureID;
			//	printf("binding texture id %i\n",_openGlTextureID);
		glBindTexture( GL_TEXTURE_2D, _openGlTextureID );
	}

	void Texture2D::setTexParams (TextureParams *texParams)
	{
		//glBindTexture( GL_TEXTURE_2D, _openGlTextureID );
		makeActive();
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, texParams->minFilter );
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, texParams->magFilter );
		glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, texParams->wrapS );
		glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, texParams->wrapT );
		
	}

	void Texture2D::setAliasTexParams ()
	{
		TextureParams texParams = { GL_NEAREST, GL_NEAREST, GL_CLAMP_TO_EDGE, GL_CLAMP_TO_EDGE };
		setTexParams(&texParams);
	}

	void Texture2D::setAntiAliasTexParams ()
	{
		TextureParams texParams = { GL_LINEAR, GL_LINEAR, GL_CLAMP_TO_EDGE, GL_CLAMP_TO_EDGE };
		setTexParams(&texParams);
	}
	
	
	////////////////////////////////////////////
	
	BufferTexture2D::BufferTexture2D (std::string filename)
	{
		w = h = 0;
		buffer = 0;
		if (!this->loadFromFile(filename))
		{
			CV3Log ("could not load texture: %s!\n",filename.c_str());
			abort();
		}
		
	}
	
	BufferTexture2D::~BufferTexture2D ()
	{
		if (buffer)
		{
			free(buffer);
			buffer = NULL;
		}
			
	}
	
	bool BufferTexture2D::loadFromFile (std::string filename)
	{
		
		filename = pathForFile2(filename.c_str());
		
		printf("LOADING %s ...\n",filename.c_str());
		
		GLuint tex_2d = SOIL_load_OGL_texture3
		(
		 filename.c_str(),
		 SOIL_LOAD_AUTO,
		 SOIL_CREATE_NEW_ID,
		 0
		 // SOIL_FLAG_MIPMAPS | SOIL_FLAG_INVERT_Y | SOIL_FLAG_NTSC_SAFE_RGB | SOIL_FLAG_COMPRESS_TO_DXT
		 //SOIL_FLAG_MIPMAPS | SOIL_FLAG_COMPRESS_TO_DXT
		 //	 SOIL_FLAG_INVERT_Y | SOIL_FLAG_NTSC_SAFE_RGB | SOIL_FLAG_COMPRESS_TO_DXT
		 ,&w,&h,
		 &buffer
		 );
		
		/* check for an error during the load process */
		if( 0 == tex_2d )
		{
			CV3Log ( "SOIL loading error: '%s' - %s\n", SOIL_last_result(),filename.c_str());
			
			abort();
		}
		_openGlTextureID = tex_2d;
		
		_filename = filename;
		
		
		
		setAliasTexParams();
		return true;
		
	}
	
	void BufferTexture2D::updateTextureWithBufferData ()
	{
//		if (_openGlTextureID)
//		{
//			glDeleteTextures (1, &_openGlTextureID);
//		}
		
/*		tex_id = SOIL_internal_create_OGL_texture(
													  img, width, height, channels,
													  reuse_texture_ID, flags,
													  GL_TEXTURE_2D, GL_TEXTURE_2D,
													  GL_MAX_TEXTURE_SIZE );*/
		
	/*	for (int i = 0; i < w*h*4; i+= 4)
		{
			buffer[i+0] = rand()%255;
			buffer[i+1] = rand()%255;
			buffer[i+2] = rand()%255;
			buffer[i+3] = 0xff;
		}*/
		glBindTexture(GL_TEXTURE_2D, _openGlTextureID);
		glTexImage2D(GL_TEXTURE_2D,
					 0,
					 GL_RGBA, 
					 w, h,
					 0, 
					 GL_RGBA,
					 GL_UNSIGNED_BYTE,
					 buffer);
		
		/*_openGlTextureID = SOIL_internal_create_OGL_texture(
															buffer,
															w,
															h,
															4,
															0,
															0,
															GL_TEXTURE_2D,
															GL_TEXTURE_2D,
															GL_MAX_TEXTURE_SIZE);*/
															
		
		
/*		unsigned int
		SOIL_internal_create_OGL_texture
		(
		 const unsigned char *const data,
		 int width, int height, int channels,
		 unsigned int reuse_texture_ID,
		 unsigned int flags,
		 unsigned int opengl_texture_type,
		 unsigned int opengl_texture_target,
		 unsigned int texture_check_size_enum
		 )
		;*/
		
	}
	
}