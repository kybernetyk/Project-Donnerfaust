/*
 *  globals.h
 *  ComponentV3
 *
 *  Created by jrk on 11/11/10.
 *  Copyright 2010 flux forge. All rights reserved.
 *
 */
#pragma once
#include "TextureManager.h"
#include "RenderableManager.h"


namespace game 
{
	typedef struct GameState
	{
		int score;
		
		int enemies_left;
		
		
		int game_state;
		int next_state;
		
		int level;
		
		int experience;
		int experience_needed_to_levelup;
		
	} GameState;


	#define GAMESTATE_WAITING_FOR_WAVE 0
	#define GAMESTATE_PLAYING_LEVEL 1

	#define BOARD_X_OFFSET 64
	#define BOARD_Y_OFFSET 32
	
	#define BOARD_NUM_COLS 7
	#define BOARD_NUM_ROWS 12


}

extern game::GameState g_GameState;
extern double g_FPS;
	
extern mx3::TextureManager g_TextureManager;
extern mx3::RenderableManager g_RenderableManager;

