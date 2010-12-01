/*
 *  SystemConfig.h
 *  ComponentV3
 *
 *  Created by jrk on 10/11/10.
 *  Copyright 2010 flux forge. All rights reserved.
 *
 */

//system
#define __RUNTIME_INFORMATION__
#define ABORT_GUARDS
#define __ENTITY_MANAGER_WARNINGS__

//graphics
//#define ORIENTATION_LANDSCAPE
#define ORIENTATION_PORTRAIT

#define SCREEN_W 320.0
#define SCREEN_H 480.0

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