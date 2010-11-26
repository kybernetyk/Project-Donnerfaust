/*
 *  BlobAnimationSystem.cpp
 *  Donnerfaust
 *
 *  Created by jrk on 17/11/10.
 *  Copyright 2010 flux forge. All rights reserved.
 *
 */

#include "BlobAnimationSystem.h"
#include "Component.h"
#include "GameComponents.h"

namespace game 
{
	FrameAnimation *collision_animation ()
	{
		FrameAnimation *fa = new FrameAnimation();
		fa->destroy_on_finish = true;
		fa->loop = false;
		fa->frames_per_second = 24;
		fa->start_frame = 0;
		fa->end_frame = 14;
		fa->current_frame = fa->start_frame;
		fa->frame_size = rect_make(0.0, 0.0, 32.0, 32.0);
		fa->state = ANIMATION_STATE_PLAY;

		
		
		return fa;
	}
	
	FrameAnimation *connect_left_animation ()
	{
		FrameAnimation *fa = new FrameAnimation();
		fa->destroy_on_finish = true;
		fa->loop = false;
		fa->frames_per_second = 24;
		fa->start_frame = 30;
		fa->end_frame = 44;
		fa->current_frame = fa->start_frame;
		fa->frame_size = rect_make(0.0, 0.0, 32.0, 32.0);
		fa->state = ANIMATION_STATE_PLAY;
		
		return fa;
	}
	
	FrameAnimation *connect_right_animation ()
	{
		FrameAnimation *fa = new FrameAnimation();
		 fa->destroy_on_finish = true;
		 fa->loop = false;
		 fa->frames_per_second = 24;
		 fa->start_frame = 13;
		 fa->end_frame = 28;
		 fa->current_frame = fa->start_frame;		
		 fa->frame_size = rect_make(0.0, 0.0, 32.0, 32.0);
		 fa->state = ANIMATION_STATE_PLAY;
		
		return fa;
	}

	
	
	BlobAnimationSystem::BlobAnimationSystem (EntityManager *entityManager)
	{
		_entityManager = entityManager;
	}
	
	void BlobAnimationSystem::appendAnimation (Entity *e, FrameAnimation *anim )
	{
		FrameAnimation *current_animation = e->get<FrameAnimation>();
		if (current_animation)
		{
			current_animation->next_animation = anim;
		}
		else
		{
			_entityManager->addComponent(e, anim);
		}
		
	}
	
	void BlobAnimationSystem::update (float delta)
	{
		_entities.clear();
		
	}
	
}