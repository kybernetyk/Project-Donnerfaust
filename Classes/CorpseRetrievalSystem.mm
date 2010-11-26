/*
 *  CorpseRetrievalSystem.cpp
 *  ComponentV3
 *
 *  Created by jrk on 10/11/10.
 *  Copyright 2010 flux forge. All rights reserved.
 *
 */

#include "CorpseRetrievalSystem.h"
namespace mx3 
{
	
	

	CorpseRetrievalSystem::CorpseRetrievalSystem (EntityManager *entityManager)
	{
		_entityManager = entityManager;
	}

	void CorpseRetrievalSystem::collectCorpses ()
	{
		std::vector<Entity*> _entities;
		
		_entityManager->getEntitiesPossessingComponent (_entities,MarkOfDeath::COMPONENT_ID);
			
		std::vector<Entity*>::const_iterator it = _entities.begin();
		Entity *current_entity = NULL;
		while (it != _entities.end())
		{
			current_entity = *it;
			++it;
			
			_entityManager->removeEntity(current_entity->_guid);
		}
		
		
	}

}