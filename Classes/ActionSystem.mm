/*
 *  ActionSystem.cpp
 *  Donnerfaust
 *
 *  Created by jrk on 18/11/10.
 *  Copyright 2010 flux forge. All rights reserved.
 *
 */

#include "ActionSystem.h"

#include <math.h>
mx3::ActionSystem *g_pActionSystem;

namespace mx3 
{
	ActionSystem::ActionSystem (EntityManager *entityManager)
	{
		_entityManager = entityManager;
		g_pActionSystem = this;
	}


	void ActionSystem::addActionToEntity (Entity *entity, Action *action)
	{
		ActionContainer *container = _entityManager->getComponent<ActionContainer>(entity);
		if (!container)
			container = _entityManager->addComponent<ActionContainer>(entity);
		
		for (int i = 0; i < 32; i++)
		{
			if (!container->actions[i])
			{
				container->actions[i] = action;
				break;
			}
		}
		
	}
	
	void ActionSystem::step_action (Action *action)
	{
		action->_timestamp += _delta;
		if ( (action->duration - action->_timestamp) <= 0.0)
		{
			action->finished = true;
		}
		
	}
	
	void ActionSystem::handle_default_action (Action *action)
	{
		//printf(".");
	}
	
	void ActionSystem::handle_move_to_action (MoveToAction *action)
	{
		Position *current_pos = _entityManager->getComponent<Position>(_current_entity);
		
		if (action->_ups_x >= INFINITY)
		{
			float dx = action->x - current_pos->x;
			action->_ups_x = dx / action->duration;
		}
		
		if (action->_ups_y >= INFINITY)
		{
			float dy = action->y - current_pos->y;
			action->_ups_y = dy / action->duration;
		}
		
		current_pos->x += action->_ups_x * _delta;
		current_pos->y += action->_ups_y * _delta;
		
	}
	
	void ActionSystem::handle_move_by_action (MoveByAction *action)
	{
		Position *current_pos = _entityManager->getComponent<Position>(_current_entity);

		
		if (action->_dx >= INFINITY)
			action->_dx = current_pos->x + action->x;
		if (action->_dy >= INFINITY)
			action->_dy = current_pos->y + action->y;
		
		current_pos->x += (action->x/action->duration)*_delta;
		current_pos->y += (action->y/action->duration)*_delta;
		
		
	}

	void ActionSystem::handle_add_component_action (AddComponentAction *action)
	{
		
#ifdef ABORT_GUARDS						
		if (!action->component_to_add)
		{
			printf("no component pointer set!\n");
			_entityManager->dumpEntity(_current_entity);
			_entityManager->dumpComponent(_current_entity,_current_container);
			abort();
		}
		if (action->component_to_add->_id == ActionContainer::COMPONENT_ID)
		{
			printf("you may not add action containers components with the AddComponentAction!\n");
			_entityManager->dumpEntity(_current_entity);
			_entityManager->dumpComponent(_current_entity,_current_container);
			abort();
		}
#endif

		if (action->finished)
		{
			_entityManager->addComponent(_current_entity, action->component_to_add);
		}
		
	}
	
	void ActionSystem::handle_create_entity_action (CreateEntityAction *action)
	{
		
		if (action->finished)
		{
			std::vector<Component*>::const_iterator it = action->components_to_add.begin();	
			
			Entity *newEntity = _entityManager->createNewEntity();
			Component *c = NULL;
			while (it != action->components_to_add.end())
			{
				c = *it;
				++it;
				_entityManager->addComponent(newEntity, c);
			}
			
		}
		
	}
	
	
	void ActionSystem::handle_action_container ()
	{
		Action **actions = _current_container->actions;
		
		Action *current_action = NULL;
		for (int i = 0; i < 32; i++)
		{
			current_action = actions[i];
			if (!current_action)
				continue;
			
			step_action(current_action);

			switch (current_action->action_type) 
			{
				case ACTIONTYPE_MOVE_TO:
					handle_move_to_action((MoveToAction*)current_action);
					break;
				case ACTIONTYPE_MOVE_BY:
					handle_move_by_action((MoveByAction*)current_action);
					break;
				case ACTIONTYPE_ADD_COMPONENT:
					handle_add_component_action((AddComponentAction*)current_action);
					break;
				case ACTIONTYPE_CREATE_ENTITY:
					handle_create_entity_action((CreateEntityAction*)current_action);
					break;

				case ACTIONTYPE_NONE:
				default:
					handle_default_action(current_action);
					break;
			}
			

			
			if (current_action->finished)
			{
				Action *on_complete_action = current_action->on_complete_action;
				
				if (on_complete_action)
				{
					delete current_action;
					current_action = NULL;
					_current_container->actions[i] = on_complete_action;
				}
				else
				{
					delete current_action;
					current_action = NULL;
					_current_container->actions[i] = NULL;
				}
					
			}
			
		}
	}
	
	void ActionSystem::update (float delta)
	{
		_delta = delta;
		_entities.clear();
		_entityManager->getEntitiesPossessingComponent (_entities, ActionContainer::COMPONENT_ID);
		
		std::vector <Entity *>::const_iterator it = _entities.begin();
		
	//	Entity *current_entity = NULL;
	//	ActionContainer *current_container = NULL;
		
		
		while (it != _entities.end())
		{
			_current_entity = *it;
			++it;
			
			_current_container = _entityManager->getComponent<ActionContainer>(_current_entity);

#ifdef ABORT_GUARDS
			if (!_current_container)
				abort();
#endif
			
			handle_action_container();
		}
		
		//1. get entities with action containers
		//2. run actions in the container on the entity
		//3. if a action expires, check if it has a next_action. if so, make it the active action and kill the expired action

	}
}