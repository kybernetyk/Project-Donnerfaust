/*
 *  TextureManager.h
 *  ComponentV3
 *
 *  Created by jrk on 16/11/10.
 *  Copyright 2010 flux forge. All rights reserved.
 *
 */
#pragma once

#include <map>
#include "Texture2D.h"
namespace mx3 
{
	class TextureManager
	{
	public:
		Texture2D *accquireTexture (std::string filename);
		void releaseTexture (Texture2D *pTexture);
		
	protected:
		std::map <std::string, int> _referenceCounts;
		std::map <std::string, Texture2D *> _textures;
	};

}

extern mx3::TextureManager g_TextureManager;
