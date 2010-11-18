/*
 *  ActionSystem.cpp
 *  ComponentV3
 *
 *  Created by jrk on 8/11/10.
 *  Copyright 2010 flux forge. All rights reserved.
 *
 */

#include "ActionSystem.h"
#include <math.h>
namespace mx3 
{
	
		
	ActionSystem::ActionSystem (EntityManager *entityManager)
	{
		_entityManager = entityManager;
	}

	void ActionSystem::setupNextActionOrStop (Entity *e, Action *current_action)
	{
		Entity *current_entity = e;
	//	Action *current_action = _entityManager->getComponent<Action>(current_entity);
		
		Action *on_complete_action = current_action->on_complete_action;
		
		if (on_complete_action)
		{
		//	printf("adding next action ...");

			_entityManager->removeComponent <Action> (current_entity);
			_entityManager->addComponent(current_entity, on_complete_action);
		//	_entityManager->dumpEntity(current_entity);
		}
		else
		{
		//	printf("no next action. removing unhandled action ...");
			_entityManager->removeComponent <Action> (current_entity);	
		//	_entityManager->dumpEntity(current_entity);
		}
		
	}
	
	void ActionSystem::handle_move_to_action (MoveToAction *action)
	{
		MoveToAction *mt= (MoveToAction*)action;
		mt->_timestamp += _current_delta;
		
		if (mt->_ups_x >= INFINITY)
		{
			float dx = mt->x - _current_pos->x;
			mt->_ups_x = dx / mt->duration;
		}
		
		if (mt->_ups_y >= INFINITY)
		{
			float dy = mt->y - _current_pos->y;
			mt->_ups_y = dy / mt->duration;
		}
		
		_current_pos->x += mt->_ups_x * _current_delta;
		_current_pos->y += mt->_ups_y * _current_delta;
		
		
		if ( (mt->duration - mt->_timestamp) <= 0.0)
		{
			//_current_pos->x = mt->x;
			//_current_pos->y = mt->y;
			action->finished = true;
		}
	}
	
	void ActionSystem::handle_move_by_action (MoveByAction *action)
	{
		MoveByAction *mb = action;
		mb->_timestamp += _current_delta;
		
		if (mb->_dx >= INFINITY)
			mb->_dx = _current_pos->x + mb->x;
		if (mb->_dy >= INFINITY)
			mb->_dy = _current_pos->y + mb->y;
		
		_current_pos->x += (mb->x/mb->duration)*_current_delta;
		_current_pos->y += (mb->y/mb->duration)*_current_delta;
		
		
		
		if ( (mb->duration - mb->_timestamp) <= 0.0)
		{
		//	_current_pos->x = mb->_dx;
		//	_current_pos->y = mb->_dy;
			action->finished = true;
		}
	}
	
	void ActionSystem::handle_add_component_action (AddComponentAction *action)
	{
		AddComponentAction *aca = (AddComponentAction*)action;
		
#ifdef ABORT_GUARDS						
		if (!aca->component_to_add)
		{
			printf("no component pointer set!\n");
			_entityManager->dumpEntity(_current_entity);
			_entityManager->dumpComponent(_current_entity,aca);
			abort();
		}
		if (aca->component_to_add->_id == Action::COMPONENT_ID)
		{
			printf("you may not add action components with the AddComponentAction!\n");
			_entityManager->dumpEntity(_current_entity);
			_entityManager->dumpComponent(_current_entity,aca);
			abort();
		}
#endif
		
		aca->_timestamp += _current_delta;
		if ( (aca->duration - aca->_timestamp) <= 0.0)
		{
			aca->finished = true;
			_entityManager->addComponent(_current_entity, aca->component_to_add);
		}
	}
	
