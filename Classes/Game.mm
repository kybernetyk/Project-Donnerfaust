/*
 *  Game.mm
 *  Donnerfaust
 *
 *  Created by jrk on 1/12/10.
 *  Copyright 2010 flux forge. All rights reserved.
 *
 */

#include "Game.h"
#include <sys/time.h>
#include "Entity.h"
#include "EntityManager.h"
#import "FacebookSubmitController.h"
#import "MainViewController.h"
#include "Scene.h"
#include "RenderDevice.h"
#import <QuartzCore/QuartzCore.h>
#include "Timer.h"
#include "globals.h"

using namespace mx3;
using namespace game;

namespace game 
{
	#define FIXED_STEP_LOOP
	
	const int TICKS_PER_SECOND = 60;
	const int SKIP_TICKS = 1000 / TICKS_PER_SECOND;
	const int MAX_FRAMESKIP = 5;
	const double FIXED_DELTA = (1.0/TICKS_PER_SECOND);
	unsigned int next_game_tick = 1;//SDL_GetTicks();
	int loops;
	float interpolation;
	bool paused = false;
	mx3::Timer timer;
		
	
	

	bool Game::init ()
	{
		
		scene = new Scene();
		scene->init();
		
		next_game_tick = mx3::GetTickCount();
		paused = false;
		g_ActiveGFX = GFX_NONE;
		r = 0.0;
		return true;
	}

	void Game::update ()
	{
		
		if (paused)
			return;

		timer.update();
		g_FPS = timer.printFPS(false);
		

#ifdef FIXED_STEP_LOOP
		loops = 0;
		while( mx3::GetTickCount() > next_game_tick && loops < MAX_FRAMESKIP) 
		{
			scene->update(FIXED_DELTA);
			next_game_tick += SKIP_TICKS;
			loops++;	
			r += 32.0 * FIXED_DELTA;
		}
		
#else
		r+=32.0*timer.fdelta();
		scene->update(timer.fdelta());	//blob rotation doesn't work well with high dynamic delta! fix this before enabling dynamic delta
#endif
		
	}

	void Game::render ()
	{
		if (g_ActiveGFX == GFX_NONE)
		{
			RenderDevice::sharedInstance()->setRenderTargetScreen();
			
			RenderDevice::sharedInstance()->beginRender();
			scene->render(1.0);
			scene->frameDone();
			RenderDevice::sharedInstance()->endRender();
			return;
			
		}
		
		
		//gfxe
		RenderDevice::sharedInstance()->setRenderTargetBackingTexture();
		RenderDevice::sharedInstance()->beginRender();
		scene->render(1.0);
		scene->frameDone();
		RenderDevice::sharedInstance()->endRender();
		
		RenderDevice::sharedInstance()->setRenderTargetScreen();
		RenderDevice::sharedInstance()->beginRender();	
		
		//rotozoom
		if (g_ActiveGFX == GFX_ROTOZOOM)
		{
			glLoadIdentity();
			
			int _x = SCREEN_W; 		//= viewport size in meters
			int _y = SCREEN_H;
			
			float xscale = fabs(sin (DEG2RAD (r))) + 0.2;
			//		float yscale = (cos (DEG2RAD (r))) * 2.0;
			
			glTranslatef( (0.5 * _x),  (0.5 * _y), 0);
			glScalef(xscale, xscale, 1.0);
			glRotatef(r, 0, 0, 1.0);
			glTranslatef( -(0.5 * _x),  -(0.5 * _y), 0);
			
			glPushMatrix();
			glTranslatef(-_x, -_y, 0);
			RenderDevice::sharedInstance()->renderBackingTextureToScreen();
			glPopMatrix();
			
			
			glPushMatrix();
			glTranslatef(0, -_y, 0);
			RenderDevice::sharedInstance()->renderBackingTextureToScreen();
			glPopMatrix();
			
			glPushMatrix();
			glTranslatef(_x, -_y, 0);
			RenderDevice::sharedInstance()->renderBackingTextureToScreen();
			glPopMatrix();
			
			glPushMatrix();
			glTranslatef(-_x, 0, 0);
			RenderDevice::sharedInstance()->renderBackingTextureToScreen();
			glPopMatrix();
			
			glPushMatrix();
			glTranslatef(0, 0, 0);
			RenderDevice::sharedInstance()->renderBackingTextureToScreen();
			glPopMatrix();
			
			glPushMatrix();
			glTranslatef(_x, 0, 0);
			RenderDevice::sharedInstance()->renderBackingTextureToScreen();
			glPopMatrix();
			
			glPushMatrix();
			glTranslatef(-_x, _y, 0);
			RenderDevice::sharedInstance()->renderBackingTextureToScreen();
			glPopMatrix();
			
			glPushMatrix();
			glTranslatef(0, _y, 0);
			RenderDevice::sharedInstance()->renderBackingTextureToScreen();
			glPopMatrix();
			
			glPushMatrix();
			glTranslatef(_x, _y, 0);
			RenderDevice::sharedInstance()->renderBackingTextureToScreen();
			glPopMatrix();
		}
		else
		{
			//glLoadIdentity();
			RenderDevice::sharedInstance()->renderBackingTextureToScreen();
		}
		RenderDevice::sharedInstance()->endRender();	
	}
	
	void Game::terminate()
	{
		printf("terminating ...\n");
	}
	
	
	
	void Game::saveGameState ()
	{
		printf("saving state ...\n");
	}
	
	void Game::restoreGameState ()
	{
		printf("restoring state ...\n");
	}


}