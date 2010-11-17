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

		
		RestingState *rs = new RestingState();
		
		AddComponentAction *aca = new AddComponentAction();
		aca->component_to_add = rs;
		
		fa->on_complete_action = aca;
		
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
	
	void BlobAnimationSystem::apply_landing_animations ()
	{
		std::vector<Entity*>::const_iterator it = _entities.begin();

		LandingState *current_state = NULL;
		Entity *current_entity = NULL;
		FrameAnimation *current_animation = NULL;
		while (it != _entities.end())
		{
			current_entity = *it;
			++it;
			
			current_state = _entityManager->getComponent<LandingState>(current_entity);
			if (!current_state->handled)
			{
				current_state->handled = true;
				appendAnimation(current_entity, collision_animation());
			}
			
			
		}
	}
	
	
	void BlobAnimationSystem::apply_connection_animations ()
	{
		std::vector<Entity*>::const_iterator it = _entities.begin();
		
		GameBoardElement *current_gbe = NULL;
		RestingState *current_state = NULL;
		Entity *current_entity = NULL;
		
		while (it != _entities.end())
		{
			current_entity = *it;
			++it;
			
			current_state = _entityManager->getComponent<RestingState>(current_entity);
			current_gbe = _entityManager->getComponent<GameBoardElement>(current_entity);
			
			if (current_gbe->connection_state != current_gbe->_prev_connection_state)
			{
				if ( (current_gbe->connection_state & CONNECTION_LEFT) == CONNECTION_LEFT )
				{
					appendAnimation(current_entity, connect_left_animation());
				}
				
				
				if ( (current_gbe->connection_state & CONNECTION_RIGHT) == CONNECTION_RIGHT)
				{
					appendAnimation(current_entity, connect_right_animation());
				}
			}
			
		}
		
	}
	void BlobAnimationSystem::update (float delta)
	{
		_entities.clear();
		_entityManager->getEntitiesPossessingComponents(_entities,LandingState::COMPONENT_ID,  AtlasSprite::COMPONENT_ID, GameBoardElement::COMPONENT_ID,Position::COMPONENT_ID, ARGLIST_END );
		
		apply_landing_animations();
		
		
		_entities.clear();
		_entityManager->getEntitiesPossessingComponents(_entities,RestingState::COMPONENT_ID,  AtlasSprite::COMPONENT_ID, GameBoardElement::COMPONENT_ID,Position::COMPONENT_ID, ARGLIST_END );
		apply_connection_animations();
		
	}
	
}