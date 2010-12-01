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

-(void)renderScene;
-(void)LoadPrefs;
-(void)SavePrefs;


- (void) startAnimation;
- (void) stopAnimation;

@end

