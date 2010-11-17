/*
 *  Util.h
 *  framework
 *
 *  Created by Jaroslaw Szpilewski on 22.06.08.
 *  Copyright 2008 __MyCompanyName__. All rights reserved.
 *
 */
#pragma once

#define DEG2RAD(x) (0.0174532925 * (x))
#define RAD2DEG(x) (57.295779578 * (x))
namespace mx3 
{
		
	struct vector2D
	{
		float x;
		float y;
	};

	vector2D vector2D_make (float x, float y);

	struct rect
	{
		float x;
		float y;
		float w;
		float h;
	};

	rect rect_make (float x, float y, float w, float h);

}