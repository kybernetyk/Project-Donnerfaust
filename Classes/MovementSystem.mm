/*
 *  MovementSystem.cpp
 *  components
 *
 *  Created by jrk on 5/11/10.
 *  Copyright 2010 flux forge. All rights reserved.
 *
 */

#import "MovementSystem.h"
#import "EntityManager.h"
#import "Component.h"
#import "Entity.h"
namespace mx3 
{
		
		
	MovementSystem::MovementSystem (EntityManager *entityManager)
	{
		_entityManager = entityManager;
	}


	void MovementSystem::update (float delta)
	{
		moveableList.clear();
		_entityManager->getEntitiesPossessingComponents (moveableList, Position::COMPONENT_ID, Movement::COMPONENT_ID, ARGLIST_END);

		std::vector<Entity*>::const_iterator it = moveableList.begin();

		//printf("movement system updating with delta %f on %i entities ...\n",delta,moveableList.size());

		
		Entity *current_entity = NULL;
		Position *pos = NULL;
		Movement *mov = NULL;
		while (it != moveableList.end())
		{
			current_entity = *it;
			//pos = current_entity->getComponentCached<Position>();
			//mov = current_entity->getComponentCached<Movement>();
		//	pos = _entityManager->getComponent<Position>(current_entity);
		//	mov = _entityManager->getComponent<Movement>(current_entity);
		

			
			//that's the "right" way - but there's 2 function calls 
				pos = _entityManager->getComponent<Position>(current_entity);
				mov = _entityManager->getComponent<Movement>(current_entity);

			
			
	//		pos = (Position*)current_entity->_components[Position::COMPONENT_ID];
	//		mov = (Movement*)current_entity->_components[Movement::COMPONENT_ID];
			
			pos->x += (mov->vx * delta);
			pos->y += (mov->vy * delta);
			
			++it;
		}
		
	}

}