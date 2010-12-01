/*
 *  SystemConfig.h
 *  ComponentV3
 *
 *  Created by jrk on 10/11/10.
 *  Copyright 2010 flux forge. All rights reserved.
 *
 */

//entity system checks and infos
#define __RUNTIME_INFORMATION__
#define __ABORT_GUARDS__
#define __ENTITY_MANAGER_WARNINGS__

//device orientation mode
//#define ORIENTATION_LANDSCAPE
#define ORIENTATION_PORTRAIT

//screen size
#define SCREEN_W 320.0
#define SCREEN_H 480.0

//allow offscreen texture rendertarget for the RenderDEvice
#define __ALLOW_RENDER_TO_TEXTURE__

//Entity Manager
#define MAX_ENTITIES 512
#define MAX_COMPONENTS_PER_ENTITY 32

/* convention for slots:
	use multiples of 2
	lower half is registered for the system
	upper half is free for user use

	example with MAX_COMPONENTS_PER_ENTITY = 32:
	internal system use: 0..15 (0 is reserved and not valid!)
	user use: 16..31
*/