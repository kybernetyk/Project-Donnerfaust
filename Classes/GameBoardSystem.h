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
		bool can_move_down ();
		
		void move_down();
		
	
		void handle_state_idle ();
		void handle_state_falling ();
		
		Entity *_map[BOARD_NUM_COLS][BOARD_NUM_ROWS];
		void update_map ();
		
		Entity *_current_entity;
		
		EntityManager *_entityManager;
		GameBoardElement *_current_gbe;
		Position *_current_position;
		std::vector<Entity*> _entities;
		float _delta;
	};
	
}

