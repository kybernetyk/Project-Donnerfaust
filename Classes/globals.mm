/*
 *  globals.c
 *  ComponentV3
 *
 *  Created by jrk on 11/11/10.
 *  Copyright 2010 flux forge. All rights reserved.
 *
 */
#include "globals.h"
#include "TextureManager.h"
#include "TexturedQuad.h"

mx3::TextureManager g_TextureManager;
mx3::RenderableManager g_RenderableManager;

game::GameState g_GameState;
double g_FPS = 0.0;