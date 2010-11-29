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
#include "blob_factory.h"

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

	FrameAnimation *new_animation (int row)
	{
		FrameAnimation *fa = new FrameAnimation();
		fa->destroy_on_finish = true;
		fa->loop = false;
		fa->frames_per_second = 24;
		fa->start_frame = 16 * row + 0;
		fa->end_frame = 16 * row + 16;
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
		_entityManager->addComponent(e, anim);
		return;
		
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
	
	void BlobAnimationSystem::check_for_consistency ()
	{
		std::vector<Entity*>::const_iterator it = _entities.begin();
		
		Entity *current_entity = NULL;
		GameBoardElement *current_gbe = NULL;
		AtlasSprite *current_sprite = NULL;
		FrameAnimation *current_animation = NULL;
		rect src, src1, src2, src3, src4;
		bool invalidate;
		while (it != _entities.end())
		{
			current_entity = *it;
			++it;
			
			current_animation = _entityManager->getComponent <FrameAnimation> (current_entity);
			if (current_animation)
				continue;
			
			current_gbe = _entityManager->getComponent <GameBoardElement> (current_entity);
			current_sprite = _entityManager->getComponent <AtlasSprite> (current_entity);

			invalidate = false;
			
			if (current_gbe->connection_state == GBE_CONNECTED_NONE ||
				current_gbe->connection_state == 0)
			{				
				
				src = rect_make(0*32, 0, 32, 32);
				if (!rect_is_equal_to_rect(&current_sprite->src, &src))
					invalidate = true;
			}
			
			if (current_gbe->connection_state == (GBE_CONNECTED_TO_UP))
			{
				src = rect_make(15*32, 0*32, 32, 32);
				if (!rect_is_equal_to_rect(&current_sprite->src, &src))
					invalidate = true;
			}
			
			if (current_gbe->connection_state == (GBE_CONNECTED_TO_LEFT))
			{
				src = rect_make(15*32, 8*32, 32, 32);
				if (!rect_is_equal_to_rect(&current_sprite->src, &src))
					invalidate = true;
			}
			
			if (current_gbe->connection_state == (GBE_CONNECTED_TO_DOWN))
			{
				src = rect_make(15*32, 8*32, 32, 32);
				if (!rect_is_equal_to_rect(&current_sprite->src, &src))
					invalidate = true;
			}
			
			if (current_gbe->connection_state == (GBE_CONNECTED_TO_RIGHT))
			{
				src = rect_make(15*32, 0*32, 32, 32);
				if (!rect_is_equal_to_rect(&current_sprite->src, &src))
					invalidate = true;
				
			}
			
			
			if (current_gbe->connection_state == (GBE_CONNECTED_TO_UP | GBE_CONNECTED_TO_DOWN))
			{
				src1 = rect_make(15*32, 12*32, 32, 32);
				src2 = rect_make(15*32, 4*32, 32, 32);
				
				if (!rect_is_equal_to_rect(&current_sprite->src, &src1) &&
					!rect_is_equal_to_rect(&current_sprite->src, &src2))
					invalidate = true;

			}
			
			if (current_gbe->connection_state == (GBE_CONNECTED_TO_LEFT | GBE_CONNECTED_TO_RIGHT))
			{
					src1 = rect_make(15*32, 1*32, 32, 32);
					src2 = rect_make(15*32, 9*32, 32, 32);
				if (!rect_is_equal_to_rect(&current_sprite->src, &src1) &&
					!rect_is_equal_to_rect(&current_sprite->src, &src2))
					invalidate = true;
				
			}
			
			if (current_gbe->connection_state == (GBE_CONNECTED_TO_UP | GBE_CONNECTED_TO_LEFT))
			{
					src1 = rect_make(15*32, 10*32, 32, 32);
					src2 = rect_make(15*32, 1*32, 32, 32);
				if (!rect_is_equal_to_rect(&current_sprite->src, &src1) &&
					!rect_is_equal_to_rect(&current_sprite->src, &src2))
					invalidate = true;
				
			}
			
			if (current_gbe->connection_state == (GBE_CONNECTED_TO_UP | GBE_CONNECTED_TO_RIGHT))
			{
					src1 = rect_make(15*32, 2*32, 32, 32);
					src2 = rect_make(15*32, 2*32, 32, 32);
				if (!rect_is_equal_to_rect(&current_sprite->src, &src1) &&
					!rect_is_equal_to_rect(&current_sprite->src, &src2))
					invalidate = true;
				
			}
			
			if (current_gbe->connection_state == (GBE_CONNECTED_TO_DOWN | GBE_CONNECTED_TO_LEFT))
			{
					src1 = rect_make(15*32, 11*32, 32, 32);	
					src2 = rect_make(15*32, 9*32, 32, 32);	
				if (!rect_is_equal_to_rect(&current_sprite->src, &src1) &&
					!rect_is_equal_to_rect(&current_sprite->src, &src2))
					invalidate = true;
				
			}
			
			if (current_gbe->connection_state == (GBE_CONNECTED_TO_DOWN | GBE_CONNECTED_TO_RIGHT))
			{
				src = rect_make(15*32, 10*32, 32, 32);
				if (!rect_is_equal_to_rect(&current_sprite->src, &src))
					invalidate = true;
			}
			
			
			if (current_gbe->connection_state == (GBE_CONNECTED_TO_UP | GBE_CONNECTED_TO_DOWN | GBE_CONNECTED_TO_LEFT ))
			{
				src = rect_make(15*32, 5*32, 32, 32);
				if (!rect_is_equal_to_rect(&current_sprite->src, &src))
					invalidate = true;
			}
			
			if (current_gbe->connection_state == (GBE_CONNECTED_TO_UP | GBE_CONNECTED_TO_DOWN | GBE_CONNECTED_TO_RIGHT ))
			{
				src = rect_make(15*32, 6*32, 32, 32);
				if (!rect_is_equal_to_rect(&current_sprite->src, &src))
					invalidate = true;
			}
			
			if (current_gbe->connection_state == (GBE_CONNECTED_TO_UP | GBE_CONNECTED_TO_LEFT | GBE_CONNECTED_TO_RIGHT ))
			{
				src = rect_make(15*32, 3*32, 32, 32);
				if (!rect_is_equal_to_rect(&current_sprite->src, &src))
					invalidate = true;
			}
			
			if (current_gbe->connection_state == (GBE_CONNECTED_TO_DOWN | GBE_CONNECTED_TO_LEFT | GBE_CONNECTED_TO_RIGHT ))
			{
				src = rect_make(15*32, 11*32, 32, 32);
				if (!rect_is_equal_to_rect(&current_sprite->src, &src))
					invalidate = true;
			}
			
			if (current_gbe->connection_state == (GBE_CONNECTED_TO_DOWN | GBE_CONNECTED_TO_LEFT | GBE_CONNECTED_TO_RIGHT | GBE_CONNECTED_TO_UP ))
			{
				src = rect_make(15*32, 15*32, 32, 32);
				if (!rect_is_equal_to_rect(&current_sprite->src, &src))
					invalidate = true;
			}
			
			if (invalidate)
			{
				current_gbe->prev_connection_state = 0xff;
			}
		}
	}
	
	void BlobAnimationSystem::update (float delta)
	{
	
		_entities.clear();
		_entityManager->getEntitiesPossessingComponents(_entities, GameBoardElement::COMPONENT_ID, Position::COMPONENT_ID, ARGLIST_END );

		
		std::vector<Entity*>::const_iterator it = _entities.begin();
		 
		Entity *current_entity = NULL;
		GameBoardElement *current_gbe = NULL;
		while (it != _entities.end())
		{
			 current_entity = *it;
			 ++it;
		 
			current_gbe = _entityManager->getComponent <GameBoardElement> (current_entity);
			
		//	printf("con: %i\n", current_gbe->connection_state);
			if (current_gbe->connection_state == current_gbe->prev_connection_state)
			{	
				
			//	printf("DEIN GESICHT: %i, %i!\n",current_gbe->connection_state,current_gbe->prev_connection_state );
				continue;
				
			}


			unsigned int prev_state = current_gbe->prev_connection_state;
			
			std::string filename = blob_filenames[current_gbe->type];
			rect src = rect_make(0*32, 0, 32, 32);;
			
			FrameAnimation *fa = NULL;
			
			if (current_gbe->connection_state == GBE_CONNECTED_NONE ||
				current_gbe->connection_state == 0)
			{
				filename = blob_filenames[current_gbe->type];
				src = rect_make(0*32, 0, 32, 32);
				current_gbe->animation_state = current_gbe->connection_state;
				printf("none\n");
//				continue;
			}
			
			if (current_gbe->connection_state == (GBE_CONNECTED_TO_UP))
			{
				filename = blob_filenames_2[current_gbe->type];
				src = rect_make(15*32, 0*32, 32, 32);
				current_gbe->animation_state = current_gbe->connection_state;
				fa = new_animation(0);					
				printf("up\n");
			}

			if (current_gbe->connection_state == (GBE_CONNECTED_TO_LEFT))
			{
				filename = blob_filenames[current_gbe->type];
				src = rect_make(15*32, 8*32, 32, 32);

				current_gbe->animation_state = current_gbe->connection_state;
				
				fa = new_animation(8);					

				printf("left\n");
			}

			if (current_gbe->connection_state == (GBE_CONNECTED_TO_DOWN))
			{
				filename = blob_filenames_2[current_gbe->type];
				src = rect_make(15*32, 8*32, 32, 32);
				current_gbe->animation_state = current_gbe->connection_state;
				fa = new_animation(8);					

				printf("down\n");
			}

			if (current_gbe->connection_state == (GBE_CONNECTED_TO_RIGHT))
			{
				filename = blob_filenames[current_gbe->type];
				src = rect_make(15*32, 0*32, 32, 32);

				fa = new_animation(0);					

				current_gbe->animation_state = current_gbe->connection_state;
				printf("right\n");
			}
			

			if (current_gbe->connection_state == (GBE_CONNECTED_TO_UP | GBE_CONNECTED_TO_DOWN))
			{
				filename = blob_filenames_2[current_gbe->type];
				src = rect_make(15*32, 12*32, 32, 32);

				current_gbe->animation_state = current_gbe->connection_state;
				
				if (prev_state == GBE_CONNECTED_TO_UP)
				{
					fa = new_animation(12);					
					src = rect_make(0*32, 12*32, 32, 32);
				}
				if (prev_state == GBE_CONNECTED_TO_DOWN)
				{
					src = rect_make(0*32, 4*32, 32, 32);
					fa = new_animation(4);					
				}
				
				printf("up and down\n");
			}
			
			if (current_gbe->connection_state == (GBE_CONNECTED_TO_LEFT | GBE_CONNECTED_TO_RIGHT))
			{
				filename = blob_filenames[current_gbe->type];
				src = rect_make(15*32, 1*32, 32, 32);
				
				current_gbe->animation_state = current_gbe->connection_state;
				
				
				if (prev_state == GBE_CONNECTED_TO_LEFT)
				{
					src = rect_make(0*32, 1*32, 32, 32);
					fa = new_animation(1);					
				}
				if (prev_state == GBE_CONNECTED_TO_RIGHT)
				{
					src = rect_make(0*32, 9*32, 32, 32);
					fa = new_animation(9);
				}
				

				printf("left and right\n");
			}
			
			if (current_gbe->connection_state == (GBE_CONNECTED_TO_UP | GBE_CONNECTED_TO_LEFT))
			{
				filename = blob_filenames[current_gbe->type];
				src = rect_make(15*32, 10*32, 32, 32);
				
				current_gbe->animation_state = current_gbe->connection_state;
				
				
				if (prev_state == GBE_CONNECTED_TO_UP)
				{
					src = rect_make(0*32, 10*32, 32, 32);
					fa = new_animation(10);					
				}
				if (prev_state == GBE_CONNECTED_TO_LEFT)
				{
					filename = blob_filenames_2[current_gbe->type];
					src = rect_make(0*32, 1*32, 32, 32);
					fa = new_animation(1);
				}
				
				
				printf("up and left\n");
			}
			
			if (current_gbe->connection_state == (GBE_CONNECTED_TO_UP | GBE_CONNECTED_TO_RIGHT))
			{
				filename = blob_filenames[current_gbe->type];
				src = rect_make(15*32, 2*32, 32, 32);
				
				current_gbe->animation_state = current_gbe->connection_state;
				
				
				if (prev_state == GBE_CONNECTED_TO_UP)
				{
					src = rect_make(0*32, 2*32, 32, 32);
					fa = new_animation(2);					
				}

				if (prev_state == GBE_CONNECTED_TO_RIGHT)
				{
					filename = blob_filenames_2[current_gbe->type];
					src = rect_make(0*32, 2*32, 32, 32);
					fa = new_animation(2);
				}
				
				
				printf("up and right\n");
			}
			
			if (current_gbe->connection_state == (GBE_CONNECTED_TO_DOWN | GBE_CONNECTED_TO_LEFT))
			{
				filename = blob_filenames[current_gbe->type];
				src = rect_make(15*32, 11*32, 32, 32);	
				
				current_gbe->animation_state = current_gbe->connection_state;
				
				
				
				if (prev_state == GBE_CONNECTED_TO_DOWN)
				{
					filename = blob_filenames[current_gbe->type];
					src = rect_make(0*32, 11*32, 32, 32);	
					fa = new_animation(11);
				}

				if (prev_state == GBE_CONNECTED_TO_LEFT)
				{
					filename = blob_filenames_2[current_gbe->type];
					src = rect_make(0*32, 9*32, 32, 32);	
					fa = new_animation(9);
				}
				

				printf("left and down\n");
			}

			if (current_gbe->connection_state == (GBE_CONNECTED_TO_DOWN | GBE_CONNECTED_TO_RIGHT))
			{
				filename = blob_filenames_2[current_gbe->type];
				src = rect_make(15*32, 10*32, 32, 32);
				
				current_gbe->animation_state = current_gbe->connection_state;
				
				
				if (prev_state == GBE_CONNECTED_TO_DOWN)
				{
					filename = blob_filenames[current_gbe->type];
					src = rect_make(0*32, 3*32, 32, 32);
					fa = new_animation(3);
				}
				if (prev_state == GBE_CONNECTED_TO_RIGHT)
				{
					src = rect_make(0*32, 10*32, 32, 32);
					fa = new_animation(10);
				}
				
				printf("up and down\n");
			}
			
			
			if (current_gbe->connection_state == (GBE_CONNECTED_TO_UP | GBE_CONNECTED_TO_DOWN | GBE_CONNECTED_TO_LEFT ))
			{
				
				current_gbe->animation_state = current_gbe->connection_state;
				
				filename = blob_filenames_2[current_gbe->type];
				src = rect_make(15*32, 5*32, 32, 32);

				printf("up, down, left\n");
			}
			
			if (current_gbe->connection_state == (GBE_CONNECTED_TO_UP | GBE_CONNECTED_TO_DOWN | GBE_CONNECTED_TO_RIGHT ))
			{
				
				current_gbe->animation_state = current_gbe->connection_state;
				
				filename = blob_filenames_2[current_gbe->type];
				src = rect_make(15*32, 6*32, 32, 32);
				
				printf("up, down, right\n");
			}

			
			if (current_gbe->connection_state == (GBE_CONNECTED_TO_UP | GBE_CONNECTED_TO_LEFT | GBE_CONNECTED_TO_RIGHT ))
			{
				
				current_gbe->animation_state = current_gbe->connection_state;
				
				filename = blob_filenames_2[current_gbe->type];
				src = rect_make(15*32, 3*32, 32, 32);

				
				printf("up, left, right\n");
			}
			
			if (current_gbe->connection_state == (GBE_CONNECTED_TO_DOWN | GBE_CONNECTED_TO_LEFT | GBE_CONNECTED_TO_RIGHT ))
			{
				
				current_gbe->animation_state = current_gbe->connection_state;
				
				filename = blob_filenames_2[current_gbe->type];
				src = rect_make(15*32, 11*32, 32, 32);

				
				printf("down, left, right\n");
			}

			if (current_gbe->connection_state == (GBE_CONNECTED_TO_DOWN | GBE_CONNECTED_TO_LEFT | GBE_CONNECTED_TO_RIGHT | GBE_CONNECTED_TO_UP ))
			{
				
				current_gbe->animation_state = current_gbe->connection_state;
				
				filename = blob_filenames_2[current_gbe->type];
				src = rect_make(15*32, 15*32, 32, 32);

				
				printf("ALL\n");
			}

			current_gbe->prev_connection_state = current_gbe->connection_state;
			
			AtlasSprite *as = _entityManager->addComponent<AtlasSprite>(current_entity);
			as->atlas_quad = g_RenderableManager.accquireTexturedAtlasQuad(filename);
			as->src = src; 
			as->z = 3;
				
			
			if (fa)
				appendAnimation(current_entity, fa);
			
		}
		
		check_for_consistency();
		
	}
	
}