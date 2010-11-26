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
#include "ParticleSystem.h"

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
			if (pc->left_or_right == RIGHT)
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
			if (pc->left_or_right == LEFT)
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

		Entity *center_blob = NULL;
		Entity *aux_blob = NULL;
		
		Entity *current_entity = NULL;
		PlayerController *current_pc = NULL;
		while (it != _entities.end())
		{
			current_entity = *it;
			++it;

			current_pc = _entityManager->getComponent <PlayerController>(current_entity);
			if (current_pc->center_or_aux == CENTER)
			{	
				center_blob = current_entity;
			}
			
			if (current_pc->center_or_aux == AUX)
			{	
				aux_blob = current_entity;
			}
		}
		
		/* fall move collision handling */
		if (center_blob && aux_blob)
		{
			PlayerController *center_pc = _entityManager->getComponent <PlayerController> (center_blob);
			PlayerController *aux_pc = _entityManager->getComponent <PlayerController> (aux_blob);
			
			Position *center_position = _entityManager->getComponent <Position> (center_blob);
			Position *aux_position = _entityManager->getComponent <Position> (aux_blob);
			
			bool left_can_fall = can_move_down(center_pc);
			bool left_can_move_left = can_move_left(center_pc);
			bool left_can_move_right = can_move_right(center_pc);
			

			bool right_can_fall = can_move_down(aux_pc);
			bool right_can_move_left = can_move_left(aux_pc);
			bool right_can_move_right = can_move_right(aux_pc);
			
			
			/*rotate state*/
			if ((aux_pc->state & PC_STATE_ROTATING))
			{
				aux_pc->_rotation_timer -= (delta*900.0);
				aux_pc->rotation_angle += (delta*900.0);
				
//				if (aux_pc->rotation_angle >= 360)
//					aux_pc->rotation_angle = 0;
				
				printf("angle: %f\n", aux_pc->rotation_angle);
				
				float a = cos(DEG2RAD(aux_pc->rotation_angle));
				aux_position->y = center_position->y - (32.0 * a);
				
				a = sin(DEG2RAD(aux_pc->rotation_angle));
				aux_position->x = center_position->x + (32.0 * a);
				
				if (current_pc->_rotation_timer <= 0)
				{
					aux_pc->_rotation_timer = 90.0;
					aux_pc->state &= (~PC_STATE_ROTATING);
				}
			}
			
			
			/* begin rortation code */
			if (rotate)
			{
				//right one rotates around left one

				if (aux_pc->config == HORIZONTAL &&
					center_pc->config == HORIZONTAL)
				{
					//put right blob to bottom: - > | angle = 180
					if (aux_position->x > center_position->x)
					{
/*						if (!can_move_down(center_pc))
							return;
						if (!can_move_down(aux_pc))
							return;*/
						if ((aux_pc->state & PC_STATE_ROTATING))
							return;

						
						center_pc->rotation_angle = aux_pc->rotation_angle = 180-90;
						
						printf("90->180\n");
						//aux_position->x = center_position->x;
						
					//	float a = cos(DEG2RAD(aux_pc->rotation_angle));
						//aux_position->y = center_position->y + (32.0 * a);

						aux_pc->_rotation_timer = 90.0;
						aux_pc->state |= PC_STATE_ROTATING;

					//	aux_position->x = center_position->x;
					//	aux_position->y = center_position->y - 32.0;
						aux_pc->col = center_pc->col;
						aux_pc->row = center_pc->row + 1;
						
						aux_pc->top_or_bottom = TOP;
						center_pc->top_or_bottom = BOTTOM;
						aux_pc->config = center_pc->config = VERTICAL;
						

					}
					else	//angle = 0
					{
						if (!can_move_down(center_pc))
							return;
						if (!can_move_down(aux_pc))
							return;
						
						if ((aux_pc->state & PC_STATE_ROTATING))
							return;

						printf("270->360\n");

						center_pc->rotation_angle = aux_pc->rotation_angle = 270;
					//	aux_position->x = center_position->x;
					//	float a = cos(DEG2RAD(aux_pc->rotation_angle));
					//	aux_position->y = center_position->y + (32.0 * a);
						
						aux_pc->_rotation_timer = 90.0;
						aux_pc->state |= PC_STATE_ROTATING;
						
					//	aux_position->x = center_position->x;
					//	aux_position->y = center_position->y + 32.0;
						aux_pc->col = center_pc->col;
						aux_pc->row = center_pc->row - 1;
						
						aux_pc->top_or_bottom = BOTTOM;
						center_pc->top_or_bottom = TOP;
						aux_pc->config = center_pc->config = VERTICAL;
						
					}
					
				}
				else if (aux_pc->config == VERTICAL &&
						 center_pc->config == VERTICAL)
				{
					//lower to left: | > - angle = 90
					if (aux_position->y < center_position->y)
					{
						if (!can_move_right(aux_pc))
							return;
						if (!can_move_right(center_pc))
							return;
						
						
						if ((aux_pc->state & PC_STATE_ROTATING))
							return;
	
						printf("0->90\n");

						
						center_pc->rotation_angle = aux_pc->rotation_angle = 0;
				//		float a = sin(DEG2RAD(aux_pc->rotation_angle));
				//		aux_position->x = center_position->x - (32.0 * a);
				//		aux_position->y = center_position->y;

						aux_pc->_rotation_timer = 90.0;
						aux_pc->state |= PC_STATE_ROTATING;

						aux_pc->col = center_pc->col+1;
						aux_pc->row = center_pc->row;
						aux_pc->config = center_pc->config = HORIZONTAL;
						
						aux_pc->left_or_right = RIGHT;
						center_pc->left_or_right = LEFT;
					}
					else	//angle = 270
					{
						if (!can_move_left(aux_pc))
							return;
						if (!can_move_left(center_pc))
							return;
						
						if ((aux_pc->state & PC_STATE_ROTATING))
							return;
						
//						aux_position->x = center_position->x + 32;
//						aux_position->y = center_position->y;
						printf("180->270\n");

						center_pc->rotation_angle = aux_pc->rotation_angle = 180;
					//	float a = sin(DEG2RAD(aux_pc->rotation_angle));
					//	aux_position->x = center_position->x - (32.0 * a);
					//	aux_position->y = center_position->y;
						
						aux_pc->_rotation_timer = 90.0;
						aux_pc->state |= PC_STATE_ROTATING;
	
						aux_pc->col = center_pc->col-1;
						aux_pc->row = center_pc->row;
						aux_pc->config = center_pc->config = HORIZONTAL;
						
						aux_pc->left_or_right = LEFT;
						center_pc->left_or_right = RIGHT;

						
					}
				}
				
				

				
				return;
			}
			/* end rotation code */ 
			
			/* begin left & right can fall */
			if (left_can_fall && right_can_fall)
			{
				//idle state
				if ( (center_pc->state & PC_STATE_IDLE ))
				{
					center_pc->state &= (~PC_STATE_IDLE);
					center_pc->state |= PC_STATE_MOVING_FALL;
					center_pc->_y_timer = 0.0;
					center_pc->_collision_grace_timer = 0.0;
				}
				
				if ( (aux_pc->state & PC_STATE_IDLE ))
				{
					aux_pc->state &= (~PC_STATE_IDLE);
					aux_pc->state |= PC_STATE_MOVING_FALL;
					aux_pc->_y_timer = 0.0;
					aux_pc->_collision_grace_timer = 0.0;
				}
				//idle state end
				
				//falling state
				if ( (center_pc->state & PC_STATE_MOVING_FALL) )
				{
//					return;
					
					if (center_pc->_y_timer >= center_pc->fall_idle_time)
					{
						center_position->y -= (delta * 32.0 / center_pc->fall_active_time);
					}
					
					if (center_pc->_y_timer >= (center_pc->fall_idle_time + center_pc->fall_active_time))
					{
						center_pc->row --;
						center_position->y = center_pc->row * 32.0 + BOARD_Y_OFFSET;
						center_pc->state &= (~PC_STATE_MOVING_FALL);
						center_pc->state |= PC_STATE_IDLE;
						center_pc->_y_timer = 0.0;
					}
					
					center_pc->_y_timer += delta;
				}
				
				if ( (aux_pc->state & PC_STATE_MOVING_FALL) )
				{
				//	return;
					
					if (aux_pc->_y_timer >= aux_pc->fall_idle_time)
					{
						aux_position->y -= (delta * 32.0 / aux_pc->fall_active_time);
					}
					
					if (aux_pc->_y_timer >= (aux_pc->fall_idle_time + aux_pc->fall_active_time))
					{
						aux_pc->row --;
						aux_position->y = aux_pc->row * 32.0 + BOARD_Y_OFFSET;
						aux_pc->state &= (~PC_STATE_MOVING_FALL);
						aux_pc->state |= PC_STATE_IDLE;
						aux_pc->_y_timer = 0.0;
					}
					
					aux_pc->_y_timer += delta;
				}
				//falling state end
	
				//left/right movement
				if (move_left)
				{	
					if (left_can_move_left && right_can_move_left)
					{
						center_position->x -= 32.0;
						center_pc->col --;
						aux_position->x -= 32.0;
						aux_pc->col --;
					}
					
				}
				
				if (move_right)
				{	
					if (left_can_move_right && right_can_move_right)
					{
						center_position->x += 32.0;
						center_pc->col ++;
						aux_position->x += 32.0;
						aux_pc->col ++;
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
					grace_timer = &center_pc->_collision_grace_timer;
					grace_time = &center_pc->collision_grace_time;
				}
				if (!right_can_fall)
				{	
					grace_timer = &aux_pc->_collision_grace_timer;
					grace_time = &aux_pc->collision_grace_time;
				}
				
				
				*grace_timer += delta;
				
				if (*grace_timer >= *grace_time)
				{
					_entityManager->addComponent <MarkOfDeath> (center_blob);
					_entityManager->addComponent <MarkOfDeath> (aux_blob);
					
					
					make_blob(center_pc->type, center_pc->col, center_pc->row);
					make_blob(aux_pc->type, aux_pc->col, aux_pc->row);
				
					int x1 = center_pc->col * 32.0 + BOARD_X_OFFSET;
					int x2 = aux_pc->col * 32.0 + BOARD_X_OFFSET;

					int y1 = center_pc->row * 32.0 + BOARD_X_OFFSET;
					int y2 = aux_pc->row * 32.0 + BOARD_X_OFFSET;

				
					int x = (x1 + x2) / 2;
					int y = (y1 + y2) / 2;
					
					ParticleSystem::createParticleEmitter ("explosion.pex", 0.0, vector2D_make(x,y));
					
				}
				else //allow movement during grace period
				{
					if (move_left)
					{	
						if (left_can_move_left && right_can_move_left)
						{
							center_position->x -= 32.0;
							center_pc->col --;
							aux_position->x -= 32.0;
							aux_pc->col --;
						}
						
					}
					
					if (move_right)
					{	
						if (left_can_move_right && right_can_move_right)
						{
							center_position->x += 32.0;
							center_pc->col ++;
							aux_position->x += 32.0;
							aux_pc->col ++;
						}
					}
				}
				
			}
			/* end non fall code */
		}
		/* end fall move collision handling */
		
	}

}