/*
 *  Entity.cpp
 *  components
 *
 *  Created by jrk on 3/11/10.
 *  Copyright 2010 flux forge. All rights reserved.
 *
 */
#import "EntityManager.h"
#import "Entity.h"


namespace mx3 
{
	
	EntityManager *Entity::entityManager = NULL;

	Entity::Entity(EntityGUID _id)
	{
		checksum = 0;
		_guid = _id;
		entityManager->registerEntity(this);
	}

	Component *Entity::getById (ComponentID _id)
	{
		return entityManager->getComponent(this, _id);
	}

}