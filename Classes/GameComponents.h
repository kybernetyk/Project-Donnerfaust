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
	

#define GBE_STATE_MOVING_LEFT (1 << 1)
#define GBE_STATE_MOVING_RIGHT (1 << 2)
#define GBE_STATE_MOVING_FALL (1 << 3)
	
#define GBE_STATE_READY_TO_MOVE_LEFT (1 << 4)
#define GBE_STATE_READY_TO_MOVE_RIGHT (1 << 5)
#define GBE_STATE_READY_TO_FALL (1 << 6)
	
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

		float x_move_timer;
		float y_move_timer;
		
		float x_off;
		float y_off;
		
		float fall_duration;
		float fall_idle_time;
		
		GameBoardElement ()
		{
			_id = COMPONENT_ID;
			prev_row = prev_col = row = col = 0;
			type = BLOB_COLOR_RED;
			prev_state = state = GBE_STATE_READY_TO_FALL;
			x_off = 0.0;
			y_off = 0.0;
			x_move_timer = y_move_timer = 0.0;

			fall_duration = 0.3;
			fall_idle_time = 1.3;
		}
		
		DEBUGINFO ("Game Board Element. ")
	};
	
	struct PlayerController : public Component
	{
		static ComponentID COMPONENT_ID;
		float lifetime;
		PlayerController ()
		{
			_id = COMPONENT_ID;
			lifetime = -1.0;
		}
		
		DEBUGINFO ("Player Controller")
	};
	
}
