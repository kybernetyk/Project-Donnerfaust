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

	static unsigned int boundTexture = 0;

	Texture2D::Texture2D (std::string filename)
	{
		//printf("0x%x: Texture2D::Texture2D(%s)\n",this,filename.c_str());
		w = h = 0;
		if (!this->loadFromFile(filename))
		{
			printf("could not load texture: %s!\n",filename.c_str());
			abort();
		}
	}

	Texture2D::~Texture2D ()
	{
		printf("%p: Texture2D::~Texture2D()\n",this);
		
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
		 0
		// SOIL_FLAG_MIPMAPS | SOIL_FLAG_INVERT_Y | SOIL_FLAG_NTSC_SAFE_RGB | SOIL_FLAG_COMPRESS_TO_DXT
		 //SOIL_FLAG_MIPMAPS | SOIL_FLAG_COMPRESS_TO_DXT
	//	 SOIL_FLAG_INVERT_Y | SOIL_FLAG_NTSC_SAFE_RGB | SOIL_FLAG_COMPRESS_TO_DXT
		 ,&w,&h
		 );
		
		/* check for an error during the load process */
		if( 0 == tex_2d )
		{
			printf( "SOIL loading error: '%s' - %s\n", SOIL_last_result(),filename.c_str());
			
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


}