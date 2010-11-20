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
#include "ActionSystem.h"

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

	AtlasSprite *as = em->addComponent<AtlasSprite>(e);
	as->atlas_quad = g_RenderableManager.accquireTexturedAtlasQuad("red_blob_anims.png");
	as->src = rect_make(13*32, 0, 32, 32);
	as->z = 3;

	return e;
}
