/*
 *  GameLogicSystem.h
 *  ComponentV3
 *
 *  Created by jrk on 10/11/10.
 *  Copyright 2010 flux forge. All rights reserved.
 *
 */

#pragma once
#include <vector>
#include "EntityManager.h"
using namespace mx3;

namespace game 
{
	class GameLogicSystem
	{
	public:
		GameLogicSystem (EntityManager *entityManager);
		void update (float delta);
		
	protected:
		float _delta;
		
		EntityManager *_entityManager;
	};

}