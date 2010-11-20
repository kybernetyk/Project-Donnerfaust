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
		bool move_left = false;
		bool move_right = false;
		
		move_left = InputDevice::sharedInstance()->getLeftActive();
		move_right = InputDevice::sharedInstance()->getRightActive();
		
		if (!move_left && !move_right)
			return;
		
		std::vector<Entity*> entities;
		
		_entityManager->getEntitiesPossessingComponents(entities,  PlayerController::COMPONENT_ID,Position::COMPONENT_ID, ARGLIST_END );
		std::vector<Entity*>::const_iterator it = entities.begin();
		
		Entity *current_entity = NULL;
		while (it != entities.end())
		{
			current_entity = *it;

			WaitingForMove *wfm = new WaitingForMove();
			if (move_left)
				wfm->direction = MOVE_LEFT;
			else
				wfm->direction = MOVE_RIGHT;
			
			_entityManager->addComponent(current_entity, wfm);

			

			++it;
		}
	}

}