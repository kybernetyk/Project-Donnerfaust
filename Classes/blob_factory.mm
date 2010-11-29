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

std::string blob_filenames[] = 
{
	"red_lr.png",
	"green_lr.png",
	"blue_lr.png",
	"yellow_lr.png"
};

std::string blob_filenames_2[] = 
{
	"red_ud.png",
	"green_ud.png",
	"blue_ud.png",
	"yellow_ud.png"
};


void preload_blob_textures ()
{
	for (int i = 0; i < 4; i++)
	{	
		g_RenderableManager.accquireTexturedAtlasQuad(blob_filenames[i]);
		g_RenderableManager.accquireTexturedAtlasQuad(blob_filenames_2[i]);
	}
	
}

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

	std::string filename = blob_filenames[color];
	
	AtlasSprite *as = em->addComponent<AtlasSprite>(e);
	as->atlas_quad = g_RenderableManager.accquireTexturedAtlasQuad(filename);
	as->src = rect_make(0*32, 0, 32, 32);
	as->z = 3;

	return e;
}


Entity *make_player_blob (int center_or_aux, int type, int col,int row)
{
	EntityManager *em = Entity::entityManager;

	Entity *plr = em->createNewEntity();
	
	Position *pos = em->addComponent <Position> (plr);
	pos->x = col * 32.0 + BOARD_X_OFFSET;
	pos->y = row * 32.0 + BOARD_Y_OFFSET;

	PlayerController *pc = em->addComponent <PlayerController> (plr);
	pc->center_or_aux = center_or_aux;
	
	if (center_or_aux == CENTER)
	{	
		pc->left_or_right = LEFT;
	}
	else
	{	
		pc->left_or_right = RIGHT;
	}

	pc->config = HORIZONTAL;
	pc->type = type;
	pc->col = col;
	pc->row = row;
	
	
	std::string filename = blob_filenames[type];
	
	
	AtlasSprite *as = em->addComponent<AtlasSprite>(plr);
	as->atlas_quad = g_RenderableManager.accquireTexturedAtlasQuad(filename);
	as->src = rect_make(0*32, 0, 32, 32);
	as->z = 3;
	
	
	return plr;
	
}
