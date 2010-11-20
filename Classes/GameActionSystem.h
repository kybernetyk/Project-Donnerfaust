/*
 *  GameActionSystem.h
 *  Donnerfaust
 *
 *  Created by jrk on 20/11/10.
 *  Copyright 2010 flux forge. All rights reserved.
 *
 */
#include <vector>
#include "EntityManager.h"
#include "ActionSystem.h"
#include "GameActions.h"

namespace game
{
	class GameActionSystem : public mx3::ActionSystem
	{
	public:
		GameActionSystem (EntityManager *entityManager)
		: ActionSystem(entityManager)
		{
			
		}
		bool handle_game_action(mx3::Action *action);
		
		
		//extend here
		void handle_gbe_set_state_action (GBESetStateAction *action);
		void handle_gbe_unset_state_action (GBEUnSetStateAction *action);		
	};
}