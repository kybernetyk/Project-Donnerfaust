/*
 *  GameActionSystem.cpp
 *  Donnerfaust
 *
 *  Created by jrk on 20/11/10.
 *  Copyright 2010 flux forge. All rights reserved.
 *
 */

#include "GameActionSystem.h"

namespace game
{
	void GameActionSystem::handle_gbe_set_state_action (GBESetStateAction *action)
	{
		if (action->finished)
		{
			game::GameBoardElement *gbe = _entityManager->getComponent<GameBoardElement>(_current_entity);
			
			gbe->state |= action->state_to_set;
		}
		
	}
	void GameActionSystem::handle_gbe_unset_state_action (GBEUnSetStateAction *action)
	{
		if (action->finished)
		{
			game::GameBoardElement *gbe = _entityManager->getComponent<GameBoardElement>(_current_entity);
			
			gbe->state &= ~action->state_to_unset;
		}
		
	}
	
	
	bool GameActionSystem::handle_game_action(mx3::Action *action)
	{
		switch (action->action_type) 
		{
			case GAME_ACTIONTYPE_GBE_SET_STATE_ACTION:
				handle_gbe_set_state_action((GBESetStateAction *)action);
				break;
			case GAME_ACTIONTYPE_GBE_UNSET_STATE_ACTION:
				handle_gbe_unset_state_action((GBEUnSetStateAction *)action);
				break;
				
			default:
				return false;
				break;
		}
		
		return true;
	}
}