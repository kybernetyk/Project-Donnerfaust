/*
 *  HUDSystem.h
 *  ComponentV3
 *
 *  Created by jrk on 12/11/10.
 *  Copyright 2010 flux forge. All rights reserved.
 *
 */

#pragma once
#include <vector>
#include "EntityManager.h"
#include "Timer.h"
using namespace mx3;

namespace game 
{

	class HUDSystem
	{
	public:
		HUDSystem (EntityManager *entityManager);
		void update (float delta);
		
	protected:
		EntityManager *_entityManager;

		Entity *fps_label;
		OGLFont *font;
	};


}