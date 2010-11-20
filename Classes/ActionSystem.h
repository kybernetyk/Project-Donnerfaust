/*
 *  ActionSystem.h
 *  Donnerfaust
 *
 *  Created by jrk on 18/11/10.
 *  Copyright 2010 flux forge. All rights reserved.
 *
 */

#pragma once


#include <vector>
#include "EntityManager.h"
#include "Actions.h"

namespace mx3 
{
	class ActionSystem
	{
	public:
		ActionSystem (EntityManager *entityManager);
		void update (float delta);	
		
		void addActionToEntity (Entity *entity, Action *action);
		void cancelAction (Entity *entity,Action *action);
		
		void handle_action_container ();

		void handle_default_action (Action *action);		
		void handle_move_to_action (MoveToAction *action);
		void handle_move_by_action (MoveByAction *action);
		void handle_create_entity_action (CreateEntityAction *action);
		void handle_add_component_action (AddComponentAction *action);
		
		
		void handle_change_integer_to_action (ChangeIntegerToAction *action);
		void handle_change_float_to_action (ChangeFloatToAction *action);

		void handle_change_integer_by_action (ChangeIntegerByAction *action);
		void handle_change_float_by_action (ChangeFloatByAction *action);
		
		
		void step_action (Action *action);
		
		virtual bool handle_game_action (Action *action);
		
	protected:
		EntityManager *_entityManager;
		std::vector <Entity *> _entities;		
		float _delta;
		
		Entity *_current_entity;
		ActionContainer *_current_container;
		Position *_current_position;	//most actions will be movement anyway. so we should fetch this component only once per entity
		
	};
	
	
}

extern mx3::ActionSystem *g_pActionSystem;