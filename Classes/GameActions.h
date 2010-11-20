/*
 *  GameActions.h
 *  Donnerfaust
 *
 *  Created by jrk on 20/11/10.
 *  Copyright 2010 flux forge. All rights reserved.
 *
 */

using namespace mx3;
namespace game
{
#define GAME_ACTIONTYPE_GBE_SET_STATE_ACTION 16
#define GAME_ACTIONTYPE_GBE_UNSET_STATE_ACTION 17
	
	
	struct GBESetStateAction : public Action
	{
		int state_to_set;
		
		GBESetStateAction()
		{
			Action::Action();
			action_type = GAME_ACTIONTYPE_GBE_SET_STATE_ACTION;
			state_to_set = 0;
		}
		
		DEBUGINFO ("GBESetStateAction")
		
	};
	
	struct GBEUnSetStateAction : public Action
	{
		int state_to_unset;
		
		GBEUnSetStateAction()
		{
			Action::Action();
			action_type = GAME_ACTIONTYPE_GBE_UNSET_STATE_ACTION;
			state_to_unset = 0;
		}
		
		DEBUGINFO ("GBEUnSetStateAction")
		
	};
	
}
