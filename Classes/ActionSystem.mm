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
		
		Action *next_action = current_action->next_action;
		
		if (next_action)
		{
		//	printf("adding next action ...");

			_entityManager->removeComponent <Action> (current_entity);
			_entityManager->addComponent(current_entity, next_action);
		//	_entityManager->dumpEntity(current_entity);
		}
		else
		{
		//	printf("no next action. removing unhandled action ...");
			_entityManager->removeComponent <Action> (current_entity);	
		//	_entityManager->dumpEntity(current_entity);
		}
		
	}


	void ActionSystem::update (float delta)
	{
		_entities.clear();
		_entityManager->getEntitiesPossessingComponents(_entities,  Action::COMPONENT_ID,Position::COMPONENT_ID, ARGLIST_END );

		std::vector<Entity*>::const_iterator it = _entities.begin();
		
		Entity *current_entity = NULL;
		Position *current_pos = NULL;
		Action *current_action = NULL;
		bool action_handled = false;
		
		while (it != _entities.end())
		{ 
			current_entity = *it;
			current_action = _entityManager->getComponent<Action>(current_entity);
			current_pos = _entityManager->getComponent<Position>(current_entity);
			action_handled = false;

	#ifdef ABORT_GUARDS				
			if (!current_action)
			{
				_entityManager->dumpEntity(current_entity);
				abort();
			}
	#endif
			
			//MOVE TO handler
			if (current_action->action_type == ACTIONTYPE_MOVE_TO)
			{
				action_handled = true;
				MoveToAction *mt= (MoveToAction*)current_action;
				mt->_timestamp += delta;

				if (mt->_ups_x >= INFINITY)
				{
					float dx = mt->x - current_pos->x;
					mt->_ups_x = dx / mt->duration;
				}

				if (mt->_ups_y >= INFINITY)
				{
					float dy = mt->y - current_pos->y;
					mt->_ups_y = dy / mt->duration;
				}
				
				current_pos->x += mt->_ups_x * delta;
				current_pos->y += mt->_ups_y * delta;


				if ( (mt->duration - mt->_timestamp) <= 0.0)
				{
					current_pos->x = mt->x;
					current_pos->y = mt->y;
					setupNextActionOrStop (current_entity,current_action );
					++it;
					continue;
				}
				

				
				/*
				float dx = mt->x - current_pos->x;
				float dy = mt->y - current_pos->y;
				float d = sqrt ( dx*dx + dy*dy );
				
				if (d <= .1)
				{	
					current_pos->x = mt->x;
					current_pos->y = mt->y;
					setupNextActionOrStop (current_entity);
				}
				else
				{
					float step_x = dx * delta / mt->duration;
					float step_y = dy * delta / mt->duration;
					mt->duration-=delta;
					current_pos->x += step_x;
					current_pos->y += step_y;
				}*/

				++it;
				continue;
			}
			
			//MOVE BY HANDLER
			if (current_action->action_type == ACTIONTYPE_MOVE_BY)
			{
				action_handled = true;
				MoveByAction *mb = (MoveByAction *)current_action;
				mb->_timestamp += delta;
				
				if (mb->_dx >= INFINITY)
					mb->_dx = current_pos->x + mb->x;
				if (mb->_dy >= INFINITY)
					mb->_dy = current_pos->y + mb->y;
				
				current_pos->x += (mb->x/mb->duration)*delta;
				current_pos->y += (mb->y/mb->duration)*delta;
				

				
				if ( (mb->duration - mb->_timestamp) <= 0.0)
				{
					current_pos->x = mb->_dx;
					current_pos->y = mb->_dy;
					
					setupNextActionOrStop(current_entity,current_action);
					++it;
					continue;
				}

				++it;
				continue;
			}
			
			
			//ACTIONTYPE_ADD_COMPONENT handler
			if (current_action->action_type == ACTIONTYPE_ADD_COMPONENT)
			{
				action_handled = true;
				AddComponentAction *aca = (AddComponentAction*)current_action;

	#ifdef ABORT_GUARDS						
				if (!aca->component_to_add)
				{
					printf("no component pointer set!\n");
					_entityManager->dumpEntity(current_entity);
					_entityManager->dumpComponent(current_entity,aca);
					abort();
				}
				if (aca->component_to_add->_id == Action::COMPONENT_ID)
				{
					printf("you may not add action components with the AddComponentAction!\n");
					_entityManager->dumpEntity(current_entity);
					_entityManager->dumpComponent(current_entity,aca);
					abort();
				}
	#endif
				
				current_action->_timestamp += delta;
				if ( (current_action->duration - current_action->_timestamp) <= 0.0)
				{
					_entityManager->addComponent(current_entity, aca->component_to_add);
					setupNextActionOrStop(current_entity,current_action);	
				}
				++it;			
				continue;
			}
			
			
			//ACTIONTYPE_CREATE_ENTITY handler
			if (current_action->action_type == ACTIONTYPE_CREATE_ENTITY)
			{
				action_handled = true;
				
				current_action->_timestamp += delta;			
				if ( (current_action->duration - current_action->_timestamp) <= 0.0)
				{
					CreateEntityAction *cea = (CreateEntityAction*)current_action;
					std::vector<Component*>::const_iterator cit = cea->components_to_add.begin();
					
					Entity *newEntity = _entityManager->createNewEntity();
					
					Component *c = NULL;
					while (cit != cea->components_to_add.end())
					{
						c = *cit;
						_entityManager->addComponent(newEntity, c);
						
						++cit;
					}
					setupNextActionOrStop(current_entity,current_action);
				}

				
				
				++it;
				continue;
			}
			
			//default handler
	//		if (!action_handled)
			{
			//	printf("action unhandled:");
			//	_entityManager->dumpComponent(current_entity, current_action);
				
				if ( (current_action->duration - current_action->_timestamp) <= 0.0)
				{
					setupNextActionOrStop(current_entity,current_action);
				}
				current_action->_timestamp += delta;
			}
			
			
			++it;
		}
	}

}