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
		fa->frames_per_second = 48;
		fa->start_frame = 16 * row + 0;
		
		if (row == 11)
			printf("row 11! start frame: %i\n", fa->start_frame);
		
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
			
			
			if (_entityManager->getComponent <NeedsAnimation> (current_entity))
			{
				_entityManager->removeComponent <NeedsAnimation> (current_entity);
			}
			else
			{
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
				
				printf("none\n");

				goto addshit;
			}
			
			if (current_gbe->connection_state == (GBE_CONNECTED_TO_UP))
			{
				filename = blob_filenames_2[current_gbe->type];
				src = rect_make(0*32, 0*32, 32, 32);
				fa = new_animation(0);					
				printf("up\n");
				goto addshit;
			}

			if (current_gbe->connection_state == (GBE_CONNECTED_TO_LEFT))
			{
				filename = blob_filenames[current_gbe->type];
				src = rect_make(0*32, 8*32, 32, 32);

				
				fa = new_animation(8);					

				printf("left\n");
				goto addshit;
			}

			if (current_gbe->connection_state == (GBE_CONNECTED_TO_DOWN))
			{
				filename = blob_filenames_2[current_gbe->type];
				src = rect_make(0*32, 8*32, 32, 32);
				fa = new_animation(8);					

				printf("down\n");
				goto addshit;
			}

			if (current_gbe->connection_state == (GBE_CONNECTED_TO_RIGHT))
			{
				filename = blob_filenames[current_gbe->type];
				src = rect_make(0*32, 0*32, 32, 32);

				fa = new_animation(0);					

				printf("right\n");
				goto addshit;
			}
			

			if (current_gbe->connection_state == (GBE_CONNECTED_TO_UP | GBE_CONNECTED_TO_DOWN))
			{
				filename = blob_filenames_2[current_gbe->type];
				src = rect_make(15*32, 4*32, 32, 32);

				
				if (prev_state == GBE_CONNECTED_TO_UP)
				{
					filename = blob_filenames_2[current_gbe->type];
					fa = new_animation(12);					
					src = rect_make(0*32, 12*32, 32, 32);
				}
				if (prev_state == GBE_CONNECTED_TO_DOWN)
				{
					filename = blob_filenames_2[current_gbe->type];
					src = rect_make(0*32, 4*32, 32, 32);
					fa = new_animation(4);					
				}
				
//				if (!fa)
//					fa = new_animation(4);
				
				printf("up and down\n");
				goto addshit;
			}
			
			if (current_gbe->connection_state == (GBE_CONNECTED_TO_LEFT | GBE_CONNECTED_TO_RIGHT))
			{
				filename = blob_filenames[current_gbe->type];
				src = rect_make(15*32, 1*32, 32, 32);
				
				
				if (prev_state == GBE_CONNECTED_TO_LEFT)
				{
					filename = blob_filenames[current_gbe->type];
					src = rect_make(0*32, 1*32, 32, 32);
					fa = new_animation(1);					
				}
				if (prev_state == GBE_CONNECTED_TO_RIGHT)
				{
					filename = blob_filenames[current_gbe->type];
					src = rect_make(0*32, 9*32, 32, 32);
					fa = new_animation(9);
				}
				

				printf("left and right\n");
				goto addshit;
			}
			
			if (current_gbe->connection_state == (GBE_CONNECTED_TO_UP | GBE_CONNECTED_TO_LEFT))
			{
				filename = blob_filenames_2[current_gbe->type];
				src = rect_make(15*32, 1*32, 32, 32);
				
				
				if (prev_state == GBE_CONNECTED_TO_UP)
				{
					filename = blob_filenames[current_gbe->type];
					src = rect_make(0*32, 10*32, 32, 32);
					fa = new_animation(10);					
				}
				if (prev_state == GBE_CONNECTED_TO_LEFT)
				{
					filename = blob_filenames_2[current_gbe->type];
					src = rect_make(0*32, 1*32, 32, 32);
					fa = new_animation(1);
				}

//				if (!fa)
//					fa = new_animation(1);

				
				printf("up and left\n");
				goto addshit;
			}
			
			if (current_gbe->connection_state == (GBE_CONNECTED_TO_UP | GBE_CONNECTED_TO_RIGHT))
			{
				filename = blob_filenames_2[current_gbe->type];
				src = rect_make(15*32, 2*32, 32, 32);
				
				
				if (prev_state == GBE_CONNECTED_TO_UP)
				{
					filename = blob_filenames[current_gbe->type];	
					src = rect_make(0*32, 2*32, 32, 32);
					fa = new_animation(2);					
				}

				if (prev_state == GBE_CONNECTED_TO_RIGHT)
				{
					filename = blob_filenames_2[current_gbe->type];
					src = rect_make(0*32, 2*32, 32, 32);
					fa = new_animation(2);
				}
				
//				if (!fa)
//					fa = new_animation(2);
				
				printf("up and right\n");
				goto addshit;
			}
			
			if (current_gbe->connection_state == (GBE_CONNECTED_TO_DOWN | GBE_CONNECTED_TO_LEFT))
			{
				filename = blob_filenames[current_gbe->type];
				src = rect_make(15*32, 11*32, 32, 32);	
				
				
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
				
//				if (!fa)
//					fa = new_animation(11);
				
				printf("left and down\n");
				goto addshit;
			}

			if (current_gbe->connection_state == (GBE_CONNECTED_TO_DOWN | GBE_CONNECTED_TO_RIGHT))
			{
				filename = blob_filenames[current_gbe->type];
				src = rect_make(15*32, 3*32, 32, 32);
				
				
				if (prev_state == GBE_CONNECTED_TO_DOWN)
				{
					filename = blob_filenames[current_gbe->type];
					src = rect_make(0*32, 3*32, 32, 32);
					fa = new_animation(3);
				}
				if (prev_state == GBE_CONNECTED_TO_RIGHT)
				{
					filename = blob_filenames_2[current_gbe->type];
					src = rect_make(0*32, 10*32, 32, 32);
					fa = new_animation(10);
				}
				
//				if (!fa)
//					fa = new_animation(3);

				printf("up and right\n");
				goto addshit;
			}
			
			
			if (current_gbe->connection_state == (GBE_CONNECTED_TO_UP | GBE_CONNECTED_TO_DOWN | GBE_CONNECTED_TO_LEFT ))
			{
				filename = blob_filenames_2[current_gbe->type];
				src = rect_make(15*32, 5*32, 32, 32);

				if (prev_state == (GBE_CONNECTED_TO_UP | GBE_CONNECTED_TO_DOWN))
				{
					filename = blob_filenames[current_gbe->type];
					src = rect_make(0*32, 14*32, 32, 32);
					
					fa = new_animation(14);
				}
				
				if (prev_state == (GBE_CONNECTED_TO_LEFT | GBE_CONNECTED_TO_DOWN))
				{
					filename = blob_filenames_2[current_gbe->type];
					src = rect_make(0*32, 5*32, 32, 32);

					fa = new_animation(5);				
				}
				
				if (prev_state == (GBE_CONNECTED_TO_UP | GBE_CONNECTED_TO_LEFT))
				{
					filename = blob_filenames_2[current_gbe->type];
					src = rect_make(0*32, 14*32, 32, 32);

					fa = new_animation(14);
				}
				
				printf("up, down, left\n");
				goto addshit;
			}
			
			if (current_gbe->connection_state == (GBE_CONNECTED_TO_UP | GBE_CONNECTED_TO_DOWN | GBE_CONNECTED_TO_RIGHT ))
			{
				filename = blob_filenames_2[current_gbe->type];
				src = rect_make(15*32, 6*32, 32, 32);

				if (prev_state == (GBE_CONNECTED_TO_UP | GBE_CONNECTED_TO_DOWN))
				{
					filename = blob_filenames[current_gbe->type];
					src = rect_make(0*32, 6*32, 32, 32);
					
					fa = new_animation(6);
				}
				
				if (prev_state == (GBE_CONNECTED_TO_DOWN | GBE_CONNECTED_TO_RIGHT))
				{
					filename = blob_filenames_2[current_gbe->type];
					src = rect_make(0*32, 6*32, 32, 32);

					fa = new_animation(6);
				}

				if (prev_state == (GBE_CONNECTED_TO_UP | GBE_CONNECTED_TO_RIGHT))
				{
					filename = blob_filenames_2[current_gbe->type];
					src = rect_make(0*32, 13*32, 32, 32);

					fa = new_animation(6);
				}
				
				printf("up, down, right\n");
				goto addshit;
			}

			
			if (current_gbe->connection_state == (GBE_CONNECTED_TO_UP | GBE_CONNECTED_TO_LEFT | GBE_CONNECTED_TO_RIGHT ))
			{
				filename = blob_filenames_2[current_gbe->type];
				src = rect_make(15*32, 3*32, 32, 32);

				if (prev_state == (GBE_CONNECTED_TO_UP | GBE_CONNECTED_TO_LEFT))
				{
					filename = blob_filenames[current_gbe->type];
					src = rect_make(0*32, 4*32, 32, 32);
					
					fa = new_animation(4);
				}
				
				if (prev_state == (GBE_CONNECTED_TO_UP | GBE_CONNECTED_TO_RIGHT))
				{
					filename = blob_filenames[current_gbe->type];
					src = rect_make(0*32, 12*32, 32, 32);

					fa = new_animation(12);
				}
				
				if (prev_state == (GBE_CONNECTED_TO_LEFT | GBE_CONNECTED_TO_RIGHT))
				{
					filename = blob_filenames_2[current_gbe->type];
					src = rect_make(0*32, 3*32, 32, 32);

					fa = new_animation(3);
				}
				
				
				printf("up, left, right\n");
				goto addshit;
			}
			
			if (current_gbe->connection_state == (GBE_CONNECTED_TO_DOWN | GBE_CONNECTED_TO_LEFT | GBE_CONNECTED_TO_RIGHT ))
			{
				filename = blob_filenames_2[current_gbe->type];
				src = rect_make(15*32, 11*32, 32, 32);

				if (prev_state == (GBE_CONNECTED_TO_DOWN | GBE_CONNECTED_TO_LEFT))
				{
					filename = blob_filenames[current_gbe->type];
					src = rect_make(0*32, 5*32, 32, 32);

					fa = new_animation(5);
				}
				
				if (prev_state == (GBE_CONNECTED_TO_DOWN | GBE_CONNECTED_TO_RIGHT))
				{
					filename = blob_filenames[current_gbe->type];
					src = rect_make(0*32, 13*32, 32, 32);

					fa = new_animation(13);
				}
				
				if (prev_state == (GBE_CONNECTED_TO_LEFT | GBE_CONNECTED_TO_RIGHT))
				{
					filename = blob_filenames_2[current_gbe->type];
					src = rect_make(0*32, 11*32, 32, 32);
					
					fa = new_animation(11);
				}
				
				printf("down, left, right\n");
				goto addshit;
			}

			if (current_gbe->connection_state == (GBE_CONNECTED_TO_DOWN | GBE_CONNECTED_TO_LEFT | GBE_CONNECTED_TO_RIGHT | GBE_CONNECTED_TO_UP ))
			{
				filename = blob_filenames_2[current_gbe->type];
				src = rect_make(15*32, 15*32, 32, 32);

				if (prev_state == (GBE_CONNECTED_TO_DOWN | GBE_CONNECTED_TO_LEFT | GBE_CONNECTED_TO_RIGHT))
				{
					filename = blob_filenames_2[current_gbe->type];
					src = rect_make(15*32, 7*32, 32, 32);
					
					fa = new_animation(7);
				}
				
				if (prev_state == (GBE_CONNECTED_TO_UP | GBE_CONNECTED_TO_LEFT | GBE_CONNECTED_TO_RIGHT))
				{
					filename = blob_filenames_2[current_gbe->type];
					src = rect_make(15*32, 15*32, 32, 32);

					fa = new_animation(15);
				}
				
				if (prev_state == (GBE_CONNECTED_TO_UP | GBE_CONNECTED_TO_DOWN | GBE_CONNECTED_TO_RIGHT))
				{
					filename = blob_filenames[current_gbe->type];
					src = rect_make(15*32, 15*32, 32, 32);

					fa = new_animation(15);
				}
				
				if (prev_state == (GBE_CONNECTED_TO_UP | GBE_CONNECTED_TO_DOWN | GBE_CONNECTED_TO_RIGHT))
				{
					filename = blob_filenames[current_gbe->type];
					src = rect_make(15*32, 7*32, 32, 32);

					fa = new_animation(7);
				}
				
				printf("ALL\n");
				goto addshit;
			}

			abort();
			
			
	
		addshit:
			
			current_gbe->prev_connection_state = current_gbe->connection_state;
			
			AtlasSprite *as = _entityManager->addComponent<AtlasSprite>(current_entity);
			as->atlas_quad = g_RenderableManager.accquireTexturedAtlasQuad(filename);
			as->src = src; 
			as->z = 3;
				
			
			if (fa)
			{	
				appendAnimation(current_entity, fa);
				
			}
			else
			{
				_entityManager->removeComponent <FrameAnimation> (current_entity);
			}
			
		}
		
	}
	
}