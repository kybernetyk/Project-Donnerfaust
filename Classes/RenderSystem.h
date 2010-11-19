/*
 *  RenderSystem.h
 *  components
 *
 *  Created by jrk on 5/11/10.
 *  Copyright 2010 flux forge. All rights reserved.
 *
 */

#pragma once
#include <vector>
#include "EntityManager.h"

namespace mx3 
{
	class TexturedQuad;
	class IRenderable;

	class RenderSystem
	{
	public:
		RenderSystem (EntityManager *entityManager);
		void render (void);	

	protected:
		EntityManager *_entityManager;
		
		std::vector <IRenderable *> gl_data;
		std::vector<Entity*> moveableList;
	};

}