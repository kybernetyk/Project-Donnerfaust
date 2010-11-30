/*
 *  GameBoardSystem.cpp
 *  Donnerfaust
 *
 *  Created by jrk on 17/11/10.
 *  Copyright 2010 flux forge. All rights reserved.
 *
 */

#include "GameBoardSystem.h"
#include "GameComponents.h"
#include "GameActionSystem.h"

namespace game 
{
	GameBoardSystem::GameBoardSystem (EntityManager *entityManager)
	{
		_entityManager = entityManager;
		memset(_map,0x00,BOARD_NUM_COLS*BOARD_NUM_ROWS*sizeof(Entity*));
	}
	
	void GameBoardSystem::update_map ()
	{
		memset(_map,0x00,BOARD_NUM_COLS*BOARD_NUM_ROWS*sizeof(Entity*));
		
		std::vector<Entity*>::const_iterator it = _entities.begin();
		_current_entity = NULL;
		_current_gbe = NULL;
		while (it != _entities.end())
		{
			_current_entity = *it;
			++it;
			_current_gbe = _entityManager->getComponent<GameBoardElement>(_current_entity);
			
			if ((_current_gbe->state == GBE_STATE_IDLE))
				_map[_current_gbe->col][_current_gbe->row] = _current_entity;
		}
	}
	
	
	bool GameBoardSystem::can_move_down ()
	{
		if (_current_gbe->row - 1 < 0)
			return false;
		
		int row = _current_gbe->row - 1;
		int col = _current_gbe->col;
		
		if (_map[col][row])
			return false;
		
		return true;
	}
	
	
	void GameBoardSystem::move_down ()
	{
	}
	

	void GameBoardSystem::handle_state_idle ()
	{
		if (can_move_down())
		{
//			_current_gbe->state &= (~GBE_STATE_IDLE);
//			_current_gbe->state |= GBE_STATE_MOVING_FALL;
			_current_gbe->state = GBE_STATE_MOVING_FALL;

			_current_gbe->prev_row = _current_gbe->row;
			_current_gbe->y_move_timer = 0.0;

			_current_gbe->landed = false;  //remove this if you don't want falling blob neighbours to reconnect with the falling blob
		}
		else
		{
			_current_gbe->landed = true;
		}
	}

	void GameBoardSystem::handle_state_falling ()
	{
		//_current_gbe->landed = false;
		_current_gbe->y_move_timer += _delta;
		_current_gbe->y_off -= _delta * (32.0/_current_gbe->fall_duration);	
		
		if (_current_gbe->y_move_timer >= _current_gbe->fall_duration)
		{
			//_current_gbe->state |= (GBE_STATE_IDLE);
			//_current_gbe->state &= (~GBE_STATE_MOVING_FALL);

			_current_gbe->state = GBE_STATE_IDLE;
			
			_current_gbe->row --;
			_current_gbe->y_off = 0.0;
			_current_gbe->y_move_timer = 0.0;
		}
		
	}

	
	void GameBoardSystem::update (float delta)
	{
		_delta = delta;
		/* create collision map */	
		_entities.clear();
		_entityManager->getEntitiesPossessingComponents(_entities,  GameBoardElement::COMPONENT_ID, ARGLIST_END );
		update_map();
		
		std::vector<Entity*>::const_iterator it = _entities.begin();
		
		//mark columns to drop down and remove sideways connections (remove the connection fizzling if you want 
		//the blobs not to reconnect when they drop down while touching a friendblob sideways.
		for (int col = 0; col < BOARD_NUM_COLS; col ++)
		{
			for (int row = 0; row < BOARD_NUM_ROWS; row ++)
			{
				if (!_map[col][row])
				{
					for (int j = row; j < BOARD_NUM_ROWS; j++)
					{
						Entity *ee = _map[col][j];
						if (ee)
						{
							GameBoardElement *g = _entityManager->getComponent<GameBoardElement>(ee);
							
							if ( (g->connection_state & GBE_CONNECTED_TO_LEFT) ||
								 (g->connection_state & GBE_CONNECTED_TO_RIGHT))
							{
								g->connection_state &= (~GBE_CONNECTED_TO_LEFT);
								g->connection_state &= (~GBE_CONNECTED_TO_RIGHT);
								
								if (g->connection_state == 0)
									g->connection_state = GBE_CONNECTED_NONE;
								
								_entityManager->addComponent <NeedsAnimation> (ee);
							}
						}
						_map[col][j] = NULL;
					}
				}
			}
		}
		
		_current_entity = NULL;
		_current_gbe = NULL;
		while (it != _entities.end())
		{
			_current_entity = *it;
			++it;
			_current_gbe = _entityManager->getComponent<GameBoardElement>(_current_entity);
			_current_position = _entityManager->getComponent<Position>(_current_entity);

			if ((_current_gbe->state == GBE_STATE_IDLE))
				handle_state_idle();
			if (_current_gbe->state == GBE_STATE_MOVING_FALL)
				handle_state_falling ();

			
			//_current_position->x = _current_gbe->col * 32.0 + BOARD_X_OFFSET + _current_gbe->x_off;
			_current_position->y = _current_gbe->row * 32.0 + BOARD_Y_OFFSET + _current_gbe->y_off;
		}

	}
	
}
