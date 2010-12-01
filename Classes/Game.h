/*
 *  Game.h
 *  Donnerfaust
 *
 *  Created by jrk on 1/12/10.
 *  Copyright 2010 flux forge. All rights reserved.
 *
 */

#pragma once
#include "ComponentV3.h"
#include "Timer.h"
#include "Scene.h"

namespace game 
{

	class Game
	{
	public:
		bool init ();
		void terminate ();

		void update ();
		void render (); 
		
		void saveGameState ();
		void restoreGameState ();
	protected:
		game::Scene *scene;
		
		float r;
	};

	extern bool paused;
	extern mx3::Timer timer;
	extern unsigned int next_game_tick;
}