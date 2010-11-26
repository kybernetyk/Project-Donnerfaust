/*
 *  ParticleSystem.h
 *  Donnerfaust
 *
 *  Created by jrk on 26/11/10.
 *  Copyright 2010 flux forge. All rights reserved.
 *
 */

#pragma once
#include <vector>
#include "EntityManager.h"
#include "Entity.h"
namespace mx3 
{
	class ParticleSystem
	{
	public:
		ParticleSystem (EntityManager *entityManager);
		void update (float delta);	
		
		static Entity *createParticleEmitter (std::string filename, float duration, vector2D posistion);
		
	protected:
		EntityManager *_entityManager;
		int skiptimer;
	};
	
}