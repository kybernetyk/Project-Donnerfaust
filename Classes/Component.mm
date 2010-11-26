/*
 *  Component.cpp
 *  components
 *
 *  Created by jrk on 3/11/10.
 *  Copyright 2010 flux forge. All rights reserved.
 *
 */

#import "Component.h"
namespace mx3 
{
		
	//0 is reserved!!!!!
	ComponentID MarkOfDeath::COMPONENT_ID = 1;

	ComponentID Position::COMPONENT_ID = 2;

	ComponentID Movement::COMPONENT_ID = 3;

	ComponentID Renderable::COMPONENT_ID = 4;
	ComponentID Sprite::COMPONENT_ID = 4;
	ComponentID AtlasSprite::COMPONENT_ID = 4;
	ComponentID TextLabel::COMPONENT_ID = 4;
	ComponentID BufferedSprite::COMPONENT_ID = 4;
	ComponentID PEmitter::COMPONENT_ID = 4;	
	
	
	ComponentID Name::COMPONENT_ID = 5;

	ComponentID Attachment::COMPONENT_ID = 6;

/*	ComponentID Action::COMPONENT_ID = 7;
	ComponentID ParallelAction::COMPONENT_ID = 7;
	ComponentID MoveToAction::COMPONENT_ID = 8;
	ComponentID MoveByAction::COMPONENT_ID = 9;
	ComponentID AddComponentAction::COMPONENT_ID = 10;
	ComponentID CreateEntityAction::COMPONENT_ID = 11;*/
		
	ComponentID SoundEffect::COMPONENT_ID = 7;

	ComponentID FrameAnimation::COMPONENT_ID = 8;

	ComponentID ActionContainer::COMPONENT_ID = 9;

}