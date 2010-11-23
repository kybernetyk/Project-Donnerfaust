/*
 *  TextureManager.cpp
 *  ComponentV3
 *
 *  Created by jrk on 16/11/10.
 *  Copyright 2010 flux forge. All rights reserved.
 *
 */

#include "TextureManager.h"
namespace mx3 
{
		
		
	Texture2D *TextureManager::accquireTexture (std::string filename)
	{
		if (_referenceCounts[filename] > 0)
		{
			_referenceCounts[filename] ++;
			return _textures[filename];
		}

		Texture2D *ret = new Texture2D(filename);
		if (!ret)
			return NULL;

		_textures[filename] = ret;
		_referenceCounts[filename] = 1;
		return ret;
	}

	void TextureManager::releaseTexture (Texture2D *pTexture)
	{
		if (!pTexture)
			return;
		
		std::string filename = pTexture->_filename;
		_referenceCounts[filename] --;
		if (_referenceCounts[filename] <= 0)
		{
			Texture2D *p = _textures[filename];
			_textures[filename] = NULL;
			delete p;
			_referenceCounts[filename] = 0;
		}
	}

}

mx3::TextureManager g_TextureManager;
