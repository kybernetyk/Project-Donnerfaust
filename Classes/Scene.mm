/*
 *  Game.cpp
 *  SpaceHike
 *
 *  Created by jrk on 6/11/10.
 *  Copyright 2010 flux forge. All rights reserved.
 *
 */

#include "Scene.h"
#include "InputDevice.h"
#include "Entity.h"

#include "EntityManager.h"
#include "Component.h"

#include "RenderSystem.h"
#include "MovementSystem.h"
#include "HUDSystem.h"
#include "globals.h"

#include "blob_factory.h"
#include "RenderDevice.h"

#import "ParticleEmitter.h"


bool spawn_one = false;
bool spawn_player = false;

extern int g_ActiveGFX;

namespace game 
{
	void Scene::preload ()
	{
		preload_blob_textures ();	
	}
	
	void Scene::init ()
	{
		srand(time(0));

		g_GameState.game_state = GAMESTATE_WAITING_FOR_WAVE;
		g_GameState.next_state = GAMESTATE_WAITING_FOR_WAVE;
		
		_entityManager = new EntityManager;
		_renderSystem = new RenderSystem (_entityManager);
		_movementSystem = new MovementSystem (_entityManager);
		_attachmentSystem = new AttachmentSystem (_entityManager);
		_actionSystem = new GameActionSystem (_entityManager);
		_particleSystem = new ParticleSystem (_entityManager);
		_corpseRetrievalSystem = new CorpseRetrievalSystem (_entityManager);
		_soundSystem = new SoundSystem (_entityManager);
		_animationSystem = new AnimationSystem (_entityManager);

		_blobConnectionSystem = new BlobConnectionSystem (_entityManager);
		_blobAnimationSystem = new BlobAnimationSystem (_entityManager);
		
		_gameLogicSystem = new GameLogicSystem (_entityManager);
		_hudSystem = new HUDSystem (_entityManager);
		_playerControlledSystem = new PlayerControlledSystem (_entityManager);
		_gameBoardSystem = new GameBoardSystem (_entityManager);
		
		
		
		
		
		preload();
		
		
		_soundSystem->playMusic(MUSIC_GAME);

		/* create background */	
		Entity *bg = _entityManager->createNewEntity();
		Position *pos = _entityManager->addComponent <Position> (bg);
		Sprite *sprite = _entityManager->addComponent <Sprite> (bg);
		sprite->quad = g_RenderableManager.accquireTexturedQuad ("game_board.png");
		sprite->anchorPoint = vector2D_make(0.0, 0.0);
		sprite->z = -5.0;
		Name *name = _entityManager->addComponent <Name> (bg);
		name->name = "Game Background";
		
		for (int i = 0; i < 16; i++)
		{
			int col = rand()%MAX_BLOB_TYPES;
			int x = rand()%6;
			int y = rand()%11;
			
			make_blob (col, x, y);
		}
		
//		make_blob (BLOB_COLOR_BLUE, 5, 2);
		
		
	/*	Entity *sky = _entityManager->createNewEntity();
		pos = _entityManager->addComponent <Position> (sky);
		Sprite *_spr = _entityManager->addComponent<Sprite>(sky);
		_spr->quad = g_RenderableManager.accquireTexturedQuad("sky_backdrop.png");
		_spr->anchorPoint = vector2D_make(0.0, 0.0);
		_spr->z = 6.9;
		
		
		Entity *test = _entityManager->createNewEntity();
		pos = _entityManager->addComponent <Position> (test);
		BufferedSprite *spr = _entityManager->addComponent<BufferedSprite>(test);
		spr->quad = g_RenderableManager.accquireBufferedTexturedQuad("land.png");
		tq = spr->quad;
		spr->anchorPoint = vector2D_make(0.0, 0.0);
		spr->z = 7.0;
		tq->apply_alpha_mask();		*/



		
		
		
	}

	void Scene::end ()
	{

	}

	
	void Scene::update (float delta)
	{

		//tex->updateTextureWithBufferData();
		InputDevice::sharedInstance()->update();

/*		if (InputDevice::sharedInstance()->touchUpReceived())
		{
			unsigned char *buf = tq->alpha_mask;
			
			
			int xc = InputDevice::sharedInstance()->touchLocation().x;
			int yc = InputDevice::sharedInstance()->touchLocation().y;
			
			yc = SCREEN_H - yc;
						
			tq->alpha_draw_circle_fill( xc, yc, 24, 0x00);
			
			
			tq->apply_alpha_mask();
		}
*/
		
		//we must collect the corpses from the last frame
		//as the entity-manager's isDirty property is reset each frame
		//so if we did corpse collection at the end of update
		//the systems wouldn't know that the manager is dirty 
		//and a shitstorm of dangling references would rain down on them
		_corpseRetrievalSystem->collectCorpses();
		
		
		//wegen block removal und marking mit MOD
		//im normalspiel wohl wayne
		//kann also runterbewegt werden		
		_gameLogicSystem->update(delta);

		
		
		_playerControlledSystem->update(delta);
		_actionSystem->update(delta);
		_movementSystem->update(delta);
		_attachmentSystem->update(delta);
		_gameBoardSystem->update(delta);
		_blobConnectionSystem->update(delta);
		_blobAnimationSystem->update(delta);
		




		_hudSystem->update(delta);
		_soundSystem->update(delta);
		
		_particleSystem->update(delta);
		


		_animationSystem->update(delta);		
		if (spawn_one)
		{
			spawn_one = false;
			Entity *blob = make_blob(rand()%MAX_BLOB_TYPES, rand()%7, 11);
			
			Entity *pe = ParticleSystem::createParticleEmitter ("lolsterne.pex", 1.0, vector2D_make(320/2, 480/2));
			
			Attachment *a = _entityManager->addComponent <Attachment> (pe);
			a->targetEntityID = blob->_guid;
			a->entityChecksum = blob->checksum;
			
			
			
		//	RenderDevice::sharedInstance()->setupViewportAndProjection ( 320, 480,320, 520);
		}
		
		if (spawn_player)
		{
			if (g_ActiveGFX)
				g_ActiveGFX = GFX_NONE;
			else
				g_ActiveGFX = GFX_ROTOZOOM;
			
			spawn_player = false;
			
			CV3Log ("spawning player ...\n");
			
			make_player_blob(CENTER, BLOB_COLOR_RED, 3,11);
			Entity *blob = make_player_blob(AUX, BLOB_COLOR_RED, 4,11);
			
			
		}
		
	/*	if (g_GameState.game_state != g_GameState.next_state)
		{
			g_GameState.game_state = g_GameState.next_state;
			
			if (g_GameState.game_state == GAMESTATE_PLAYING_LEVEL)
			{
				spawnEnemies();
			}
			
		}*/

		
	
		
	}

	void Scene::render (float interpolation)
	{
		_renderSystem->render();

	}

	void Scene::frameDone ()
	{
		_entityManager->setIsDirty (false);
	}

}