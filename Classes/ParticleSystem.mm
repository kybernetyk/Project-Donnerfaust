/*
 *  ParticleSystem.mm
 *  Donnerfaust
 *
 *  Created by jrk on 26/11/10.
 *  Copyright 2010 flux forge. All rights reserved.
 *
 */

#include "ParticleSystem.h"
#include "Component.h"
#import "ParticleEmitter.h"


namespace mx3 
{
	
	
	
	ParticleSystem::ParticleSystem (EntityManager *entityManager)
	{
		_entityManager = entityManager;
		skiptimer = 0;
	}
	
	void ParticleSystem::update (float delta)
	{
		++skiptimer;
		
		if (skiptimer == 3)
			return;
		skiptimer = 0;
			
		
		std::vector<Entity*> _entities;
		_entityManager->getEntitiesPossessingComponents (_entities,PEmitter::COMPONENT_ID, Position::COMPONENT_ID, ARGLIST_END);
		
		std::vector<Entity*>::const_iterator it = _entities.begin();
		Entity *current_entity = NULL;
		PEmitter *current_pe = NULL;
		Position *current_position = NULL;
		while (it != _entities.end())
		{
			current_entity = *it;
			++it;
			
			current_pe = _entityManager->getComponent <PEmitter> (current_entity);
			if (current_pe)
			{
				if (current_pe->_renderable_type == RENDERABLETYPE_PARTICLE_EMITTER)
				{	
					
					current_position = _entityManager->getComponent <Position> (current_entity);
					
					current_pe->pe->x = current_position->x;
					current_pe->pe->y = current_position->y;										
					
					current_pe->pe->update(delta);
					
					if ([current_pe->pe->pe particleCount] <= 0)
					{
						_entityManager->addComponent <MarkOfDeath> (current_entity);
					}
					
				}
				
				
			}

		}
		
	}


	Entity *ParticleSystem::createParticleEmitter (std::string filename, float duration, vector2D position)
	{
		EntityManager *em = Entity::entityManager;
		
		Entity *par = em->createNewEntity();
		Position *pos = em->addComponent <Position> (par);
		pos->x = position.x;
		pos->y = position.y;
		PEmitter *pe = em->addComponent <PEmitter> (par);
		pe->pe = g_RenderableManager.accquireParticleEmmiter (filename);
		pe->z = 5.0;

	/*	Vector2f vec;
		vec.x = position.x;
		vec.y = position.y;
		[pe->pe->pe setSourcePosition: vec];*/
		
		if (duration != 0.0)
			[pe->pe->pe setDuration: duration];
		
		return par;
		
	}
	
}