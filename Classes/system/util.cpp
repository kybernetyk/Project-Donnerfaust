/*
 *  util.cpp
 *  ComponentV3
 *
 *  Created by jrk on 13/11/10.
 *  Copyright 2010 flux forge. All rights reserved.
 *
 */

#include "util.h"
namespace mx3 
{
	vector2D vector2D_make (float x, float y)
	{
		vector2D vc = {x,y};
		return vc;
	}

	rect rect_make (float x, float y, float w, float h)
	{
		rect rc = {x,y,w,h};
		return rc;
	}

}