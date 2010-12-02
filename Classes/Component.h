/*
 *  Component.h
 *  components
 *
 *  Created by jrk on 3/11/10.
 *  Copyright 2010 flux forge. All rights reserved.
 *
 */
#pragma once
#include "SystemConfig.h"
#include <math.h>
#import "types.h"
#include <string>
#include "TexturedQuad.h"
#include "TextureManager.h"
#include "RenderableManager.h"
#include <vector>
#import "ParticleEmitter.h"
#include "Actions.h"
	
#ifdef __RUNTIME_INFORMATION__
	#define DEBUGINFO(format,...) virtual std::string toString () \
	{\
		char s[512]; \
		sprintf(s, format, ##__VA_ARGS__); \
		return std::string (s);	\
	}
#else
	#define DEBUGINFO(format,...)
#endif

namespace mx3 
{
	struct Component
	{
		ComponentID _id;
		Component ()
		{
			_id = 0;
		}
		
		virtual ~Component ()
		{
			
		}
		DEBUGINFO("Component")
		
	};
	#pragma mark -
	#pragma mark managment

	struct MarkOfDeath : public Component 
	{
		static ComponentID COMPONENT_ID;
		
		MarkOfDeath()
		{
			_id = COMPONENT_ID;
		}

		DEBUGINFO("Mark Of Death")
	};

	struct Name : public Component 
	{
		static ComponentID COMPONENT_ID;
		std::string name;
		
		Name()
		{
			name = "no name given";
			_id = COMPONENT_ID;
		}
		
		DEBUGINFO ("Name: %s",name.c_str())
	};


	#pragma mark -
	#pragma mark position
	struct Position : public Component 
	{
		static ComponentID COMPONENT_ID;
		float x,y;
		float rot;
		float scale_x;
		float scale_y;
		Position()
		{
			x = y = 0.0;
			rot = 0.0;
			scale_x = scale_y = 1.0;
			_id = COMPONENT_ID;
		}
		
		DEBUGINFO ("Position: x=%f, y=%f, rot=%f, scale_x=%f, scale_y=%f",x,y,rot,scale_x,scale_y)
	};

	struct Movement : public Component
	{
		static ComponentID COMPONENT_ID;
		
		float vx;
		float vy;

		Movement()
		{
			_id = COMPONENT_ID;

			vx = 0.0;
			vy = 0.0;
		}
		
		DEBUGINFO ("Movement: vx=%f, vy=%f",vx,vy)
	};

	struct Attachment : public Component
	{
		static ComponentID COMPONENT_ID;
		EntityGUID targetEntityID;
		unsigned int entityChecksum;
		
		float offset_x;
		float offset_y;
		
		Attachment ()
		{
			_id = COMPONENT_ID;
			
			offset_x = offset_y = 0.0;
			entityChecksum = 0;
			targetEntityID = 0;
		}
		
		DEBUGINFO ("Attachment attached to: %i, attached entity checksum: %i",targetEntityID, entityChecksum)
	};

	#pragma mark -
	#pragma mark animation
	#define ANIMATION_STATE_PAUSE 0
	#define ANIMATION_STATE_PLAY 1
	struct FrameAnimation : public Component
	{
		static ComponentID COMPONENT_ID;

		rect frame_size;

		float current_frame;
		float frames_per_second;
		float speed_scale;
		int state;
		int start_frame;
		int end_frame;
		bool loop;
		bool destroy_on_finish;
		
		FrameAnimation *next_animation;
		Action *on_complete_action;
		
		FrameAnimation ()
		{
			_id = COMPONENT_ID;
			current_frame = 0.0;
			speed_scale = 1.0;
			frames_per_second = 0.0;
			loop = false;
			destroy_on_finish = true;
			frame_size = rect_make(0.0, 0.0, 0.0, 0.0);
			state = ANIMATION_STATE_PAUSE;
			start_frame = 0;
			end_frame = 0;
			next_animation = NULL;
			on_complete_action = NULL;
		}

		
		DEBUGINFO ("Frame Animation: frame: %f, start_fram: %i, end_frame: %i, speed: %f, fps: %f, loop: %i", current_frame, start_frame, end_frame, speed_scale, frames_per_second, loop)
		
		
	};

	#pragma mark -
	#pragma mark sound
	struct SoundEffect : public Component
	{
		static ComponentID COMPONENT_ID;
		
		
		int sfx_id;
		
		SoundEffect ()
		{
			_id = COMPONENT_ID;
			sfx_id = 0;
		}
		
		DEBUGINFO ("Sound effect id: %i", sfx_id)
		
	};


	#pragma mark -
	#pragma mark Renderable

	#define RENDERABLETYPE_BASE 0
	#define RENDERABLETYPE_SPRITE 1
	#define RENDERABLETYPE_ATLASSPRITE 2
	#define RENDERABLETYPE_TEXT 3
	#define RENDERABLETYPE_BUFFEREDSPRITE 4
	#define RENDERABLETYPE_PARTICLE_EMITTER 5

	struct Renderable : public Component
	{
		static ComponentID COMPONENT_ID;
		vector2D anchorPoint;
		unsigned int _renderable_type;
		float alpha;
		float z;
		Renderable()
		{
			_id = COMPONENT_ID;
			_renderable_type = RENDERABLETYPE_BASE;
			anchorPoint = vector2D_make( 0.5, 0.5);
			z = 0.0;
			alpha = 1.0;
		}
		virtual ~Renderable()
		{
			
		}
		//WARNING: Don't forget to set the entity manager to dirty when you change the z value of an existing component! (Which shouldn't happen too often anyways)

		DEBUGINFO ("Renderable Base: z=%f alpha: a=%f", z,alpha)
	};

	struct Sprite : public Renderable
	{
		static ComponentID COMPONENT_ID;
		
		TexturedQuad *quad;
		
		Sprite()
		{
			_id = COMPONENT_ID;
			_renderable_type = RENDERABLETYPE_SPRITE;
			
			quad = NULL;
		}
		~Sprite()
		{
			g_RenderableManager.release(quad);
		}
		//WARNING: Don't forget to set the entity manager to dirty when you change the z value of an existing component! (Which shouldn't happen too often anyways)
		
		DEBUGINFO ("Renderable: quad=%p, z=%f", quad,z)
	};

	struct PEmitter : public Renderable
	{
		static ComponentID COMPONENT_ID;
		
		PE_Proxy *pe;
		
		PEmitter()
		{
			_id = COMPONENT_ID;
			_renderable_type = RENDERABLETYPE_PARTICLE_EMITTER;
			
			pe = nil;
		}
		~PEmitter()
		{
			
//			g_RenderableManager.release(quad);		//hmm - each PE is unique because it has a unique state :[ what to do?
			delete pe;
		}
		//WARNING: Don't forget to set the entity manager to dirty when you change the z value of an existing component! (Which shouldn't happen too often anyways)
		
		DEBUGINFO ("PEmitter: pe=%p, z=%f", pe,z)
	};
	

	struct BufferedSprite : public Renderable
	{
		static ComponentID COMPONENT_ID;
		
		TexturedBufferQuad *quad;
		
		BufferedSprite()
		{
			_id = COMPONENT_ID;
			_renderable_type = RENDERABLETYPE_BUFFEREDSPRITE;
			
			quad = NULL;
		}
		~BufferedSprite()
		{
			g_RenderableManager.release(quad);
		}
		//WARNING: Don't forget to set the entity manager to dirty when you change the z value of an existing component! (Which shouldn't happen too often anyways)
		
		DEBUGINFO ("BufferedSprite: quad=%p, z=%f", quad,z)
	};
	
	
	struct AtlasSprite : public Renderable
	{
		static ComponentID COMPONENT_ID;
		
		TexturedAtlasQuad *atlas_quad;
		
		rect src; 
		
		AtlasSprite()
		{
			_id = COMPONENT_ID;
			_renderable_type = RENDERABLETYPE_ATLASSPRITE;
			src.x = src.y = src.w = src.h = 0;
			
			atlas_quad = NULL;
		}
		~AtlasSprite()
		{
			g_RenderableManager.release(atlas_quad);
		}
		
		//WARNING: Don't forget to set the entity manager to dirty when you change the z value of an existing component! (Which shouldn't happen too often anyways)
		
		DEBUGINFO ("Atlas Sprite: atlas_quad=%p, z=%f", atlas_quad,z)
	};

	struct TextLabel : public Renderable
	{
		static ComponentID COMPONENT_ID;
		
		std::string text;
		
		OGLFont *ogl_font;
		
		TextLabel()
		{
			_id = COMPONENT_ID;
			_renderable_type = RENDERABLETYPE_TEXT;
			
			text = "fill me!";
			
			ogl_font = NULL;
		}
		
		~TextLabel()
		{
			g_RenderableManager.release(ogl_font);
		}
		
		//WARNING: Don't forget to set the entity manager to dirty when you change the z value of an existing component! (Which shouldn't happen too often anyways)
		
		DEBUGINFO ("Renderable: %s, z=%f", text.c_str(),z)
	};

	
	
	
	#pragma mark -
	#pragma mark aktschn
	
#define NUM_OF_ACTIONS_PER_CONTAINER 256
	
	struct ActionContainer : public Component
	{
		static ComponentID COMPONENT_ID;	//component id for the component's manager internal use
		
		Action *actions[NUM_OF_ACTIONS_PER_CONTAINER];
		
		ActionContainer()
		{	
			_id = COMPONENT_ID;
			memset(actions,0x00,NUM_OF_ACTIONS_PER_CONTAINER*sizeof(Action*));
		}
		
		~ActionContainer()
		{
			
			for (int i = 0; i < NUM_OF_ACTIONS_PER_CONTAINER; i++)
			{
				if (actions[i])
				{	
					Action *a = actions[i];
					
					delete a;
					
				}
			}
		}
	};
	
	
}

