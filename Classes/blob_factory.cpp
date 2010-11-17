/*
 *  blob_factory.cpp
 *  Donnerfaust
 *
 *  Created by jrk on 17/11/10.
 *  Copyright 2010 flux forge. All rights reserved.
 *
 */

#include "blob_factory.h"
#include "globals.h"
#include "Entity.h"
#include "EntityManager.h"
#include "Component.h"
#include "GameComponents.h"

using namespace mx3;
using namespace game;


Entity *make_blob (int color, int col,int row)
{
	EntityManager *em = Entity::entityManager;
	
	Entity *e = em->createNewEntity();

	GameBoardElement *gbo = em->addComponent<GameBoardElement>(e);
	gbo->row = row;
	gbo->col = col;
	gbo->type = color;

	Position *pos = em->addComponent<Position>(e);
	pos->x = col * 32.0 + BOARD_X_OFFSET;
	pos->y = row * 32.0 + BOARD_Y_OFFSET;

	FallingState *fs = em->addComponent<FallingState>(e);

	
	AtlasSprite *as = em->addComponent<AtlasSprite>(e);
	as->atlas_quad = g_RenderableManager.accquireTexturedAtlasQuad("red_blob_anims.png");
	as->src = rect_make(13*32, 0, 32, 32);
	as->z = 3;
	/*
	FrameAnimation *fa = em->addComponent<FrameAnimation>(e);
	fa->destroy_on_finish = false;
	fa->loop = false;
	fa->frames_per_second = 24;
	fa->start_frame = 0;
	fa->end_frame = 44;
	fa->frame_size = rect_make(0.0, 0.0, 32.0, 32.0);
	fa->state = ANIMATION_STATE_PLAY;
	*/
	
	
	return e;
}