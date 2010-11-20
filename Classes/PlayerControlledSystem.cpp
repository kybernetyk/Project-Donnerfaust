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
		
		
		
		std::vector<Entity*> entities;
		
		_entityManager->getEntitiesPossessingComponents(entities,  PlayerController::COMPONENT_ID,Position::COMPONENT_ID, ARGLIST_END );
		std::vector<Entity*>::const_iterator it = entities.begin();
		
		Entity *current_entity = NULL;
		GameBoardElement *gbe = NULL;
		PlayerController *pc = NULL;
		while (it != entities.end())
		{
			current_entity = *it;
			++it;
			
			gbe = _entityManager->getComponent <GameBoardElement>(current_entity);
			pc = _entityManager->getComponent <PlayerController>(current_entity);
			
			if (pc)
			{
				if (pc->lifetime > -1.0)
				{
					pc->lifetime -= delta;
					if (pc->lifetime <= 0.0)
						_entityManager->removeComponent <PlayerController>(current_entity);
				}
				
			}
			
			if (move_left)
				gbe->state |= GBE_STATE_READY_TO_MOVE_LEFT;
			if (move_right)
				gbe->state |= GBE_STATE_READY_TO_MOVE_RIGHT;
			
		}
	}

}