/*
 *  SoundSystem.h
 *  ComponentV3
 *
 *  Created by jrk on 12/11/10.
 *  Copyright 2010 flux forge. All rights reserved.
 *
 */

#pragma once
#include <vector>
#include "EntityManager.h"
#include "Entity.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

namespace mx3 
{

	#define SFX_EMPTY 0
	#define SFX_TICK 1
	#define SFX_BLAM 2
	#define SFX_KAWAII 3
	#define SFX_KAWAII2 4
	#define SFX_LEVELUP 5

	#define MUSIC_GAME 1

	class SoundSystem
	{
	public:
		SoundSystem (EntityManager *entityManager);
		void update (float delta);	
		
		void playMusic (int music_id);
		
	protected:
		EntityManager *_entityManager;
		
		std::string sounds[32];
		float sound_delays[32];
		
		int music_playing;
		std::vector<Entity*> _entities;
	};

}