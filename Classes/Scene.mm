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

bool spawn_one = false;
bool spawn_player = false;

namespace game 
{
	void Scene::init ()
	{
		_isRunning = true;
		srand(time(0));

		g_GameState.game_state = GAMESTATE_WAITING_FOR_WAVE;
		g_GameState.next_state = GAMESTATE_WAITING_FOR_WAVE;
		
		_entityManager = new EntityManager;
		_renderSystem = new RenderSystem (_entityManager);
		_movementSystem = new MovementSystem (_entityManager);
		_attachmentSystem = new AttachmentSystem (_entityManager);
		_actionSystem = new GameActionSystem (_entityManager);
		_corpseRetrievalSystem = new CorpseRetrievalSystem (_entityManager);
		_soundSystem = new SoundSystem (_entityManager);
		_animationSystem = new AnimationSystem (_entityManager);
		_blobAnimationSystem = new BlobAnimationSystem (_entityManager);
		
		_gameLogicSystem = new GameLogicSystem (_entityManager);
		_hudSystem = new HUDSystem (_entityManager);
		_playerControlledSystem = new PlayerControlledSystem (_entityManager);
		_gameBoardSystem = new GameBoardSystem (_entityManager);
		
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
		
		make_blob(BLOB_COLOR_RED, 1, 4);
		make_blob(BLOB_COLOR_RED, 0, 5);
		make_blob(BLOB_COLOR_RED, 3, 11);
		make_blob(BLOB_COLOR_RED, 3, 3);
		make_blob(BLOB_COLOR_RED, 2, 5);
		make_blob(BLOB_COLOR_RED, 4, 4);
		make_blob(BLOB_COLOR_RED, 5, 5);
		make_blob(BLOB_COLOR_RED, 2, 11);
		make_blob(BLOB_COLOR_RED, 1, 3);
		make_blob(BLOB_COLOR_RED, 6, 5);
		

		make_blob(BLOB_COLOR_RED, 4, 6);
		make_blob(BLOB_COLOR_RED, 3, 3);		
		make_blob(BLOB_COLOR_RED, 4, 3);
	}

	void Scene::end ()
	{

	}

	void Scene::update (float delta)
	{
		InputDevice::sharedInstance()->update();

		//we must collect the corpses from the last frame
		//as the entity-manager's isDirty property is reset each frame
		//so if we did corpse collection at the end of update
		//the systems wouldn't know that the manager is dirty 
		//and a shitstorm of dangling references would rain down on them
		_corpseRetrievalSystem->collectCorpses();
		
		
		
		_playerControlledSystem->update(delta);
		_actionSystem->update(delta);
		_movementSystem->update(delta);
		_attachmentSystem->update(delta);
		_animationSystem->update(delta);
		_gameBoardSystem->update(delta);
		_gameLogicSystem->update(delta);
		_blobAnimationSystem->update(delta);
		
		
		_hudSystem->update(delta);
		_soundSystem->update(delta);
		

		if (spawn_one)
		{
			spawn_one = false;
			make_blob(BLOB_COLOR_RED, rand()%7, 11);
			
		}
		
		if (spawn_player)
		{
			spawn_player = false;
			
			printf("spawning player ...\n");
			
			make_player_blob(CENTER, BLOB_COLOR_RED, 3,11);
			make_player_blob(AUX, BLOB_COLOR_RED, 4,11);
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