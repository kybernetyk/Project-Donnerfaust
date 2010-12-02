/*
 *  Actions.h
 *  Donnerfaust
 *
 *  Created by jrk on 20/11/10.
 *  Copyright 2010 flux forge. All rights reserved.
 *
 */
#pragma once

namespace mx3
{
#pragma mark -
#pragma mark action
	
#define ACTIONTYPE_NONE 0
#define ACTIONTYPE_MOVE_TO 1
#define ACTIONTYPE_MOVE_BY 2
#define ACTIONTYPE_ADD_COMPONENT 3
#define ACTIONTYPE_CREATE_ENTITY 4

	struct Component;
	
	struct Action
	{
		unsigned int action_type;			//action type for the action system's internal use
		
		float duration;						//the action's duration
		float _timestamp;					//internal framecounter				
		
		Action *on_complete_action;				//the action that should be ran after this one. NULL indicates no action
		
		
		bool finished;
		bool may_be_aborted;				//may this action be aborted/replaced by another one?
		
		Action()
		{
			action_type = ACTIONTYPE_NONE;
			on_complete_action = NULL;
			_timestamp = duration = 0.0;
			may_be_aborted = true;
			finished = false;
		}
		
		virtual ~Action ()
		{
		}

		
		//DEBUGINFO ("Empty Action with duration: %f and timestamp: %f", duration, _timestamp)
	};
	
	
	struct MoveToAction : public Action
	{
		float x,y;			//absolute position to reach after duration
		
		float _ups_x;		//units per second - internal speed value
		float _ups_y;		//units per second - internal speed value
		
		MoveToAction()
		{
			_ups_x = INFINITY;
			_ups_y = INFINITY;
			
			x = y = 0.0;
			action_type = ACTIONTYPE_MOVE_TO;
		}
		
		~MoveToAction()
		{
		}
		
		//DEBUGINFO ("Move To: x=%f, y=%f duration: %f timestamp: %f",x,y,duration, _timestamp)
	};
	struct MoveByAction : public Action
	{
		
		float x,y;	//relative distance to go during duration
		
		float _dx;	//cached destination x - internal use for action system
		float _dy;	//cached destination y - internal use for action system
		
		MoveByAction()
		{
			_dx = _dy = INFINITY;			//mark with INFINITY to dirty so the action system can see that this value needs an init
			x = y = 0.0;
			action_type = ACTIONTYPE_MOVE_BY;
		}
		
		//DEBUGINFO ("Move By: x=%f, y=%f duration: %f timestamp: %f",x,y,duration, _timestamp)
	};
	struct AddComponentAction : public Action
	{
		
		Component *component_to_add;		//this will add the existing component pointed to
		
		
		AddComponentAction()
		{
			component_to_add = NULL;
			
			action_type = ACTIONTYPE_ADD_COMPONENT;
		}
		
	//	DEBUGINFO ("AddComponentAction: %p duration: %f timestamp: %f",component_to_add,duration,_timestamp)
	};
	
	struct CreateEntityAction : public Action
	{
		std::vector <Component *> components_to_add;
		
		CreateEntityAction()
		{
			action_type = ACTIONTYPE_CREATE_ENTITY;
		}
	//	
	//	DEBUGINFO ("CreateEntityAction. duration: %f timestamp: %f",duration,_timestamp)
	};
	
#define ACTIONTYPE_CHANGE_INTEGER_TO 5
	//maybe templatE?
	struct ChangeIntegerToAction : public Action
	{
		int *pIntToChange;
		int new_value;
		
		ChangeIntegerToAction()
		{
			action_type = ACTIONTYPE_CHANGE_INTEGER_TO;
			pIntToChange = NULL;
			new_value = 0;
		}
	};
	
#define ACTIONTYPE_CHANGE_INTEGER_BY 6
	struct ChangeIntegerByAction : public Action
	{
		int *pIntToChange;
		int amount;
		
		ChangeIntegerByAction()
		{
			action_type = ACTIONTYPE_CHANGE_INTEGER_BY;
			pIntToChange = NULL;
			amount = 0;
		}
	};
	
	
	
	
#define ACTIONTYPE_CHANGE_FLOAT_TO 7
	struct ChangeFloatToAction : public Action
	{
		float *pFloatToChange;
		float new_value;
		
		ChangeFloatToAction()
		{
			action_type = ACTIONTYPE_CHANGE_FLOAT_TO;
			pFloatToChange = NULL;
			new_value = 0;
		}
	};
	
#define ACTIONTYPE_CHANGE_FLOAT_BY 8
	struct ChangeFloatByAction : public Action
	{
		float *pFloatToChange;
		float amount;
		
		ChangeFloatByAction()
		{
			action_type = ACTIONTYPE_CHANGE_FLOAT_BY;
			pFloatToChange = NULL;
			amount = 0;
		}
	};
	
	
	
	
}