#pragma once
#import <UIKit/UIKit.h>
#import "MainViewController.h"
#import "FacebookSubmitController.h"

#include "Timer.h"
#include "Scene.h"



@interface MXAppDelegate : NSObject <UIApplicationDelegate> 
{
    UIWindow *window;
	NSTimer*			mTimer;   // Rendering Timer
	CADisplayLink *displayLink;
	mx3::Timer timer;
	game::Scene *scene;

	EAGLView *glView;
	
	MainViewController *mainViewController;
	FacebookSubmitController *facebookController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

-(void)renderScene;
-(void)LoadPrefs;
-(void)SavePrefs;

@end

