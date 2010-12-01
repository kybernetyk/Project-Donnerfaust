#pragma once
#import <UIKit/UIKit.h>
#import "MainViewController.h"
#import "FacebookSubmitController.h"

#include "Game.h"



@interface MXAppDelegate : NSObject <UIApplicationDelegate> 
{
    UIWindow *window;
	NSTimer*			mTimer;   // Rendering Timer
	CADisplayLink *displayLink;

	EAGLView *glView;
	
	game::Game *theGame;
	
	MainViewController *mainViewController;
	FacebookSubmitController *facebookController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
- (void) startAnimation;
- (void) stopAnimation;

- (void)renderScene;

- (void) saveGameState;

- (void) initFBShare;
@end

