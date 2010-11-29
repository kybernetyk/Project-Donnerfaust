/*
 *  BlobConnectionSystem.h
 *  Donnerfaust
 *
 *  Created by jrk on 29/11/10.
 *  Copyright 2010 flux forge. All rights reserved.
 *
 */

#pragma once


#include <vector>
#include "EntityManager.h"
#include "globals.h"
using namespace mx3;

namespace game 
{
	class BlobConnectionSystem
	{
	public:
		BlobConnectionSystem (EntityManager *entityManager);
		void update (float delta);

		
		void update_map ();

	protected:
		float _delta;
		Entity *_map[BOARD_NUM_COLS][BOARD_NUM_ROWS];
		EntityManager *_entityManager;
		std::vector<Entity*> _entities;
		Entity *_current_entity;
	};
	
}