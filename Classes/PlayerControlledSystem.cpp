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

	//create collision map
	void PlayerControlledSystem::update_map ()
	{
		memset(_map,0x00,BOARD_NUM_COLS*BOARD_NUM_ROWS*sizeof(Entity*));
		
		std::vector<Entity*>::const_iterator it = _entities.begin();
		Entity *_current_entity = NULL;
		GameBoardElement *_current_gbe = NULL;
		while (it != _entities.end())
		{
			_current_entity = *it;
			++it;
			_current_gbe = _entityManager->getComponent<GameBoardElement>(_current_entity);

			if ((_current_gbe->state & GBE_STATE_IDLE))
				_map[_current_gbe->col][_current_gbe->row] = _current_entity;
		}
	}
	
	bool PlayerControlledSystem::can_move_down (PlayerController *pc)
	{
		int advnum = 1;
		if (pc->top_or_bottom == TOP)
			advnum = 2;
		
		if (pc->config == HORIZONTAL)
			advnum = 1;
		
		if (pc->row - advnum < 0)
			return false;
		
		int row = pc->row - advnum;
		int col = pc->col;
		
		if (_map[col][row])
			return false;
		
		return true;
	}
	
	bool PlayerControlledSystem::can_move_left (PlayerController *pc)
	{
		
		int advnum = 1;
	
		if (pc->config == HORIZONTAL)
			if (pc->is_aux_right)
				advnum = 2;

		if (pc->config == VERTICAL)
			advnum = 1;
		
		
		if (pc->col - advnum < 0)
			return false;
		
		int row = pc->row;
		int col = pc->col - advnum;
		if (_map[col][row])
			return false;

		//if we are over our fall idle time the palyer may not move left if the row-1 is blocked!
		if (pc->_y_timer >= pc->fall_idle_time)
		{
			advnum = 1;
			
			if (pc->config == VERTICAL)
				if (pc->top_or_bottom == TOP)
					advnum = 2;
			
			row -= advnum;
			if (row >= 0)
			{
				if (_map[col][row])
					return false;
			}
		}
		
		return true;
	}
	
	bool PlayerControlledSystem::can_move_right (PlayerController *pc)
	{
		int advnum = 1;
		
		if (pc->config == HORIZONTAL)
			if (pc->is_aux_left)
				advnum = 2;
		
		if (pc->config == VERTICAL)
			advnum = 1;

		
		if (pc->col + advnum >= BOARD_NUM_COLS)
			return false;
		
		int row = pc->row;
		int col = pc->col + advnum;
		if (_map[col][row])
			return false;

		
		//if we are over our fall idle time the palyer may not move right if the row-1 is blocked!
		if (pc->_y_timer >= pc->fall_idle_time)
		{
			advnum = 1;
			
			if (pc->config == VERTICAL)
				if (pc->top_or_bottom == TOP)
					advnum = 2;
			
			row -= advnum;
			if (row >= 0)
			{
				if (_map[col][row])
					return false;
			}
		}
		
		
		return true;
	}
	
		//TODO: rename right blob and left blob to: left blob -> center blob, right blob -> rotating blob
	void PlayerControlledSystem::update (float delta)
	{
		bool move_left = false;
		bool move_right = false;
		bool rotate = false;
		
		
		move_left = InputDevice::sharedInstance()->getLeftActive();
		move_right = InputDevice::sharedInstance()->getRightActive();
		rotate = InputDevice::sharedInstance()->getUpActive();
		
		
		
		_entities.clear();
		_entityManager->getEntitiesPossessingComponents (_entities, GameBoardElement::COMPONENT_ID, ARGLIST_END);
		update_map();
	
		
		_entities.clear();
		_entityManager->getEntitiesPossessingComponents(_entities,  PlayerController::COMPONENT_ID,Position::COMPONENT_ID, ARGLIST_END );
		std::vector<Entity*>::const_iterator it = _entities.begin();

		Entity *left_blob = NULL;
		Entity *right_blob = NULL;
		
		Entity *current_entity = NULL;
		PlayerController *current_pc = NULL;
		while (it != _entities.end())
		{
			current_entity = *it;
			++it;

			current_pc = _entityManager->getComponent <PlayerController>(current_entity);
			if (current_pc->left_or_right == LEFT)
			{	
				left_blob = current_entity;
			}
			
			if (current_pc->left_or_right == RIGHT)
			{	
				right_blob = current_entity;
			}
		}
		
		/* fall move collision handling */
		if (left_blob && right_blob)
		{
			PlayerController *left_pc = _entityManager->getComponent <PlayerController> (left_blob);
			PlayerController *right_pc = _entityManager->getComponent <PlayerController> (right_blob);
			
			Position *left_position = _entityManager->getComponent <Position> (left_blob);
			Position *right_position = _entityManager->getComponent <Position> (right_blob);
			
			bool left_can_fall = can_move_down(left_pc);
			bool left_can_move_left = can_move_left(left_pc);
			bool left_can_move_right = can_move_right(left_pc);
			

			bool right_can_fall = can_move_down(right_pc);
			bool right_can_move_left = can_move_left(right_pc);
			bool right_can_move_right = can_move_right(right_pc);
			
			/* begin rortation code */
			if (rotate)
			{
				//right one rotates around left one

				if (right_pc->config == HORIZONTAL &&
					left_pc->config == HORIZONTAL)
				{
					//put right blob to bottom: - > | angle = 180
					if (right_position->x > left_position->x)
					{
						if (!can_move_down(left_pc))
							return;
						if (!can_move_down(right_pc))
							return;
						left_pc->rotation_angle = right_pc->rotation_angle = 180;
						
						right_position->x = left_position->x;
						
						float a = cos(DEG2RAD(right_pc->rotation_angle));
						right_position->y = left_position->y + (32.0 * a);
						
					//	right_position->x = left_position->x;
					//	right_position->y = left_position->y - 32.0;
						right_pc->col = left_pc->col;
						right_pc->row = left_pc->row - 1;
						
						right_pc->top_or_bottom = BOTTOM;
						left_pc->top_or_bottom = TOP;
						right_pc->config = left_pc->config = VERTICAL;
						left_pc->is_aux_left = false;
						left_pc->is_aux_right = false;
						right_pc->is_aux_left = false;
						right_pc->is_aux_right = false;
						

					}
					else	//angle = 0
					{
					
						left_pc->rotation_angle = right_pc->rotation_angle = 0;
						right_position->x = left_position->x;
						float a = cos(DEG2RAD(right_pc->rotation_angle));
						right_position->y = left_position->y + (32.0 * a);
						
						
					//	right_position->x = left_position->x;
					//	right_position->y = left_position->y + 32.0;
						right_pc->col = left_pc->col;
						right_pc->row = left_pc->row + 1;
						
						right_pc->top_or_bottom = TOP;
						left_pc->top_or_bottom = BOTTOM;
						right_pc->config = left_pc->config = VERTICAL;
						left_pc->is_aux_left = false;
						left_pc->is_aux_right = false;
						right_pc->is_aux_left = false;
						right_pc->is_aux_right = false;
						
					}
					
				}
				else if (right_pc->config == VERTICAL &&
						 left_pc->config == VERTICAL)
				{
					//lower to left: | > - angle = 90
					if (right_position->y < left_position->y)
					{
						if (!can_move_left(right_pc))
							return;
						if (!can_move_left(left_pc))
							return;
						
						left_pc->rotation_angle = right_pc->rotation_angle = 90;
						float a = sin(DEG2RAD(right_pc->rotation_angle));
						right_position->x = left_position->x - (32.0 * a);
						right_position->y = left_position->y;

						right_pc->col = left_pc->col-1;
						right_pc->row = left_pc->row;
						right_pc->config = left_pc->config = HORIZONTAL;
						
						right_pc->is_aux_left = true;
						right_pc->is_aux_right = false;
						
						left_pc->is_aux_left = false;
						left_pc->is_aux_right = true;
					}
					else	//angle = 270
					{
						if (!can_move_right(right_pc))
							return;
						if (!can_move_right(left_pc))
							return;
						
//						right_position->x = left_position->x + 32;
//						right_position->y = left_position->y;
						
						left_pc->rotation_angle = right_pc->rotation_angle = 270;
						float a = sin(DEG2RAD(right_pc->rotation_angle));
						right_position->x = left_position->x - (32.0 * a);
						right_position->y = left_position->y;
						
						
						right_pc->col = left_pc->col+1;
						right_pc->row = left_pc->row;
						right_pc->config = left_pc->config = HORIZONTAL;
						
						
						right_pc->is_aux_left = false;
						right_pc->is_aux_right = true;
						
						left_pc->is_aux_left = true;
						left_pc->is_aux_right = false;
						
					}
				}
				
				

				
				return;
			}
			/* end rotation code */ 
			
			/* begin left & right can fall */
			if (left_can_fall && right_can_fall)
			{
				//idle state
				if ( (left_pc->state & PC_STATE_IDLE ))
				{
					left_pc->state &= (~PC_STATE_IDLE);
					left_pc->state |= PC_STATE_MOVING_FALL;
					left_pc->_y_timer = 0.0;
					left_pc->_collision_grace_timer = 0.0;
				}
				
				if ( (right_pc->state & PC_STATE_IDLE ))
				{
					right_pc->state &= (~PC_STATE_IDLE);
					right_pc->state |= PC_STATE_MOVING_FALL;
					right_pc->_y_timer = 0.0;
					right_pc->_collision_grace_timer = 0.0;
				}
				//idle state end
				
				//falling state
				if ( (left_pc->state & PC_STATE_MOVING_FALL) )
				{
					if (left_pc->_y_timer >= left_pc->fall_idle_time)
					{
						left_position->y -= (delta * 32.0 / left_pc->fall_active_time);
					}
					
					if (left_pc->_y_timer >= (left_pc->fall_idle_time + left_pc->fall_active_time))
					{
						left_pc->row --;
						left_position->y = left_pc->row * 32.0 + BOARD_Y_OFFSET;
						left_pc->state &= (~PC_STATE_MOVING_FALL);
						left_pc->state |= PC_STATE_IDLE;
						left_pc->_y_timer = 0.0;
					}
					
					left_pc->_y_timer += delta;
				}
				
				if ( (right_pc->state & PC_STATE_MOVING_FALL) )
				{
					if (right_pc->_y_timer >= right_pc->fall_idle_time)
					{
						right_position->y -= (delta * 32.0 / right_pc->fall_active_time);
					}
					
					if (right_pc->_y_timer >= (right_pc->fall_idle_time + right_pc->fall_active_time))
					{
						right_pc->row --;
						right_position->y = right_pc->row * 32.0 + BOARD_Y_OFFSET;
						right_pc->state &= (~PC_STATE_MOVING_FALL);
						right_pc->state |= PC_STATE_IDLE;
						right_pc->_y_timer = 0.0;
					}
					
					right_pc->_y_timer += delta;
				}
				//falling state end
	
				//left/right movement
				if (move_left)
				{	
					if (left_can_move_left && right_can_move_left)
					{
						left_position->x -= 32.0;
						left_pc->col --;
						right_position->x -= 32.0;
						right_pc->col --;
					}
					
				}
				
				if (move_right)
				{	
					if (left_can_move_right && right_can_move_right)
					{
						left_position->x += 32.0;
						left_pc->col ++;
						right_position->x += 32.0;
						right_pc->col ++;
					}
				}
				//left/right movement end
			}
			/* end left & right can fall */
			
			/* start non fall code */
			if (!left_can_fall || !right_can_fall)
			{
				float *grace_timer = NULL;
				float *grace_time = NULL;
				
				if (!left_can_fall)
				{	
					grace_timer = &left_pc->_collision_grace_timer;
					grace_time = &left_pc->collision_grace_time;
				}
				if (!right_can_fall)
				{	
					grace_timer = &right_pc->_collision_grace_timer;
					grace_time = &right_pc->collision_grace_time;
				}
				
				
				*grace_timer += delta;
				
				if (*grace_timer >= *grace_time)
				{
					_entityManager->addComponent <MarkOfDeath> (left_blob);
					_entityManager->addComponent <MarkOfDeath> (right_blob);
					
					//PlayerController *pc = _entityManager->getComponent <PlayerController>(left_blob);
					
					make_blob(left_pc->type, left_pc->col, left_pc->row);
					make_blob(right_pc->type, right_pc->col, right_pc->row);
					
				}
				else //allow movement during grace period
				{
					if (move_left)
					{	
						if (left_can_move_left && right_can_move_left)
						{
							left_position->x -= 32.0;
							left_pc->col --;
							right_position->x -= 32.0;
							right_pc->col --;
						}
						
					}
					
					if (move_right)
					{	
						if (left_can_move_right && right_can_move_right)
						{
							left_position->x += 32.0;
							left_pc->col ++;
							right_position->x += 32.0;
							right_pc->col ++;
						}
					}
				}
				
			}
			/* end non fall code */
		}
		/* end fall move collision handling */
		
	}

}