/*
 *  ActionSystem.h
 *  ComponentV3
 *
 *  Created by jrk on 8/11/10.
 *  Copyright 2010 flux forge. All rights reserved.
 *
 */
#pragma once

#include <vector>
#include "EntityManager.h"
namespace mx3 
{
	
		
	class ActionSystem
	{
	public:
		ActionSystem (EntityManager *entityManager);
		void update (float delta);	
		
		
	protected:
		float _current_delta;
		
		void handle_move_to_action (MoveToAction *action);
		void handle_move_by_action (MoveByAction *action);
		void handle_parallel_action (ParallelAction *action);
		void handle_add_component_action (AddComponentAction *action);
		
		void setupNextActionOrStop (Entity *e,Action *current_action);
		
		EntityManager *_entityManager;
		
		std::vector<Entity*> _entities;
		
		
		Entity *_current_entity;
		Position *_current_pos;
		Action *_current_action;
		
	};


}