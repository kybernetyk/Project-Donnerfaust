/*
 *  GameComponens.h
 *  ComponentV3
 *
 *  Created by jrk on 16/11/10.
 *  Copyright 2010 flux forge. All rights reserved.
 *
 */

#pragma once

#include "Component.h"

using namespace mx3;
namespace game
{
#pragma mark -
#pragma mark game 

#define BLOB_COLOR_RED 0x01
	
#define GBE_STATE_IDLE (1 << 1)
#define GBE_STATE_MOVING_FALL (1 << 2)

	
	struct GameBoardElement : public Component
	{
		static ComponentID COMPONENT_ID;
		
		int row;
		int col;
		
		int prev_row;
		int prev_col;
		
		int type;
		
		unsigned int state;
		int prev_state;

		float y_move_timer;
		float y_off;
		
		float fall_duration;
		
		GameBoardElement ()
		{
			_id = COMPONENT_ID;
			prev_row = prev_col = row = col = 0;
			type = BLOB_COLOR_RED;
			prev_state = state = GBE_STATE_IDLE;
			y_off = 0.0;
			y_move_timer = 0.0;

			fall_duration = 0.1;
		}
		
		DEBUGINFO ("Game Board Element. ")
	};
	
	
#define PC_STATE_IDLE (1 << 1)
#define PC_STATE_MOVING_FALL (1 << 2)

	struct PlayerController : public Component
	{
		static ComponentID COMPONENT_ID;

		int left_or_right;
		int top_or_bottom;

		int config;
		
		int col;
		int row;
		
		int type;
		
		int state;
		
		float y_timer;
		
		float fall_idle_time;
		float fall_active_time;
		
		float collision_grace_timer;
		float collision_grace_time;
		
		bool is_aux_left;
		bool is_aux_right;
		
		PlayerController ()
		{
			_id = COMPONENT_ID;
			left_or_right = LEFT;
			top_or_bottom = TOP;
			col = row = 0;
			type = BLOB_COLOR_RED;
			state = PC_STATE_IDLE;
			config = HORIZONTAL;
			y_timer = 0.0;
			
			fall_idle_time = 1.0;
			fall_active_time = 0.3;
			collision_grace_time = 1.0;
			collision_grace_timer = 0.0;
			is_aux_left = true;
			is_aux_right = false;
		}
		
		DEBUGINFO ("Player Controller")
	};
	
}
