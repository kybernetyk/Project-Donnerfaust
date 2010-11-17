/*
 *  GameComponens.cpp
 *  ComponentV3
 *
 *  Created by jrk on 16/11/10.
 *  Copyright 2010 flux forge. All rights reserved.
 *
 */

#include "GameComponents.h"

using namespace mx3;
namespace game 
{
	//user
	ComponentID PlayerController::COMPONENT_ID = 16;
	
	ComponentID Enemy::COMPONENT_ID = 17;
	
	ComponentID GameBoardElement::COMPONENT_ID = 18;
	
	ComponentID FallingState::COMPONENT_ID = 19;
	ComponentID LandingState::COMPONENT_ID = 20;
	ComponentID RestingState::COMPONENT_ID = 21;
	
	ComponentID Collidable::COMPONENT_ID = 22;

}
