/*
 *  SoundSystem.cpp
 *  ComponentV3
 *
 *  Created by jrk on 12/11/10.
 *  Copyright 2010 flux forge. All rights reserved.
 *
 */

#include "SoundSystem.h"
#import "EntityManager.h"
#import "Component.h"
#import "Entity.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "SimpleAudioEngine.h"
namespace mx3 
{
	
		
	/*SystemSoundID loadSound (const char *fn)
	{
		NSString *filename = [NSString stringWithCString: fn];
		
		// Create the URL for the source audio file. The URLForResource:withExtension: method is
		//    new in iOS 4.0.
		NSURL *soundURL   = [[NSBundle mainBundle] URLForResource: filename
													withExtension: nil];
		
		// Store the URL as a CFURLRef instance
		CFURLRef soundFileURLRef = (CFURLRef) [soundURL retain];
		SystemSoundID sid;
		
		// Create a system sound object representing the sound file.
		AudioServicesCreateSystemSoundID (
										  soundFileURLRef,
										  &sid
										  );		
		
		
		//NSNumber *theID = [NSNumber numberWithInt: sid];
		
		//[soundRefs setObject: theID forKey: filename];
		
		return sid;
		
		//AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);		
		//AudioServicesPlaySystemSound (sid);		
		
	}
	*/

	SoundSystem::SoundSystem (EntityManager *entityManager)
	{
		_entityManager = entityManager;
	//	memset(sounds,0x00,32*sizeof(SystemSoundID));
	//	memset(sound_delays, 0x00, 32 * sizeof(float));
		
		for (int i = 0; i <32; i++)
			sound_delays[i] = 0.0;
		
		music_playing = 0;
		
/*		sounds[SFX_TICK] = "tick.wav";
		sounds[SFX_BLAM] = "bam1.wav";
		sounds[SFX_KAWAII] = "kawaii2.wav";
		sounds[SFX_KAWAII2] = "kawaii.wav";
		sounds[SFX_LEVELUP] = "levelup.wav";
		
		[[SimpleAudioEngine sharedEngine] preloadBackgroundMusic: @"maulwurf.mp4"];*/
		
		for (int i = 0; i < 32; i++)
		{
			NSString *s = [NSString stringWithCString: sounds[i].c_str() 
											 encoding: NSASCIIStringEncoding];
			if (!s || [s length] == 0)
				continue;
			
			NSLog(@"sound preload: %@", s);
			
			[[SimpleAudioEngine sharedEngine] preloadEffect: s];
		}
	}

	void SoundSystem::playMusic (int music_id)
	{
		if (music_playing == music_id)
			return;

		
		[[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
		
		if (music_id == 0)
			return;
			
		NSString *filename = nil;
		
		
		if (music_id == MUSIC_GAME)
			filename = @"music.mp3";
		
		if (!filename)
			return;
		
		[[SimpleAudioEngine sharedEngine] playBackgroundMusic: filename loop: YES];
	}


	void SoundSystem::update (float delta)
	{

		_entities.clear();
		_entityManager->getEntitiesPossessingComponent (_entities,SoundEffect::COMPONENT_ID);
		
		std::vector<Entity*>::const_iterator it = _entities.begin();
		Entity *current_entity = NULL;

		for (int i = 0; i < 32; i++)
			sound_delays[i] -= delta;
		
		SoundEffect *current_sound = NULL;
		
		while (it != _entities.end())
		{
			current_entity = *it;
			++it;
			
			current_sound = _entityManager->getComponent <SoundEffect> (current_entity);
			
			if (current_sound)
			{
				int sid = current_sound->sfx_id;
				if (sid)
				{
					if (sound_delays[sid] <= 0.0)
					{	
						
						[[SimpleAudioEngine sharedEngine] playEffect: [NSString stringWithCString: sounds[sid].c_str() encoding: NSASCIIStringEncoding]];
						
						sound_delays[sid] = 0.05;
					}
				}
			}
			_entityManager->addComponent<MarkOfDeath>(current_entity);
		}
	}

}