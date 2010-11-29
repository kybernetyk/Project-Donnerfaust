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

#define BLOB_COLOR_RED 0x00
#define BLOB_COLOR_GREEN 0x01
#define BLOB_COLOR_BLUE 0x02
#define BLOB_COLOR_YELLOW 0x03
	
#define GBE_STATE_IDLE 0
#define GBE_STATE_MOVING_FALL 1

#define GBE_CONNECTED_NONE (1 << 0)	
#define GBE_CONNECTED_TO_UP (1 << 1)
#define GBE_CONNECTED_TO_LEFT (1 << 2)
#define GBE_CONNECTED_TO_DOWN (1 << 3)
#define GBE_CONNECTED_TO_RIGHT (1 << 4)	
	
	struct GameBoardElement : public Component
	{
		static ComponentID COMPONENT_ID;
		
		int row;
		int col;
		
		int prev_row;
		int prev_col;
		
		int type;
		
		unsigned int state;

		float y_move_timer;
		float y_off;
		
		float fall_duration;
		bool landed;
		bool must_be_animated;
		unsigned int connection_state;
		unsigned int prev_connection_state;
		unsigned int animation_state;
		
		GameBoardElement ()
		{
			_id = COMPONENT_ID;
			prev_row = prev_col = row = col = 0;
			type = BLOB_COLOR_RED;
			state = GBE_STATE_IDLE;
			animation_state = prev_connection_state = connection_state = 0;// GBE_CONNECTED_NONE;
			y_off = 0.0;
			y_move_timer = 0.0;
			landed = false;
			must_be_animated = false;
	
			printf("8 = %i\n",GBE_CONNECTED_TO_DOWN);
			fall_duration = 0.1;
		}
		
		DEBUGINFO ("Game Board Element. connection state = %i, prev con = %i, animation state = %i ", connection_state, prev_connection_state, animation_state)
	};
	
	
#define PC_STATE_IDLE (1 << 1)
#define PC_STATE_MOVING_FALL (1 << 2)
#define PC_STATE_ROTATING (1 << 3)

	struct PlayerController : public Component
	{
		static ComponentID COMPONENT_ID;

		int center_or_aux;		//CENTER = the blob that is the center of rotation, AUX = the blob that rotates around the center
		
		
		int config;				//the configuration of the player blobs. either HORIZONTAL or VERTICAL
		
		int col;				//curent column
		int row;				//current row
		
		int type;				//color type
		
		int state;				//current state of this controller (FALLING, IDLE, ROTATING)
		
		float _y_timer;			//timer for fall - internal use
		
		float fall_idle_time;	//how much time the blob is "idle" during the fall (not moving)
		float fall_active_time;	//how much time the blob uses for the fall part of the FALLING state. (idle + active = time to move one row down)
		
		float _collision_grace_timer;	//timer for collision grace period - internal use
		float collision_grace_time;		//how long is the collision grace period?

		int top_or_bottom;		//TOP = blob is the top one in the combo, BOTTOM = ...
		int left_or_right;		//LEFT = blob is the left one in the combo, RIGHT = ...	
		
		float rotation_angle;	//current rotation angle of the aux blob rotating around the center
		float _rotation_timer;	//timer for rotation - internal use
		
		PlayerController ()
		{
			_id = COMPONENT_ID;
			center_or_aux = CENTER;
			top_or_bottom = TOP;
			col = row = 0;
			type = BLOB_COLOR_RED;
			state = PC_STATE_IDLE;
			config = HORIZONTAL;
			_y_timer = 0.0;
			rotation_angle = 90.0;
			fall_idle_time = 1.0;
			fall_active_time = 0.3;
			collision_grace_time = 1.0;
			_collision_grace_timer = 0.0;
			left_or_right = LEFT;
			_rotation_timer = 90.0;
		}
		
		DEBUGINFO ("Player Controller")
	};
	
}
