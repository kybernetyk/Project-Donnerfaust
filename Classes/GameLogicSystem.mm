/*
 *  GameLogicSystem.cpp
 *  ComponentV3
 *
 *  Created by jrk on 10/11/10.
 *  Copyright 2010 flux forge. All rights reserved.
 *
 */

#include "GameLogicSystem.h"
#include "Texture2D.h"
#include "SoundSystem.h"
#include "globals.h"
#include "ActionSystem.h"
#include "InputDevice.h"

namespace game 
{


	GameLogicSystem::GameLogicSystem (EntityManager *entityManager)
	{
		_entityManager = entityManager;
	}



	void GameLogicSystem::update (float delta)
	{
		_delta = delta;

		vector2D v = InputDevice::sharedInstance()->touchLocation();
		
		bool touch = InputDevice::sharedInstance()->touchUpReceived();
		
		std::vector<Entity*> entities;
		
		_entityManager->getEntitiesPossessingComponents(entities, GameBoardElement::COMPONENT_ID, Position::COMPONENT_ID, ARGLIST_END );
		std::vector<Entity*>::const_iterator it = entities.begin();
		
		Entity *current_entity = NULL;
		
		while (it != entities.end())
		{
			current_entity = *it;
			++it;
			
			if (touch)
			{
				Position *pos = _entityManager->getComponent<Position>(current_entity);
				
			//	printf("touch: %f,%f <-> pos: %f,%f\n", v.x,v.y,pos->x,pos->y);
				
				if (v.x+16 >= pos->x && v.y+16 >= pos->y &&
					v.x+16 < pos->x+32 && v.y+16 < pos->y + 32)
				{
					_entityManager->addComponent <MarkOfDeath> (current_entity); 
				}
			}
			
		}
	}
}