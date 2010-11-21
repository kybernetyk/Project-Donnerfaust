/*
 *  blob_factory.h
 *  Donnerfaust
 *
 *  Created by jrk on 17/11/10.
 *  Copyright 2010 flux forge. All rights reserved.
 *
 */
#pragma once
#include "Entity.h"

struct mx3::Entity;


mx3::Entity *make_blob (int color, int col,int row);



mx3::Entity *make_player_blob (int leftright, int type, int col,int row);