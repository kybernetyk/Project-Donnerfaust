/*
 *  PlayerControlledSystem.cpp
 *  ComponentV3
 *
 *  Created by jrk on 8/11/10.
 *  Copyright 2010 flux forge. All rights reserved.
 *
 */

#include "Util.h"
#include "PlayerControlledSystem.h"
#include "InputDevice.h"
namespace game 
{
		
		
	PlayerControlledSystem::PlayerControlledSystem (EntityManager *entityManager)
	{
		_entityManager = entityManager;
	}


	void PlayerControlledSystem::update (float delta)
	{
		vector2D v;
		
		if (InputDevice::sharedInstance()->touchUpReceived())
			v = InputDevice::sharedInstance()->touchLocation();
		 else
			return;
		
		std::vector<Entity*> entities;
		
		_entityManager->getEntitiesPossessingComponents(entities,  PlayerController::COMPONENT_ID,Position::COMPONENT_ID, ARGLIST_END );
		std::vector<Entity*>::const_iterator it = entities.begin();
		
		Entity *current_entity = NULL;
		while (it != entities.end())
		{
			current_entity = *it;
			
	
			++it;
		}
	}

}