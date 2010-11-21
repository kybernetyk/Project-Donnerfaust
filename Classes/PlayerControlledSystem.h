/*
 *  PlayerControlledSystem.h
 *  ComponentV3
 *
 *  Created by jrk on 8/11/10.
 *  Copyright 2010 flux forge. All rights reserved.
 *
 */
#pragma once
#include <vector>
#include "EntityManager.h"
using namespace mx3;

namespace game
{
	class PlayerControlledSystem
	{
	public:
		PlayerControlledSystem (EntityManager *entityManager);
		void update (float delta);	
	protected:
		bool can_move_down ();
		bool can_move_left ();
		bool can_move_right();
		
		void move_down ();
		
		bool left_active;
		bool right_active;
		
		EntityManager *_entityManager;
		
		Entity *_map[BOARD_NUM_COLS][BOARD_NUM_ROWS];
		void update_map ();
		
		Entity *_current_entity;
		GameBoardElement *_current_gbe;
		Position *_current_position;
		std::vector<Entity*> _entities;
		float _delta;
		PlayerController *_current_pc;
	};
	
}

