/*
 *  Game.h
 *  SpaceHike
 *
 *  Created by jrk on 6/11/10.
 *  Copyright 2010 flux forge. All rights reserved.
 *
 */
#pragma once
#include "Scene.h"
#include "Texture2D.h"
#include "TexturedQuad.h"
#include "EntityManager.h"
#include "RenderSystem.h"
#include "MovementSystem.h"
#include "ParticleSystem.h"
#include "PlayerControlledSystem.h"
#include "AttachmentSystem.h"
#include "ActionSystem.h"
#include "GameLogicSystem.h"
#include "CorpseRetrievalSystem.h"
#include "HUDSystem.h"
#include "SoundSystem.h"
#include "AnimationSystem.h"
#include "GameBoardSystem.h"
#include "BlobAnimationSystem.h"
#include "GameActionSystem.h"
#include "BlobConnectionSystem.h"

#include "Scene.h"

using namespace mx3;

namespace game 
{

	class GameScene : public mx3::Scene
	{
	public:
		virtual void preload ();
		virtual void init ();
		virtual void end ();
		
		virtual void update (float delta);
		virtual void render ();
		
		virtual void frameDone ();
		
		~GameScene ();
		
	protected:
		EntityManager *_entityManager;
		RenderSystem *_renderSystem;
		MovementSystem *_movementSystem;
		AttachmentSystem *_attachmentSystem;
		GameActionSystem *_actionSystem;
		CorpseRetrievalSystem *_corpseRetrievalSystem;	
		SoundSystem *_soundSystem;
		AnimationSystem *_animationSystem;
		ParticleSystem *_particleSystem;

		HUDSystem *_hudSystem;
		PlayerControlledSystem *_playerControlledSystem;
		GameLogicSystem *_gameLogicSystem;
		GameBoardSystem *_gameBoardSystem;
		BlobConnectionSystem *_blobConnectionSystem;
		BlobAnimationSystem *_blobAnimationSystem;

	};

}