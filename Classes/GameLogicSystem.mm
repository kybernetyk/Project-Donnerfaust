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
		mta->next_action = blam_sound_action;
		
		
		//3. remove the enemy entity
		AddComponentAction *aca = new AddComponentAction();
		aca->component_to_add = new MarkOfDeath();
		blam_sound_action->next_action = aca;
		

		
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
			_mt->next_action = modaction;
			
			_entityManager->addComponent(gold_sign, _mt);
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
		
		restoreGameStateFromFile();
	}

	void GameLogicSystem::restoreGameStateFromFile ()
	{
		[[[UIApplication sharedApplication] delegate] loadGameState];
	}

	void GameLogicSystem::saveGameStateToFile ()
	{
		[[[UIApplication sharedApplication] delegate] saveGameState];
	}

	void GameLogicSystem::shareLevelOnFarmville ()
	{
		[[[UIApplication sharedApplication] delegate] shareLevelOnFarmville];
	}

	void GameLogicSystem::check_player_for_levelup ()
	{
		if (g_GameState.experience > g_GameState.experience_needed_to_levelup)
		{
			g_GameState.level ++;
			g_GameState.experience -= g_GameState.experience_needed_to_levelup;
			g_GameState.experience_needed_to_levelup = g_GameState.level*g_GameState.level*g_GameState.level+100;
			
			saveGameStateToFile();
			
			shareLevelOnFarmville();
		}
	}

	void GameLogicSystem::handle_player_enemy_collision ()
	{
		Entity *player = NULL;
		Position *player_pos = NULL;
		
		std::vector<Entity*>::const_iterator it = _players.begin();
		
		
		//lol how many players can we have? :D
		while (it != _players.end())
		{
			player = *it;
			player_pos = _entityManager->getComponent <Position> (player);
			
			++it;
		}
		
		if (!player)
			return;
		//now rape enemies
		it = _enemies.begin();
		
		Entity *enemy;
		Position *enemy_pos;
		
		float horn_x = player_pos->x + 190 * player_pos->scale_x;
		float horn_y = player_pos->y + 190 * player_pos->scale_y;
		
		Enemy *enemy_information = NULL;
		while (it != _enemies.end())
		{
			enemy = *it;
			//_entityManager->dumpEntity(enemy);
			enemy_pos = _entityManager->getComponent <Position> (enemy);
			enemy_information = _entityManager->getComponent <Enemy>(enemy);
			++it;
			
			if (!enemy_pos)
				_entityManager->dumpEntity(enemy);	
			
			//check if the horn is in the enemy
			if (horn_x+2 > enemy_pos->x-16 && horn_x-2 < enemy_pos->x+16 &&
				horn_y+2 > enemy_pos->y-16 && horn_y-2 < enemy_pos->y+16 &&
				!enemy_information->has_been_handled)
			{
				enemy_information->has_been_handled = true;
				
				//play now the tick sound			
				Entity *sound = _entityManager->createNewEntity();
				_entityManager->addComponent <SoundEffect> (sound);
				sound->get<SoundEffect>()->sfx_id = SFX_TICK;
				g_GameState.score += (10 + rand()%15);
				g_GameState.experience += (g_GameState.level*1.3);
			//	g_GameState.enemies_left --;
				Action *actn = enemy_death_action_chain(enemy_pos,enemy_information);
				
				//add the action chain
				_entityManager->addComponent(enemy, actn);

			}
		}
	}


	void GameLogicSystem::update (float delta)
	{
		_enemies.clear();
		_players.clear();
		
		_entityManager->getEntitiesPossessingComponents(_players,  PlayerController::COMPONENT_ID,Position::COMPONENT_ID, ARGLIST_END );
		_entityManager->getEntitiesPossessingComponents(_enemies,  Enemy::COMPONENT_ID,Position::COMPONENT_ID, ARGLIST_END );
		_delta = delta;
		
		
		g_GameState.enemies_left = _enemies.size();
		
		if (g_GameState.enemies_left <= 0)
		{
			if (g_GameState.game_state == GAMESTATE_PLAYING_LEVEL &&
				g_GameState.next_state == GAMESTATE_PLAYING_LEVEL)
			{
				g_GameState.next_state = GAMESTATE_WAITING_FOR_WAVE;
			}
		}
		
		
		if (_players.size() == 0 || _enemies.size() == 0)
			return;
		
		
		handle_player_enemy_collision();
		check_player_for_levelup();
		
	}

}