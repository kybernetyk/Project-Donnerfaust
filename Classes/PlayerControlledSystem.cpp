/*
 *  PlayerControlledSystem.cpp
 *  ComponentV3
 *
 *  Created by jrk on 8/11/10.
 *  Copyright 2010 flux forge. All rights reserved.
 *
 */

#include "Util.h"
#include "PlayerControlledSystem.h"
#include "InputDevice.h"
#include "blob_factory.h"

namespace game 
{
	PlayerControlledSystem::PlayerControlledSystem (EntityManager *entityManager)
	{
		_entityManager = entityManager;
		memset(_map,0x00,BOARD_NUM_COLS*BOARD_NUM_ROWS*sizeof(Entity*));

	}

	void PlayerControlledSystem::update_map ()
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
			
			if ((_current_gbe->state & GBE_STATE_IDLE))
				_map[_current_gbe->col][_current_gbe->row] = _current_entity;
		}
	}
	
	bool PlayerControlledSystem::can_move_down ()
	{
		if (_current_pc->row - 1 < 0)
			return false;
		
		int row = _current_pc->row -1;
		int col = _current_pc->col;
		
		if (_map[col][row])
			return false;
		
		return true;
	}
	
	bool PlayerControlledSystem::can_move_left ()
	{
		int advnum = 1;
		if (_current_pc->left_or_right == RIGHT)
			advnum = 2;
		
		if (_current_pc->col - advnum < 0)
			return false;
		
		int row = _current_pc->row;
		int col = _current_pc->col - advnum;
		if (_map[col][row])
			return false;
		
		return true;
	}
	
	bool PlayerControlledSystem::can_move_right ()
	{
		int advnum = 1;
		
		if (_current_pc->left_or_right == LEFT)
			advnum = 2;
	
		printf("advnum: %i\n", advnum);
		
		if (_current_pc->col + advnum >= BOARD_NUM_COLS)
			return false;
		
		int row = _current_pc->row;
		int col = _current_pc->col + advnum;
		if (_map[col][row])
			return false;
		
		return true;
	}
	
	
	void PlayerControlledSystem::update (float delta)
	{
		bool move_left = false;
		bool move_right = false;
		
		move_left = InputDevice::sharedInstance()->getLeftActive();
		move_right = InputDevice::sharedInstance()->getRightActive();
		
		
		_entities.clear();
		_entityManager->getEntitiesPossessingComponents (_entities, GameBoardElement::COMPONENT_ID, ARGLIST_END);
		update_map();
	
		
		_entities.clear();
		_entityManager->getEntitiesPossessingComponents(_entities,  PlayerController::COMPONENT_ID,Position::COMPONENT_ID, ARGLIST_END );
		std::vector<Entity*>::const_iterator it = _entities.begin();

		_current_entity = NULL;
		_current_pc = NULL;
		while (it != _entities.end())
		{
			_current_entity = *it;
			++it;
			
			_current_pc = _entityManager->getComponent <PlayerController>(_current_entity);
			_current_position = _entityManager->getComponent <Position> (_current_entity);
			
			
			if ( (_current_pc->state & PC_STATE_IDLE) )
			{
				if (can_move_down())
				{	
					_current_pc->state &= (~PC_STATE_IDLE);
					_current_pc->state |= PC_STATE_MOVING_FALL;
					_current_pc->y_timer = 0.0;
				}
				else
				{
					_entityManager->addComponent <MarkOfDeath> (_current_entity); 
					
					
					make_blob(_current_pc->type, _current_pc->col, _current_pc->row);
					
				}
			}
			
			if ( (_current_pc->state & PC_STATE_MOVING_FALL) )
			{
				if (_current_pc->y_timer >= _current_pc->fall_idle_time)
				{
					//_current_position->y -= delta * (32.0 / _current_pc->fall_active_time);
				}
				
				if (_current_pc->y_timer >= (_current_pc->fall_idle_time + _current_pc->fall_active_time))
				{
					_current_position->y -= 32.0;
					_current_pc->row --;
					_current_pc->state &= (~PC_STATE_MOVING_FALL);
					_current_pc->state |= PC_STATE_IDLE;

				}
				
				_current_pc->y_timer += delta;
			}
			
			if (move_left)
			{	
				if (can_move_left())
				{
					_current_position->x -= 32.0;
					_current_pc->col --;
				}
			}
			
			if (move_right)
			{	
				if (can_move_right())
				{
					_current_position->x += 32.0;
					_current_pc->col ++;
				}
			}
			
		}
	}

}