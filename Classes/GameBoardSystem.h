/*
 *  GameBoardSystem.h
 *  Donnerfaust
 *
 *  Created by jrk on 17/11/10.
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
	class GameBoardSystem
	{
	public:
		GameBoardSystem (EntityManager *entityManager);
		void update (float delta);	
	protected:
		Entity *_map[BOARD_NUM_COLS][BOARD_NUM_ROWS];
		void refresh_map ();
		
		bool can_fall (Entity *e);
		bool can_move_left (Entity *e);
		bool can_move_right (Entity *e);
		
		void move_elements();
		void move_elements_siedways();
		void dump_map();
		void mark_connections();
		
		EntityManager *_entityManager;
		std::vector<Entity*> _entities;
	};
	
}