	void ActionSystem::handle_parallel_action (ParallelAction *action)
	{
	//	printf("handling parallel action");
		ParallelAction *pa = action;
		
		Action *actions[2];
		actions[0] = pa->action_one;
		actions[1] = pa->action_two;
		
		Action *current_action = NULL;
		
		for (int i = 0; i < 2; i++)
		{
			if (!actions[i])
				continue;
			
			current_action = actions[i];
			
			if (current_action->action_type == ACTIONTYPE_MOVE_TO)
			{
				handle_move_to_action((MoveToAction *)current_action);
				continue;
			}
			if (current_action->action_type == ACTIONTYPE_MOVE_BY)
			{
				handle_move_by_action((MoveByAction *)current_action);
				continue;
			}
			if (current_action->action_type == ACTIONTYPE_ADD_COMPONENT)
			{
				handle_add_component_action((AddComponentAction *)current_action);
				continue;
			}

			
			//default
			//default handler

			if ( (current_action->duration - current_action->_timestamp) <= 0.0)
			{
				current_action->finished = true;
			}
			current_action->_timestamp += _current_delta;
			
		}
		

		//next action one
		if (pa->action_one)
		{
			if (pa->action_one->finished)
			{
				if (pa->action_one->on_complete_action)
				{
					Action *t = pa->action_one->on_complete_action;
					
					delete pa->action_one;
					pa->action_one = t;
				}
				else 
				{
					delete pa->action_one;
					pa->action_one = NULL;
				}
			}
		}
		
		//next action two
		if (pa->action_two)
		{
			if (pa->action_two->finished)
			{
				if (pa->action_two->on_complete_action)
				{
					Action *t = pa->action_two->on_complete_action;
					
					delete pa->action_two;
					pa->action_two = t;
				}
				else 
				{
					delete pa->action_two;
					pa->action_two = NULL;
				}
			}
		}
		
		
		
		
		//check for overall completion		
		if (pa->action_one && pa->action_two)
		{
			if (pa->action_one->finished && pa->action_two->finished)
			{
				action->finished = true;
			}
		}
	
		if (pa->action_one && !pa->action_two)
		{
			if (pa->action_one->finished)
			{
				action->finished = true;
			}
		}
		
		if (!pa->action_one && pa->action_two)
		{
			if (pa->action_two->finished)
			{
				action->finished = true;
			}
		}
		
		//no actions anymore? finished!
		if (!pa->action_one && !pa->action_two)
		{
			action->finished = true;
		}
	}

	void ActionSystem::update (float delta)
	{
		_current_delta = delta;
		_entities.clear();
		_entityManager->getEntitiesPossessingComponents(_entities,  Action::COMPONENT_ID,Position::COMPONENT_ID, ARGLIST_END );

		std::vector<Entity*>::const_iterator it = _entities.begin();
		
		while (it != _entities.end())
		{ 
			_current_entity = *it;
			_current_action = _entityManager->getComponent<Action>(_current_entity);
			_current_pos = _entityManager->getComponent<Position>(_current_entity);

	#ifdef ABORT_GUARDS				
			if (!_current_action)
			{
				_entityManager->dumpEntity(_current_entity);
				abort();
			}
	#endif
			if (_current_action->action_type == ACTIONTYPE_PARALLEL)
			{
				handle_parallel_action ((ParallelAction*)_current_action);
				
				if (_current_action->finished)
				{
					printf("PARALLEL FINISHED!");
					setupNextActionOrStop(_current_entity,_current_action);
				}
				++it;
				continue;
			}
			
			
			//MOVE TO handler
			if (_current_action->action_type == ACTIONTYPE_MOVE_TO)
			{
				handle_move_to_action((MoveToAction*)_current_action);

				if (_current_action->finished)
				{
					setupNextActionOrStop(_current_entity,_current_action);
				}
				++it;
				continue;
			}
			
			//MOVE BY HANDLER
			if (_current_action->action_type == ACTIONTYPE_MOVE_BY)
			{
				MoveByAction *mb = (MoveByAction *)_current_action;
				
				handle_move_by_action(mb);
				
				if (_current_action->finished)
				{
					setupNextActionOrStop(_current_entity,_current_action);
				}
				++it;
				continue;

			}
			
			
			//ACTIONTYPE_ADD_COMPONENT handler
			if (_current_action->action_type == ACTIONTYPE_ADD_COMPONENT)
			{
				AddComponentAction *aca = (AddComponentAction*)_current_action;
				
				handle_add_component_action(aca);
				
				if (_current_action->finished)
				{
					setupNextActionOrStop(_current_entity,_current_action);
				}
				++it;
				continue;
			}
			
			
			
			
			
			
			//ACTIONTYPE_CREATE_ENTITY handler
			if (_current_action->action_type == ACTIONTYPE_CREATE_ENTITY)
			{
				
				_current_action->_timestamp += delta;			
				if ( (_current_action->duration - _current_action->_timestamp) <= 0.0)
				{
					CreateEntityAction *cea = (CreateEntityAction*)_current_action;
					std::vector<Component*>::const_iterator cit = cea->components_to_add.begin();
					
					Entity *newEntity = _entityManager->createNewEntity();
					
					Component *c = NULL;
					while (cit != cea->components_to_add.end())
					{
						c = *cit;
						_entityManager->addComponent(newEntity, c);
						
						++cit;
					}
					setupNextActionOrStop(_current_entity,_current_action);
				}
				++it;
				continue;
			}
			
			
			
			//default handler
			if ( (_current_action->duration - _current_action->_timestamp) <= 0.0)
			{
				setupNextActionOrStop(_current_entity,_current_action);
			}
			_current_action->_timestamp += delta;
			++it;
		}
	}

}