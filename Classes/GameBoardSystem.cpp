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
			
			if ((_current_gbe->state & GBE_STATE_READY_TO_FALL))
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
	bool GameBoardSystem::can_move_left ()
	{
		if ( (_current_gbe->state & GBE_STATE_MOVING_RIGHT) ||
			(_current_gbe->state & GBE_STATE_MOVING_LEFT))
			return false;

		if (_current_gbe->col - 1 < 0)
			return false;
		
		int row = _current_gbe->row;
		int col = _current_gbe->col-1;
		
		if (_map[col][row])
			return false;
		
		return true;
	}
	bool GameBoardSystem::can_move_right ()
	{
		if ( (_current_gbe->state & GBE_STATE_MOVING_RIGHT) ||
			(_current_gbe->state & GBE_STATE_MOVING_LEFT))
			return false;
		
		if (_current_gbe->col + 1 > BOARD_NUM_COLS)
			return false;
		
		int row = _current_gbe->row;
		int col = _current_gbe->col+1;
		
		if (_map[col][row])
			return false;
		
		return true;
	}
	
	
	void GameBoardSystem::move_down ()
	{
	}
	

	void GameBoardSystem::handle_state_ready_to_fall ()
	{
		if (can_move_down())
		{
			_current_gbe->state &= (~GBE_STATE_READY_TO_FALL);
			_current_gbe->state |= GBE_STATE_MOVING_FALL;
			_current_gbe->prev_row = _current_gbe->row;
			_current_gbe->y_move_timer = 0.0;

			PlayerController *pc = _entityManager->getComponent<PlayerController>(_current_entity);
			if (pc)
			{
				if (pc->lifetime > -1.0)
				{	
					pc->lifetime = -1.0;
				}
			}
			
		}
		else
		{
			PlayerController *pc = _entityManager->getComponent<PlayerController>(_current_entity);
			if (pc)
			{
				if (pc->lifetime < 0)
				{	
					pc->lifetime = 1.5;
				}
			}
			
		}
	}
	
	void GameBoardSystem::handle_state_ready_to_move_left ()
	{
		if (can_move_left())
		{
			_current_gbe->state &= (~GBE_STATE_READY_TO_MOVE_LEFT);
			_current_gbe->state |= (GBE_STATE_MOVING_LEFT);
			_current_gbe->prev_col = _current_gbe->col;
			_current_gbe->x_move_timer = 0.0;
			_current_gbe->x_off = 0.0;
		}
		else
		{
			_current_gbe->state &= (~GBE_STATE_READY_TO_MOVE_LEFT);
		}
	}

	void GameBoardSystem::handle_state_ready_to_move_right ()
	{
		if (can_move_right())
		{
			_current_gbe->state &= (~GBE_STATE_READY_TO_MOVE_RIGHT);
			_current_gbe->state |= (GBE_STATE_MOVING_RIGHT);
			_current_gbe->prev_col = _current_gbe->col;
			_current_gbe->x_move_timer = 0.0;
			_current_gbe->x_off = 0.0;
		}
		else
		{
			_current_gbe->state &= (~GBE_STATE_READY_TO_MOVE_RIGHT);
		}
	}
	
	
	void GameBoardSystem::handle_state_falling ()
	{
		if (!can_move_down())
		{
			_current_gbe->state |= (GBE_STATE_READY_TO_FALL);
			_current_gbe->state &= (~GBE_STATE_MOVING_FALL);
			_current_gbe->y_off = 0.0;
			_current_gbe->y_move_timer = 0.0;

			return;
		}
		
		_current_gbe->y_move_timer += _delta;
		
		if (_current_gbe->y_move_timer >= _current_gbe->fall_idle_time)
			_current_gbe->y_off -= _delta * (32.0/_current_gbe->fall_duration);	
		
		
		if (_current_gbe->y_move_timer >= (_current_gbe->fall_duration+_current_gbe->fall_idle_time))
		{
			_current_gbe->state |= (GBE_STATE_READY_TO_FALL);
			_current_gbe->state &= (~GBE_STATE_MOVING_FALL);

			_current_gbe->row --;
			_current_gbe->y_off = 0.0;
			_current_gbe->y_move_timer = 0.0;
		}
		
	}

	void GameBoardSystem::handle_state_moving_left ()
	{
		_current_gbe->x_move_timer += _delta;
		
		_current_gbe->x_off -= _delta* (32.0/0.05);
		
		if (_current_gbe->x_move_timer >= 0.05)
		{
			_current_gbe->state &= (~GBE_STATE_MOVING_LEFT);
			_current_gbe->col --;
			_current_gbe->x_off = 0.0;
			return;
		}
		
	}
	
	
	void GameBoardSystem::handle_state_moving_right ()
	{
		_current_gbe->x_move_timer += _delta;
		_current_gbe->x_off += _delta* (32.0/0.05);

		if (_current_gbe->x_move_timer >= 0.05)
		{
			_current_gbe->state &= (~GBE_STATE_MOVING_RIGHT);
			_current_gbe->col ++;
			_current_gbe->x_off = 0.0;
			return;
		}
	}
	
	void GameBoardSystem::update (float delta)
	{
		_delta = delta;
		/* create collision map */	
		_entities.clear();
		_entityManager->getEntitiesPossessingComponents(_entities,  GameBoardElement::COMPONENT_ID, ARGLIST_END );

		
		std::vector<Entity*>::const_iterator it = _entities.begin();
		
		_current_entity = NULL;
		_current_gbe = NULL;
		while (it != _entities.end())
		{
			_current_entity = *it;
			++it;
			_current_gbe = _entityManager->getComponent<GameBoardElement>(_current_entity);
			_current_position = _entityManager->getComponent<Position>(_current_entity);

			if ((_current_gbe->state & GBE_STATE_READY_TO_FALL))
			{
				handle_state_ready_to_fall();
			}
			
			if ((_current_gbe->state & GBE_STATE_READY_TO_MOVE_LEFT))
			{	
				handle_state_ready_to_move_left();
			}
			
			if ((_current_gbe->state & GBE_STATE_READY_TO_MOVE_RIGHT))
			{	
				handle_state_ready_to_move_right();
			}
			
		
			if (_current_gbe->state & GBE_STATE_MOVING_FALL)
				handle_state_falling ();
			if (_current_gbe->state & GBE_STATE_MOVING_LEFT)
				handle_state_moving_left();
			if (_current_gbe->state & GBE_STATE_MOVING_RIGHT)
				handle_state_moving_right();

			

			
			_current_position->x = _current_gbe->col * 32.0 + BOARD_X_OFFSET + _current_gbe->x_off;
			_current_position->y = _current_gbe->row * 32.0 + BOARD_Y_OFFSET + _current_gbe->y_off;
			//update_map();
		}

		update_map();
		

	}
	
}
