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
#include "globals.h"
#include "GameComponents.h"
using namespace mx3;

namespace game
{
	class PlayerControlledSystem
	{
	public:
		PlayerControlledSystem (EntityManager *entityManager);
		void update (float delta);	
	protected:
		bool can_move_down (PlayerController *pc);
		bool can_move_left (PlayerController *pc);
		bool can_move_right(PlayerController *pc);

	//TODO: rename right blob and left blob to: left blob -> center blob, right blob -> rotating blob		
		EntityManager *_entityManager;
		
		Entity *_map[BOARD_NUM_COLS][BOARD_NUM_ROWS];
		void update_map ();
		
		std::vector<Entity*> _entities;
		float _delta;
	};
	
}

