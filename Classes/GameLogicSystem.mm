/*
 *  GameLogicSystem.cpp
 *  ComponentV3
 *
 *  Created by jrk on 10/11/10.
 *  Copyright 2010 flux forge. All rights reserved.
 *
 */

#include "GameLogicSystem.h"
#include "Texture2D.h"
#include "SoundSystem.h"
#include "globals.h"
#include "ActionSystem.h"
namespace game 
{


	Action *GameLogicSystem::enemy_death_action_chain (Position *enemy_pos, Enemy *enemy_information)
	{
		//action chain
		
		//1. move to origin point
		MoveToAction *mta = new MoveToAction();
		mta->x = enemy_information->origin_x;
		mta->y = enemy_information->origin_y;
		mta->duration = 0.5;
		
		//2. play BLAM sound on origin point
		SoundEffect *sfx = new SoundEffect;
		sfx->sfx_id = SFX_BLAM;
		
		CreateEntityAction *blam_sound_action = new CreateEntityAction();
		blam_sound_action->components_to_add.push_back(sfx);
		mta->on_complete_action = blam_sound_action;
		
		
		//3. remove the enemy entity
		AddComponentAction *aca = new AddComponentAction();
		aca->component_to_add = new MarkOfDeath();
		blam_sound_action->on_complete_action = aca;
		

		
		//GOLD SIGN
		Entity *gold_sign = _entityManager->createNewEntity();
		
		Position *pos = new Position();
		pos->x = enemy_pos->x;
		pos->y = enemy_pos->y;
		_entityManager->addComponent(gold_sign, pos);

		AtlasSprite *sprite = _entityManager->addComponent<AtlasSprite>(gold_sign);
		sprite->atlas_quad = g_RenderableManager.accquireTexturedAtlasQuad ("blobs4.png");
		//sprite->sprite->w = 16.0;
	//	sprite->sprite->h = 16.0;
		
	//	rect src = {0.0,96.0,16.0,16.0};
		sprite->src = rect_make(0.0, 96.0, 16.0, 16.0);
		sprite->z = 9.0;
		
		
		/*TextLabel *label = new TextLabel();
		label->text = "+17G";
		label->ogl_font = _smallFont;
		label->z = 9.0;
		_entityManager->addComponent(gold_sign, label);*/
		
		{
			MoveToAction *_mt = new MoveToAction();
			_mt->x = 16.0;
			_mt->y = 16.0;
			_mt->duration = 0.3;
			
			AddComponentAction *modaction = new AddComponentAction();
			modaction->component_to_add = new MarkOfDeath();
			_mt->on_complete_action = modaction;
			
		//	_entityManager->addComponent(gold_sign, _mt);
			g_pActionSystem->addActionToEntity (gold_sign, _mt);
		}
		
		
		//2. spawn +gold 
		/*CreateEntityAction *gold_sign = new CreateEntityAction();
		
		Position *pos = new Position();
		pos->x = enemy_pos->x;
		pos->y = enemy_pos->y;
		gold_sign->components_to_add.push_back(pos);
		
		TextLabel *label = new TextLabel();
		label->text = "+17G";
		label->ogl_font = _smallFont;
		label->z = 9.0;
		gold_sign->components_to_add.push_back(label);
		
		{
			MoveByAction *_mb = new MoveByAction();
			_mb->y = 50;
			_mb->duration = 0.3;
			
			AddComponentAction *modaction = new AddComponentAction();
			modaction->component_to_add = new MarkOfDeath();
			_mb->next_action = modaction;
			
			gold_sign->components_to_add.push_back(_mb);
		}*/
		
		
											   
								
		return mta;
	}

	GameLogicSystem::GameLogicSystem (EntityManager *entityManager)
	{
		_entityManager = entityManager;
	}



	void GameLogicSystem::update (float delta)
	{
		_enemies.clear();
		_players.clear();
		
		_entityManager->getEntitiesPossessingComponents(_players,  PlayerController::COMPONENT_ID,Position::COMPONENT_ID, ARGLIST_END );
		_entityManager->getEntitiesPossessingComponents(_enemies,  Enemy::COMPONENT_ID,Position::COMPONENT_ID, ARGLIST_END );
		_delta = delta;
		
	}

}