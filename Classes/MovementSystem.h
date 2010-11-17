/*
 *  MovementSystem.h
 *  components
 *
 *  Created by jrk on 5/11/10.
 *  Copyright 2010 flux forge. All rights reserved.
 *
 */
#pragma once
#include <vector>
#include "EntityManager.h"
#include "Entity.h"
namespace mx3 
{
	
		
	class MovementSystem
	{
	public:
		MovementSystem (EntityManager *entityManager);
		void update (float delta);	

	protected:
		EntityManager *_entityManager;
		std::vector<Entity*> moveableList;
	};

}