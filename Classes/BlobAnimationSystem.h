/*
 *  BlobAnimationSystem.h
 *  Donnerfaust
 *
 *  Created by jrk on 17/11/10.
 *  Copyright 2010 flux forge. All rights reserved.
 *
 */
#pragma once
#include <vector>
#include "EntityManager.h"
#include "globals.h"
#include "Component.h"
using namespace mx3;

namespace game
{
	class BlobAnimationSystem
	{
	public:
		BlobAnimationSystem (EntityManager *entityManager);
		void update (float delta);	
		
	protected:
		void appendAnimation (Entity *e, FrameAnimation *anim );
		void check_for_consistency();
		EntityManager *_entityManager;
		std::vector<Entity*> _entities;
	};
	
}

