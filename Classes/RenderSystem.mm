/*
 *  RenderSystem.cpp
 *  components
 *
 *  Created by jrk on 5/11/10.
 *  Copyright 2010 flux forge. All rights reserved.
 *
 */
#include "SystemConfig.h"
#import "RenderSystem.h"
#import "EntityManager.h"
#import "Component.h"
#import "Entity.h"
namespace mx3 
{
	
		

	RenderSystem::RenderSystem (EntityManager *entityManager)
	{
		_entityManager = entityManager;
	}

	/*
	bool blah (Entity *i,Entity *j)
	{
		Renderable *ren1 = i->getComponentCached<Renderable>();
		Renderable *ren2 = j->getComponentCached<Renderable>();
		
		return (ren1->z < ren2->z);
		
	}*/

	bool blah3 (IRenderable *q1, IRenderable *q2)
	{
		//ok, if both z's are equal the outome of the sort is undefined 
		//and renderables with the same z value might switch render position every re-sort
		//<strike>so we let the memory address decide which renderable to render first (the memory address shouldn't change)</strike>
		//the guid it is
		if (q1->z == q2->z)
			return (q1->_guid < q2->_guid);
		
		return (q1->z < q2->z);
		
	}

	bool blah4 (Entity *e1, Entity *e2)
	{
		//ok, if both z's are equal the outome of the sort is undefined 
		//and renderables with the same z value might switch render position every re-sort
		//<strike>so we let the memory address decide which renderable to render first (the memory address shouldn't change)</strike>
		//the guid it is
		Renderable *ren1 = e1->entityManager->getComponent<Renderable>(e1);
		Renderable *ren2 = e2->entityManager->getComponent<Renderable>(e2);
		
		if (ren1->z == ren2->z)
			return (e1->checksum < e2->checksum);
		
		return (ren1->z < ren2->z);
		
	}

	void RenderSystem::render (void)
	{
		bool isdirty = _entityManager->isDirty();
		if (isdirty)
		{
			gl_data.clear();
			moveableList.clear();
			_entityManager->getEntitiesPossessingComponents (moveableList, Position::COMPONENT_ID, Renderable::COMPONENT_ID, ARGLIST_END);
			std::sort (moveableList.begin(), moveableList.end(), blah4);
		}
		
			
		
		std::vector<Entity*>::const_iterator it = moveableList.begin();
		
		Entity *current_entity = NULL;
		Position *pos = NULL;
		Renderable *ren = NULL;
		//IRenderable *gl_object = NULL;
		
		Sprite *sprite = NULL;
		AtlasSprite *atlas_sprite = NULL;
		BufferedSprite *buffered_sprite = NULL;
		TextLabel *label = NULL;
		
		TexturedQuad *textured_quad = NULL;
		TexturedAtlasQuad *textured_atlas_quad = NULL;
		TexturedBufferQuad *textured_buffer_quad = NULL;
		OGLFont *font = NULL;
		PEmitter *pe = NULL;
		
		
		while (it != moveableList.end())
		{
			current_entity = *it;
			
			pos = _entityManager->getComponent<Position>(current_entity);
			ren = _entityManager->getComponent<Renderable>(current_entity);
			

			if (ren->_renderable_type == RENDERABLETYPE_ATLASSPRITE)
			{
				atlas_sprite = (AtlasSprite*)ren;
				
				textured_atlas_quad = atlas_sprite->atlas_quad;
				textured_atlas_quad->x = pos->x;
				textured_atlas_quad->y = pos->y;
				textured_atlas_quad->z = ren->z;
				textured_atlas_quad->scale_x = pos->scale_x;
				textured_atlas_quad->scale_y = pos->scale_y;
				textured_atlas_quad->rotation = pos->rot;
				textured_atlas_quad->alpha = atlas_sprite->alpha;
				textured_atlas_quad->anchorPoint = atlas_sprite->anchorPoint;
				
	#ifdef __ABORT_GUARDS__			
				if (atlas_sprite->src.w == 0 || atlas_sprite->src.h == 0)
				{
					_entityManager->dumpEntity(current_entity);
					abort();
				}
	#endif		
				textured_atlas_quad->src = atlas_sprite->src;
				
				textured_atlas_quad->renderContent();
				
				++it;
				continue;
			}
			
			
			if (ren->_renderable_type == RENDERABLETYPE_SPRITE)
			{
				sprite = (Sprite*)ren;
				
				textured_quad = sprite->quad;
				textured_quad->x = pos->x;
				textured_quad->y = pos->y;
				textured_quad->z = ren->z;
				textured_quad->scale_x = pos->scale_x;
				textured_quad->scale_y = pos->scale_y;
				textured_quad->rotation = pos->rot;
				textured_quad->alpha = sprite->alpha;
				textured_quad->anchorPoint = sprite->anchorPoint;
				
				textured_quad->renderContent();
				
				++it;
				continue;
			}

			if (ren->_renderable_type == RENDERABLETYPE_BUFFEREDSPRITE)
			{
				buffered_sprite = (BufferedSprite*)ren;
				
				textured_buffer_quad = buffered_sprite->quad;
				textured_buffer_quad->x = pos->x;
				textured_buffer_quad->y = pos->y;
				textured_buffer_quad->z = ren->z;
				textured_buffer_quad->scale_x = pos->scale_x;
				textured_buffer_quad->scale_y = pos->scale_y;
				textured_buffer_quad->rotation = pos->rot;
				textured_buffer_quad->alpha = buffered_sprite->alpha;
				textured_buffer_quad->anchorPoint = buffered_sprite->anchorPoint;
			//	printf("LOL\n");
				textured_buffer_quad->renderContent();
				
				++it;
				continue;
			}
			
			
			if (ren->_renderable_type == RENDERABLETYPE_TEXT)
			{
				label = (TextLabel*)ren;
				font = label->ogl_font;
				font->x = pos->x;
				font->y = pos->y;
				font->z = ren->z;
				font->rotation = pos->rot;
				font->scale_x = pos->scale_x;
				font->scale_y = pos->scale_y;			
				font->text = (char*)label->text.c_str();
				font->alpha = label->alpha;
				font->anchorPoint = label->anchorPoint;
				font->renderContent();
				
				++it;
				continue;
			}
			
			if (ren->_renderable_type == RENDERABLETYPE_PARTICLE_EMITTER)
			{
				pe = (PEmitter*)ren;
/*				pe->pe->x = pos->x;
				pe->pe->y = pos->y;*/ 		///handled by particle system update()
				
				glPushMatrix();
				glTranslatef(0.0, 0.0, pe->pe->z);
				pe->pe->renderContent();
				glPopMatrix();
				
				++it;
				continue;
			}

	#ifdef __ABORT_GUARDS__			
			CV3Log ("unhandled render!\n");
			_entityManager->dumpEntity(current_entity);
			abort();
	#endif
			++it;
		}

	}

}