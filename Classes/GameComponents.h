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
	
#define FALLING 0
#define RESTING 1
#define COLLIDING 2
	
#define BLOB_COLOR_RED 0
	
	struct Collidable : public Component
	{
		static ComponentID COMPONENT_ID;
		
		bool ignore;
		
		Collidable ()
		{
			_id = COMPONENT_ID;
			ignore = false;
		}			
		DEBUGINFO("Collidable")
	};
	
	struct FallingState : public Component
	{
		static ComponentID COMPONENT_ID;
		
		bool handled;
		
		FallingState ()
		{
			_id = COMPONENT_ID;
			handled = false;
		}			
		DEBUGINFO("Coliding state")
	};

	struct LandingState : public Component
	{
		static ComponentID COMPONENT_ID;

		bool handled;

		LandingState ()
		{
			_id = COMPONENT_ID;
			handled = false;
		}			
		DEBUGINFO("Landing State")
	};

	struct RestingState : public Component
	{
		static ComponentID COMPONENT_ID;

		bool handled;

		RestingState ()
		{
			_id = COMPONENT_ID;
			handled = false;
		}			
		DEBUGINFO("Resting state")
	};
	
				  
#define CONNECTION_NONE 0
#define CONNECTION_UP 1
#define CONNECTION_RIGHT 2
#define CONNECTION_DOWN 4
#define CONNECTION_LEFT 8	
	struct GameBoardElement : public Component
	{
		static ComponentID COMPONENT_ID;
		
		int row;
		int col;
		int type;
		int connection_state;
		
		int _prev_connection_state;
		
		GameBoardElement ()
		{
			_id = COMPONENT_ID;
			row = col = 0;
			type = BLOB_COLOR_RED;
			_prev_connection_state = connection_state = CONNECTION_NONE;
			
		}
		
		DEBUGINFO ("Game Board Element. row: %i, col: %i, type: %i, connection: %i",row,col,type, connection_state)
	};
	
	struct PlayerController : public Component
	{
		static ComponentID COMPONENT_ID;
		
		PlayerController ()
		{
			_id = COMPONENT_ID;
		}
		
		DEBUGINFO ("Player Controller")
	};
	
	struct Enemy : public Component
	{
		static ComponentID COMPONENT_ID;
		
		bool has_been_handled;
		float origin_x;
		float origin_y;
		
		Enemy ()
		{
			_id = COMPONENT_ID;
			has_been_handled = false;
			origin_x = origin_y = 0.0;
		}
		
		DEBUGINFO ("Enemy. has_been_handled: %i origin_x: %f origin_y: %f", has_been_handled, origin_x, origin_y)
	};

}
