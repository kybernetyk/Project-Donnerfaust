/*
 *  BlobConnectionSystem.mm
 *  Donnerfaust
 *
 *  Created by jrk on 29/11/10.
 *  Copyright 2010 flux forge. All rights reserved.
 *
 */

#include "BlobConnectionSystem.h"

#include "Texture2D.h"
#include "SoundSystem.h"
#include "globals.h"
#include "ActionSystem.h"
#include "InputDevice.h"
#include "Component.h"
#include "GameComponents.h"

namespace game 
{
	
	
	BlobConnectionSystem::BlobConnectionSystem (EntityManager *entityManager)
	{
		_entityManager = entityManager;
		memset(_map,0x00,BOARD_NUM_COLS*BOARD_NUM_ROWS*sizeof(Entity*));
	}
	
	void BlobConnectionSystem::update_map ()
	{
		memset(_map,0x00,BOARD_NUM_COLS*BOARD_NUM_ROWS*sizeof(Entity*));
		
		std::vector<Entity*>::const_iterator it = _entities.begin();
		_current_entity = NULL;
		GameBoardElement *_current_gbe = NULL;
		while (it != _entities.end())
		{
			_current_entity = *it;
			++it;
			_current_gbe = _entityManager->getComponent<GameBoardElement>(_current_entity);
			
			if ((_current_gbe->landed))
			{
				
				_map[_current_gbe->col][_current_gbe->row] = _current_entity;
			}
		}
		
		
	}
	
	
	void BlobConnectionSystem::update (float delta)
	{
		_delta = delta;

		_entities.clear();
		_entityManager->getEntitiesPossessingComponents(_entities, GameBoardElement::COMPONENT_ID, Position::COMPONENT_ID, ARGLIST_END );

		update_map();
		
		std::vector<Entity*>::const_iterator it = _entities.begin();

		
		GameBoardElement *current_gbe = NULL;
		GameBoardElement *compare_gbe = NULL;

		
		_current_entity = NULL;
		while (it != _entities.end())
		{
			_current_entity = *it;
			++it;
			current_gbe = _entityManager->getComponent <GameBoardElement> (_current_entity);
			current_gbe->connection_state = GBE_CONNECTED_NONE;

		}
		
		
		Entity *compare_entity = NULL;
		for (int y = 0; y < BOARD_NUM_ROWS; y++)
		{
			for (int x = 0; x < BOARD_NUM_COLS; x++)
			{
				if (_map[x][y])
				{
					_current_entity = _map[x][y];
					bool handled = false;
					
					current_gbe = _entityManager->getComponent <GameBoardElement> (_current_entity);
					//unsigned int temp = current_gbe->prev_connection_state;
					current_gbe->connection_state = 0;
					
					
					//check left
					if (x > 0)
					{
						compare_entity = _map[x-1][y];
						if (compare_entity)
						{
							compare_gbe = _entityManager->getComponent <GameBoardElement> (compare_entity);
							if (current_gbe->type == compare_gbe->type)
							{
								current_gbe->connection_state |= GBE_CONNECTED_TO_LEFT;
								compare_gbe->connection_state |= GBE_CONNECTED_TO_RIGHT;
							}
//							else
//							{
//								current_gbe->connection_state &= (~GBE_CONNECTED_TO_LEFT);
//								compare_gbe->connection_state &= (~GBE_CONNECTED_TO_RIGHT);
//							}
						}
//						else
//						{
//							current_gbe->connection_state &= (~GBE_CONNECTED_TO_LEFT);
//						}
//						handled = true;
			
					}
					//end check left
					
					//check right
					if (x < BOARD_NUM_COLS - 1)
					{
						compare_entity = _map[x+1][y];
						if (compare_entity)
						{
							compare_gbe = _entityManager->getComponent <GameBoardElement> (compare_entity);
					
							if (current_gbe->type == compare_gbe->type)
							{
								current_gbe->connection_state |= GBE_CONNECTED_TO_RIGHT;
								compare_gbe->connection_state |= GBE_CONNECTED_TO_LEFT;
							}
//							else
//							{
//								current_gbe->connection_state &= (~GBE_CONNECTED_TO_RIGHT);
//								compare_gbe->connection_state &= (~GBE_CONNECTED_TO_LEFT);
//							}
						}
//						else
//						{
//							current_gbe->connection_state &= (~GBE_CONNECTED_TO_RIGHT);
//						}
//						handled = true;
				
					}
					//end check left
					
					
					//check down
					if (y > 0)
					{
						compare_entity = _map[x][y-1];
						if (compare_entity)
						{
							compare_gbe = _entityManager->getComponent <GameBoardElement> (compare_entity);

							if (current_gbe->type == compare_gbe->type)
							{
								current_gbe->connection_state |= GBE_CONNECTED_TO_DOWN;
								compare_gbe->connection_state |= GBE_CONNECTED_TO_UP;
							}
//							else
//							{
//								current_gbe->connection_state &= (~GBE_CONNECTED_TO_DOWN);
//								compare_gbe->connection_state &= (~GBE_CONNECTED_TO_UP);
//							}
						}
//						else
//						{
//							current_gbe->connection_state &= (~GBE_CONNECTED_TO_DOWN);
//						}
//						handled = true;
					
					}
					//end check down

					//check up
					if (y < BOARD_NUM_ROWS - 1)
					{
						compare_entity = _map[x][y+1];
						if (compare_entity)
						{
							compare_gbe = _entityManager->getComponent <GameBoardElement> (compare_entity);
							if (current_gbe->type == compare_gbe->type)
							{
								current_gbe->connection_state |= GBE_CONNECTED_TO_UP;
								compare_gbe->connection_state |= GBE_CONNECTED_TO_DOWN;
							}
//							else
//							{
//								current_gbe->connection_state &= (~GBE_CONNECTED_TO_UP);
//								compare_gbe->connection_state &= (~GBE_CONNECTED_TO_DOWN);
//
//							}
						}
//						else
//						{
//							current_gbe->connection_state &= (~GBE_CONNECTED_TO_UP);
//						}
						
						handled = true;
						if (current_gbe->connection_state == 0)
						{	
							current_gbe->connection_state = GBE_CONNECTED_NONE;
//							current_gbe->prev_connection_state = 0xff;
						}
						
						if (current_gbe->connection_state != current_gbe->prev_connection_state)
						{
							
							//current_gbe->prev_connection_state = temp;
							
							_entityManager->addComponent <NeedsAnimation> (_current_entity);
						}

					}
				}
			}
		}
		
		

	}
}