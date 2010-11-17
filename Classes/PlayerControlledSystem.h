/*
 *  PlayerControlledSystem.h
 *  ComponentV3
 *
 *  Created by jrk on 8/11/10.
 *  Copyright 2010 flux forge. All rights reserved.
 *
 */
#pragma once
#include <vector>
#include "EntityManager.h"
using namespace mx3;

namespace game
{
	class PlayerControlledSystem
	{
	public:
		PlayerControlledSystem (EntityManager *entityManager);
		void update (float delta);	
	protected:
		EntityManager *_entityManager;
	};
	
}

