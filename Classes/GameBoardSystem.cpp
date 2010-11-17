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

namespace game 
{
	Action *fall_one_row_action ()
	{
		Action *idle = new Action();
		idle->duration = 0.3;
	//	mba->next_action = idle;
		
		MoveByAction *mba = new MoveByAction();
		mba->y = -32.0;
		mba->x = 0.0;
		mba->duration = 0.6;
	
		idle->on_complete_action = mba;
		
		return (Action*)idle;
	}
	
	GameBoardSystem::GameBoardSystem (EntityManager *entityManager)
	{
		_entityManager = entityManager;
	}
	
	bool GameBoardSystem::can_fall (Entity *e)
	{
		//GameBoardElement *gbo = e->get<GameBoardElement>();
		GameBoardElement *gbo = _entityManager->getComponent <GameBoardElement> (e);
		
		if ( (gbo->row - 1) < 0)
			return false;
		
		if (_map[gbo->col][gbo->row-1])
			return false;
		
		return true;
	}
	
	void GameBoardSystem::dump_map ()
	{
		printf("****************************\n");
		for (int r = 0; r < BOARD_NUM_ROWS; r++)
		{	
			for (int c = 0; c < BOARD_NUM_COLS; c++)
			{
				if (_map[c][r])
					printf("\t%i",_entityManager->getComponent <GameBoardElement>(_map[c][r])->type);
				else
					printf("\tx");
			}
			printf("\n");
		}
		printf("****************************\n");		
	}
	
	
	void GameBoardSystem::refresh_map ()
	{
		for (int r = 0; r < BOARD_NUM_ROWS; r++)
			for (int c = 0; c < BOARD_NUM_COLS; c++)
				_map[c][r] = false;
		
		std::vector<Entity*>::const_iterator it = _entities.begin();

		Entity *current_entity = NULL;
		GameBoardElement *current_gbo = NULL;
		while (it != _entities.end())
		{
			current_entity = *it;
			current_gbo = _entityManager->getComponent <GameBoardElement> (current_entity);
			_map[current_gbo->col][current_gbo->row] = current_entity;
			++it;
		}
		
		
	}
	
	void GameBoardSystem::move_elements ()
	{
		std::vector<Entity*>::const_iterator it = _entities.begin();
		
		Entity *current_entity = NULL;
		GameBoardElement *current_gbo = NULL;
		Action *current_action = NULL;
		Position *current_position = NULL;
		while (it != _entities.end())
		{
			current_entity = *it;
			current_gbo = _entityManager->getComponent <GameBoardElement> (current_entity);
			
			current_action = _entityManager->getComponent <Action> (current_entity);
			if (!current_action)
			{
				if (can_fall(current_entity))
				{
					current_gbo->row --;
					_entityManager->addComponent(current_entity, fall_one_row_action());
				}
				else
				{
					//current_gbo->state = COLLIDING;
					_entityManager->removeComponent <FallingState> (current_entity);
					_entityManager->addComponent <LandingState> (current_entity);
					_entityManager->addComponent <Collidable> (current_entity);
				}
			}
			++it;
		}
		
	}
	
	void GameBoardSystem::mark_connections ()
	{
		Entity *current_entity = NULL;
		
		GameBoardElement *current_element;

		GameBoardElement *neighbor_up;
		GameBoardElement *neighbor_right;
		GameBoardElement *neighbor_bottom;
		GameBoardElement *neighbor_left;
		
		//r = y
		//c = x
		for (int r = 0; r < BOARD_NUM_ROWS; r++)
		{	
			for (int c = 0; c < BOARD_NUM_COLS; c++)
			{
				if (!_map[c][r])
					continue;
				
				current_element = neighbor_up = neighbor_right = neighbor_bottom = neighbor_left = NULL;
				
				current_element =  _map[c][r]->get<GameBoardElement>();
				current_element->_prev_connection_state = current_element->connection_state;
				
				if ( (c-1) >= 0)
					if (_map[c-1][r])
						neighbor_left = _map[c-1][r]->get<GameBoardElement>();

				if ( (c+1) < BOARD_NUM_COLS)
					if (_map[c+1][r])
						neighbor_right = _map[c+1][r]->get<GameBoardElement>();

				if ( (r-1) >= 0)
					if (_map[c][r-1])
						neighbor_bottom = _map[c][r-1]->get<GameBoardElement> ();

				if ( (r+1) < BOARD_NUM_ROWS)
					if (_map[c][r+1])
						neighbor_up = _map[c][r+1]->get<GameBoardElement> ();
				
				if (neighbor_bottom)
					if (current_element->type == neighbor_bottom->type )
						current_element->connection_state = CONNECTION_DOWN;
				
				if (neighbor_up)		
					if (current_element->type == neighbor_up->type )
						current_element->connection_state = CONNECTION_UP;
				
				if (neighbor_left)
					if (current_element->type == neighbor_left->type )
						current_element->connection_state = CONNECTION_LEFT;
				
				if (neighbor_right)
					if (current_element->type == neighbor_right->type )
						current_element->connection_state = CONNECTION_RIGHT;
				
				
			}
		}
		
	}
	
	void GameBoardSystem::update (float delta)
	{
		/* create collision map */	
		_entities.clear();
		_entityManager->getEntitiesPossessingComponents(_entities,  GameBoardElement::COMPONENT_ID, Collidable::COMPONENT_ID, Position::COMPONENT_ID, ARGLIST_END );
		refresh_map();

		/* move falling blobs */
		_entities.clear();
		_entityManager->getEntitiesPossessingComponents(_entities,  GameBoardElement::COMPONENT_ID, FallingState::COMPONENT_ID,Position::COMPONENT_ID, ARGLIST_END );
		move_elements();

		/* create map of resting blobs and connect them */
		_entities.clear();
		_entityManager->getEntitiesPossessingComponents(_entities,  GameBoardElement::COMPONENT_ID, RestingState::COMPONENT_ID,Position::COMPONENT_ID, ARGLIST_END );
		refresh_map();

		mark_connections();
		

	}
	
}