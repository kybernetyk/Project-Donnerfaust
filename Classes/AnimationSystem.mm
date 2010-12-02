/*
 *  AnimationSystem.cpp
 *  ComponentV3
 *
 *  Created by jrk on 14/11/10.
 *  Copyright 2010 flux forge. All rights reserved.
 *
 */
#include "SystemConfig.h"
#include "AnimationSystem.h"
#include "ActionSystem.h"
namespace mx3 
{
		
		
	AnimationSystem::AnimationSystem (EntityManager *entityManager)
	{
		_entityManager = entityManager;
	}

	void AnimationSystem::setupNextAnimationOrStop (Entity *e, FrameAnimation *current_animation)
	{
		Entity *current_entity = e;
		//	Action *current_action = _entityManager->getComponent<Action>(current_entity);
		
		FrameAnimation *next_animation = current_animation->next_animation;
		
		if (current_animation->on_complete_action)
		{
			//_entityManager->addComponent (e,current_animation->on_complete_action);
			g_pActionSystem->addActionToEntity (e, current_animation->on_complete_action);
		}
		
		if (next_animation)
		{
			//	printf("adding next action ...");
			
			_entityManager->removeComponent <FrameAnimation> (current_entity);
			_entityManager->addComponent(current_entity, next_animation);
			//	_entityManager->dumpEntity(current_entity);
		}
		else
		{
			//	printf("no next action. removing unhandled action ...");
			_entityManager->removeComponent <FrameAnimation> (current_entity);	
			//	_entityManager->dumpEntity(current_entity);
		}
		
	}
	
	void AnimationSystem::update (float delta)
	{
		_entities.clear();
		_entityManager->getEntitiesPossessingComponents (_entities, FrameAnimation::COMPONENT_ID, AtlasSprite::COMPONENT_ID, ARGLIST_END);
		
		std::vector<Entity*>::const_iterator it = _entities.begin();
		
		//printf("movement system updating with delta %f on %i entities ...\n",delta,moveableList.size());
		
		
		Entity *current_entity = NULL;
		FrameAnimation *current_animation = NULL;
		AtlasSprite *current_sprite = NULL;
		
		while (it != _entities.end())
		{
			current_entity = *it;
			++it;

			current_animation = _entityManager->getComponent<FrameAnimation>(current_entity);
			current_sprite = _entityManager->getComponent<AtlasSprite>(current_entity);
	#ifdef __ABORT_GUARDS__
			if (!current_animation || !current_sprite)
			{
				printf("An animable entity has to have a FrameAnimation _AND_ an AtlasSprite!\n");
				_entityManager->dumpEntity(current_entity);
				abort();
			}
	#endif
			if (current_animation->state == ANIMATION_STATE_PLAY)
			{
				if (current_animation->start_frame <= current_animation->end_frame)
					current_animation->current_frame += (delta * current_animation->frames_per_second * current_animation->speed_scale);
				else
					current_animation->current_frame -= (delta * current_animation->frames_per_second * current_animation->speed_scale);
				
				if (current_animation->start_frame <= current_animation->end_frame)
				{
					//forward
					if ((int)current_animation->current_frame >= (int)current_animation->end_frame)
					{	
						if (current_animation->loop)
						{
							current_animation->current_frame = current_animation->start_frame;
						}
						else
						{
							if (current_animation->destroy_on_finish)
							{
								setupNextAnimationOrStop(current_entity, current_animation);
								continue;
							}
							
							current_animation->state = ANIMATION_STATE_PAUSE;
						}
						
					}
					
				}
				else
				{
					if ((int)current_animation->current_frame <= (int)current_animation->end_frame)
					{
						if (current_animation->loop)
						{
							current_animation->current_frame = current_animation->start_frame;
						}
						else
						{
							if (current_animation->destroy_on_finish)
							{
								setupNextAnimationOrStop(current_entity, current_animation);
								continue;
							}
							
							
							current_animation->state = ANIMATION_STATE_PAUSE;
						}
					}
					
				}
				
				
				rect fs = current_animation->frame_size;
				int sx = current_sprite->atlas_quad->tex_w / fs.w;
			//	int sy = current_sprite->atlas_quad->tex_h / fs.h;
				
				int fx = ((int)current_animation->current_frame) % sx;
				int fy = ((int)current_animation->current_frame) / sx; // (/ sy is for quadratische texutren! ansonsten muessen wir durch x beficken, damit wir indexiert tun koennen)
				
				current_sprite->src.x = fx * fs.w;
				current_sprite->src.y = fy * fs.h;
			}
			
		}
		
	}

}