/*
 *  TexturedQuad.h
 *  SpaceHike
 *
 *  Created by jrk on 6/11/10.
 *  Copyright 2010 flux forge. All rights reserved.
 *
 */
#pragma once
#include <string>
#include "Util.h"
#include "bm_font.h"
#include "TextureManager.h"
#import "ParticleEmitter.h"
namespace mx3 
{
		
		
	class Texture2D;

	class IRenderable
	{
	public:
		
		static unsigned int LAST_GUID;
		
		IRenderable()
		{
			_guid = ++LAST_GUID;
			init();
		}
		
		std::string _filename;
		
		virtual void init()
		{
			anchorPoint = vector2D_make(0.5, 0.5);
			x = y = z = 0.0;
			scale_x = scale_y = 1.0;
			rotation = 0.0;
			alpha = 1.0;
			w = h = 0;
		}
		
		virtual ~IRenderable()
		{
		}
		
		virtual void renderContent() 
		{
			
		}
		
		float x;
		float y;
		float z;
		float w;
		float h;
		float alpha;
		float scale_x;
		float scale_y;
		float rotation;
		vector2D anchorPoint;

		unsigned int _guid;
	};

	class OGLFont : public IRenderable
	{
	public:
		OGLFont (std::string fnt_filename)
		{
			init();

			loadFromFNTFile (fnt_filename);
		}
		
		~OGLFont ()
		{
			if (texture)
			{
				g_TextureManager.releaseTexture(texture);
				texture = NULL;
			}
			
		}
		void init()
		{
			IRenderable::init();
			text = NULL;
			texture = NULL;
		}
		
		void transform ();
		void renderContent();
		
		bool loadFromFNTFile (std::string fnt_filename);
		
		char *text;
		bm_font font;
		Texture2D *texture;
	};
	
	class PE_Proxy : public IRenderable
	{
	public:
		ParticleEmitter *pe;

		PE_Proxy ()
		{
			init();
		}

		PE_Proxy(std::string filename)
		{
			init();
			loadFromFile(filename);
			
		}
		
		void update (float delta)
		{
			Vector2f pos;
			pos.x = x;
			pos.y = y;
			
			[pe setSourcePosition: pos];
			[pe updateWithDelta: delta];
		}
		
		void renderContent ()
		{
			[pe renderParticles];
		}

		bool loadFromFile (std::string filename)
		{
			NSString *nsfilename = [NSString stringWithCString: filename.c_str() 
													  encoding: NSASCIIStringEncoding];
			
			pe = [[ParticleEmitter alloc] initParticleEmitterWithFile: nsfilename];
			if (pe)
				return true;
			
			return false;
		}
		
		void init()
		{
			IRenderable::init();
			
			pe = nil;
		}
		
		~PE_Proxy ()
		{
			if (pe)
			{
				//g_TextureManager.releaseTexture(texture);
				//texture = NULL;
				[pe release];
				pe = nil;
			}
		}
		
	};

	class TexturedQuad : public IRenderable
	{
	public:
		TexturedQuad();
		TexturedQuad(Texture2D *existing_texture);
		TexturedQuad(std::string filename);
		~TexturedQuad ();

		void init()
		{
			IRenderable::init();
			
			texture = NULL;
		}
		
		bool loadFromFile (std::string filename);
			
		void transform ();
		void renderContent();
		
		
		Texture2D *texture;
	};

	class TexturedBufferQuad : public IRenderable
	{
	public:
		TexturedBufferQuad();
		TexturedBufferQuad(std::string filename);
		~TexturedBufferQuad ();
		
		void init()
		{
			IRenderable::init();
			
			texture = NULL;
			alpha_mask = NULL;
		}
		
		bool loadFromFile (std::string filename);
		
		void transform ();
		void renderContent();
		
		void create_alpha_mask ();
		void apply_alpha_mask ();
		
		BufferTexture2D *texture;
		
		unsigned char *alpha_mask;
		
		void alpha_draw_circle_fill (int xc, int yc, int r, unsigned char val);
		
	protected:
		void line(unsigned char *buf,int buf_w, unsigned char val, int x1, int y1, int x2, int y2);
		void circle_fill(unsigned char *buff, int buff_w, unsigned char val, int xc, int yc, int r);
		void circle(unsigned char *buf, int buf_w, int xc, int yc, int r);
		
	};
	
	class TexturedAtlasQuad : public IRenderable
	{
	public:
		TexturedAtlasQuad();
		TexturedAtlasQuad(Texture2D *existing_texture);
		TexturedAtlasQuad(std::string filename);
		~TexturedAtlasQuad ();
		
		void init()
		{
			IRenderable::init();
			
			texture = NULL;
			src.x = src.y = src.w = src.h = 0.0;
			tex_w = tex_h = 0;
		}
		
		bool loadFromFile (std::string filename);
		
		void transform ();
		
		int tex_w;
		int tex_h;
		
		rect src;
		void renderContent ();

		Texture2D *texture;
	};


}