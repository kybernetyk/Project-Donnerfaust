/*
 *  AnimationSystem.h
 *  ComponentV3
 *
 *  Created by jrk on 14/11/10.
 *  Copyright 2010 flux forge. All rights reserved.
 *
 */

#pragma once
#include <vector>
#include "EntityManager.h"
#include "Entity.h"
namespace mx3 
{
	
		
	class AnimationSystem
	{
	public:
		AnimationSystem (EntityManager *entityManager);
		void setupNextAnimationOrStop (Entity *e, FrameAnimation *current_animation);
		void update (float delta);	
		
	protected:
		EntityManager *_entityManager;
		std::vector<Entity*> _entities;
	};

}