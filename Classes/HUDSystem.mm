/*
 *  HUDSystem.cpp
 *  ComponentV3
 *
 *  Created by jrk on 12/11/10.
 *  Copyright 2010 flux forge. All rights reserved.
 *
 */

#include "HUDSystem.h"
#include "Texture2D.h"
#include "SoundSystem.h"
#include "Timer.h"
#include "globals.h"
#include "GameActionSystem.h"

namespace game 
{

	HUDSystem::HUDSystem (EntityManager *entityManager)
	{
		_entityManager = entityManager;

		font = g_RenderableManager.accquireOGLFont("zomg.fnt");
		
		//fps label
		fps_label = _entityManager->createNewEntity();
		_entityManager->addComponent<Name>(fps_label)->name = "fps_label";
		_entityManager->addComponent<Position> (fps_label);
		fps_label->get<Position>()->x = 0.0;
		fps_label->get<Position>()->y = 480.0;
		fps_label->get<Position>()->scale_x = 		fps_label->get<Position>()->scale_y =  0.5;
		TextLabel *label = _entityManager->addComponent<TextLabel> (fps_label);
		label->ogl_font = font;
		label->anchorPoint = vector2D_make(0.0, 1.0);
		label->text = "FPS: 0";
		label->z = 6.0;
		
	}

	Action *flyin_and_shake_action ()
	{
		MoveToAction *actn = new MoveToAction;
		actn->duration = 0.3;
		actn->x = 480/2-10;
		actn->y = 320/2+20;
		
		Action *prev_actn = actn;
		int max = 10;
		for (int i = 0; i < max; i++)
		{
			MoveByAction *mb = new MoveByAction;
			mb->duration = 0.05;
			
			if (i % 2 == 0)
				mb->x = (max-i)*2;
			else
				mb->x = -(max-i)*2;
			
			prev_actn->on_complete_action = mb;
			prev_actn = mb;
		}
		

		return actn;
	}

	Action *flyout_and_reset_action ()
	{
		MoveToAction *actn = new MoveToAction;
		actn->duration = 0.3;
		actn->x = -400;
		actn->y = 320/2+20;
		/*
		MoveByAction *mb = new MoveByAction;
		mb->x = 0.0;
		mb->y = 400;
		mb->duration = 0.0;
		actn->next_action = mb;
		
		MoveByAction *mb2 = new MoveByAction;
		mb2->x = 400+480+200;
		mb2->y = 0;
		mb2->duration = 0.0;
		mb->next_action = mb2;
		*/
		
		MoveToAction *mb3 = new MoveToAction;
		mb3->x = 480+200;
		mb3->y = 320/2+20;
		mb3->duration = 0.0;
		//mb2->next_action = mb3;
		actn->on_complete_action = mb3;

		return actn;
	}


	void HUDSystem::update (float delta)
	{

		static float d = 0.0;
		d += delta;
		if (d > 2.0)
		{
			d = 0.0;
			char s[255];
			sprintf(s, "Fps: %.2f", g_FPS);
			fps_label->get<TextLabel>()->text = s;
			
			//printf("fps: %.2f\n",g_FPS);
		}
		
		
	}

}