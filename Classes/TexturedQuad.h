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
#include "globals.h"
#include "TextureManager.h"
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
		
		
		virtual void renderContent()
		{
			//no op
		};
		
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
			IRenderable::IRenderable();
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