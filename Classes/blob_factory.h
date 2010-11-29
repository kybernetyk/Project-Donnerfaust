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

extern std::string blob_filenames[];
extern std::string blob_filenames_2[];

mx3::Entity *make_blob (int color, int col,int row);



mx3::Entity *make_player_blob (int center_or_aux, int type, int col,int row);

void preload_blob_textures ();