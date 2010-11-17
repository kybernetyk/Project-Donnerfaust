/*
 *  CorpseRetrievalSystem.h
 *  ComponentV3
 *
 *  Created by jrk on 10/11/10.
 *  Copyright 2010 flux forge. All rights reserved.
 *
 */

/*
 this system is responsible for killing and removing entities which
 have the MarkOfDeath component
 */

#pragma once
#include <vector>
#include "EntityManager.h"

namespace mx3 
{
	
	
	class CorpseRetrievalSystem
	{
	public:
		CorpseRetrievalSystem (EntityManager *entityManager);
		void collectCorpses ();
	protected:
		EntityManager *_entityManager;
	};

}