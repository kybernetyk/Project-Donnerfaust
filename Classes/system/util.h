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

#define ROUND(x) (((x)>0) ? long((x)+.5) : long((x)-.5))
#define SQR(x)   ((x)*(x))
#if !defined(MIN)
#define MIN(A,B)	((A) < (B) ? (A) : (B))
#endif

#if !defined(MAX)
#define MAX(A,B)	((A) > (B) ? (A) : (B))
#endif

namespace mx3 
{
		
	struct vector2D
	{
		float x;
		float y;
	};

	vector2D vector2D_make (float x, float y);
	vector2D vector2D_normalize (vector2D vec);
	struct rect
	{
		float x;
		float y;
		float w;
		float h;
	};

	rect rect_make (float x, float y, float w, float h);
	bool rect_is_equal_to_rect (rect *r1, rect *r2);
}