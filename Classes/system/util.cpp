/*
 *  util.cpp
 *  ComponentV3
 *
 *  Created by jrk on 13/11/10.
 *  Copyright 2010 flux forge. All rights reserved.
 *
 */

#include "util.h"
#include <math.h>
namespace mx3 
{
	vector2D vector2D_make (float x, float y)
	{
		vector2D vc = {x,y};
		return vc;
	}

	vector2D vector2D_normalize (vector2D vec)
	{
		float len = sqrt((vec.x * vec.x) + (vec.y * vec.y));
		vec.x = vec.x/len;
		vec.y = vec.y/len;
		
		return vec;
	}
	
	rect rect_make (float x, float y, float w, float h)
	{
		rect rc = {x,y,w,h};
		return rc;
	}

}