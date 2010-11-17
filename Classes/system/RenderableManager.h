/*
 *  RenderableManager.h
 *  ComponentV3
 *
 *  Created by jrk on 16/11/10.
 *  Copyright 2010 flux forge. All rights reserved.
 *
 */

#pragma once

#include <map>
namespace mx3 
{
	
		
	class TexturedQuad;
	class TexturedAtlasQuad;
	class OGLFont;
	class IRenderable;


	class RenderableManager
	{
	public:
		TexturedQuad *accquireTexturedQuad (std::string filename);
		TexturedAtlasQuad *accquireTexturedAtlasQuad (std::string filename);
		OGLFont *accquireOGLFont (std::string filename);
		
		void release (IRenderable *pRenderable);
		
	protected:
		std::map <std::string, int> _referenceCounts;
		std::map <std::string, IRenderable *> _renderables;
	};

}