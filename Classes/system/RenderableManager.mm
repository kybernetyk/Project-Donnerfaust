/*
 *  RenderableManager.cpp
 *  ComponentV3
 *
 *  Created by jrk on 16/11/10.
 *  Copyright 2010 flux forge. All rights reserved.
 *
 */

#include "RenderableManager.h"
#include "TexturedQuad.h"
namespace mx3 
{
		
		
	TexturedQuad *RenderableManager::accquireTexturedQuad (std::string filename)
	{
		if (_referenceCounts[filename] > 0)
		{
			_referenceCounts[filename] ++;
			return (TexturedQuad*)_renderables[filename];
		}
		
		TexturedQuad *ret = new TexturedQuad(filename);
		if (!ret)
			return NULL;
		
		_renderables[filename] = ret;
		_referenceCounts[filename] = 1;
		return ret;
	}

	TexturedBufferQuad *RenderableManager::accquireBufferedTexturedQuad (std::string filename)
	{
		if (_referenceCounts[filename] > 0)
		{
			_referenceCounts[filename] ++;
			return (TexturedBufferQuad*)_renderables[filename];
		}
		
		TexturedBufferQuad *ret = new TexturedBufferQuad(filename);
		if (!ret)
			return NULL;
		
		_renderables[filename] = ret;
		_referenceCounts[filename] = 1;
		return ret;
	}
	
	

	TexturedAtlasQuad *RenderableManager::accquireTexturedAtlasQuad (std::string filename)
	{
		if (_referenceCounts[filename] > 0)
		{
			_referenceCounts[filename] ++;
			return (TexturedAtlasQuad*)_renderables[filename];
		}
		
		TexturedAtlasQuad *ret = new TexturedAtlasQuad(filename);
		if (!ret)
			return NULL;
		
		_renderables[filename] = ret;
		_referenceCounts[filename] = 1;
		return ret;
		
	}


	OGLFont *RenderableManager::accquireOGLFont (std::string filename)
	{
		if (_referenceCounts[filename] > 0)
		{
			_referenceCounts[filename] ++;
			return (OGLFont*)_renderables[filename];
		}
		
		OGLFont *ret = new OGLFont(filename);
		if (!ret)
			return NULL;
		
		_renderables[filename] = ret;
		_referenceCounts[filename] = 1;
		return ret;
		
	}
	
	PE_Proxy *RenderableManager::accquireParticleEmmiter (std::string filename)
	{
		return new PE_Proxy(filename);
	}

	void RenderableManager::release (IRenderable *pRenderable)
	{
		if (!pRenderable)
			return;
		
		std::string filename = pRenderable->_filename;
		
		_referenceCounts[filename] --;
		if (_referenceCounts[filename] <= 0)
		{
			IRenderable *p = _renderables[filename];
			_renderables[filename] = NULL;
			delete p;
			_referenceCounts[filename] = 0;
		}
	}


}

mx3::RenderableManager g_RenderableManager;
