/*
 *  Entity.h
 *  components
 *
 *  Created by jrk on 3/11/10.
 *  Copyright 2010 flux forge. All rights reserved.
 *
 */

#pragma once
#include <stdio.h>
#include <map>
#include <set>
#import "types.h"
#include "Component.h"
//#include "EntityManager.h"
//class EntityManager;
namespace mx3 
{
		
		
	class EntityManager;


	#define ENTITY_CACHE_SIZE 32

	class Entity
	{
	public:
		static EntityManager *entityManager;
		EntityGUID _guid;
		Entity(EntityGUID _id);
		
		//this is only a convinience method. don't use it in performance critical parts as you do 3 method calls herein
		//use EntityManager::getComponent<Type>() instead for speed.
		template<typename Type> Type *get ()
		{
			//	return entityManager->getComponent<Type>(this);	
			
			return (Type*)getById(Type::COMPONENT_ID);
		}
		
		Component *getById (ComponentID _id);	//proxy method because templates suck, are .h only and .h cross inclusion is holocaust
		
		unsigned int checksum;
	};

}