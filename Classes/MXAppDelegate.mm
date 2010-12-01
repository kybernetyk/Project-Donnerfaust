
#import "MXAppDelegate.h"
#import "EAGLView.h"
#include <sys/time.h>
#include "Entity.h"
#include "EntityManager.h"
#import "FacebookSubmitController.h"
#import "MainViewController.h"
#include "Scene.h"
#include "RenderDevice.h"
#import <QuartzCore/QuartzCore.h>
#include "Timer.h"
#include "globals.h"






@implementation MXAppDelegate



@synthesize window;


- (void) shareLevelOnFarmville
{
	NSLog(@"ok, let's see if we can submit to fb!");
	
	if (g_GameState.level == 10 || 
		g_GameState.level == 15 || 
		g_GameState.level == 20 ||
		g_GameState.level == 25 ||
		g_GameState.level >= 30)
	{
		// lol
		NSLog(@"ok, we can submit to fb ...");
	}
	else
	{
		return;
	}
	
	
	NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
	if ([defs boolForKey: @"facebook_disable"])
	{
		NSLog(@"Facebook disabled by user!");
		return;
	}
	
	
	NSString *token = [defs objectForKey: @"fbtoken"];
	if (token)
	{
		NSLog(@"found token. init share!");
		[self initFBShare];
		return;
	}
	
	NSLog(@"no token. let's ask user!");
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: @"Share On Facebook" 
														message: @"Do you want to share your progress on Facebook?" 
													   delegate: self 
											  cancelButtonTitle: @"No. Don't ask me again." 
											  otherButtonTitles: @"Yes!", @"Not now.", nil];
	
	[alertView show];
	[alertView autorelease]; 
	
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	NSLog(@"omg der buttonen indexen: %i, %@", buttonIndex,	[alertView buttonTitleAtIndex: buttonIndex]);
	if (buttonIndex == 1)
	{
		NSLog(@"user wants to share!");
		[self initFBShare];
		return;
	}
	if (buttonIndex == 2)
	{
		NSLog(@"user wants not to share now ...");
		return;
	}
	
	NSLog(@"user hates facebook!");
	NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
	[defs setBool: YES forKey: @"facebook_disable"];
	[defs synchronize];
}


- (void) initFBShare
{
	if (!facebookController)
	{
		facebookController = [[FacebookSubmitController alloc] initWithNibName: @"FacebookSubmitController" bundle: nil];
		[facebookController setDelegate: self];
		
	}
	
	[facebookController setLevel: g_GameState.level];
	[facebookController setScore: g_GameState.score];
	
	//	[self presentModalViewController: fbsc animated: YES];
	[facebookController shareOverFarmville];
}

- (void) facebookSubmitControllerDidFinish: (id) controller
{
	NSLog(@"facebook controller finished");
//	[controller autorelease];
}


#pragma mark -
#pragma mark stuff
- (void)applicationDidFinishLaunching:(UIApplication *)application 
{
	mainViewController = [[MainViewController alloc] initWithNibName: @"MainViewController" bundle: nil];
	[window addSubview: [mainViewController view]];
	
	glView = [[mainViewController glView] retain];
	
	
	theGame = new game::Game();
	theGame->init();
	
#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
	displayLink = [CADisplayLink displayLinkWithTarget: self selector:@selector(renderScene)];
	[displayLink setFrameInterval: 1];
	[displayLink addToRunLoop: [NSRunLoop currentRunLoop] forMode: NSDefaultRunLoopMode];
#elif defined(__MAC_OS_X_VERSION_MAX_ALLOWED)
	//mac init
#endif
	
	
}


- (void)applicationWillTerminate:(UIApplication *)application 
{
	[self saveGameState];
}

- (void)dealloc 
{
	[[mainViewController view] removeFromSuperview];
	[mainViewController release];
	[window release];
	[glView release];
	[super dealloc];
}


- (void)renderScene
{
	theGame->update();
	
	[glView startDrawing];
	theGame->render();
	[glView endDrawing];

	/*[glView startDrawing];
	RenderDevice::sharedInstance()->beginRender();
	scene->render(1.0);
	scene->frameDone();
	RenderDevice::sharedInstance()->endRender();
	[glView endDrawing];
	
	
	return;*/
	//draw
	

//	glEnable(GL_ALPHA_TEST);
	//glEnable(GL_BLEND);
	
	
}

-(void)SavePrefs
{
}

-(void)LoadPrefs
{
}

#pragma mark -
#pragma mark delegate

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
	//[[facebookController facebook] handleOpenURL: url];
	
	return [facebookController handleOpenURL: url];
	
	return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application 
{
	[self saveGameState];
	game::paused = true;
	//	[[CCDirector sharedDirector] pause];
}

- (void)applicationDidBecomeActive:(UIApplication *)application 
{
//	[[CCDirector sharedDirector] resume];
	game::paused = false;
	game::next_game_tick = mx3::GetTickCount();
	game::timer.update();
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application 
{
//	[[CCDirector sharedDirector] purgeCachedData];
}

-(void) applicationDidEnterBackground:(UIApplication*)application 
{
//	[[CCDirector sharedDirector] stopAnimation];
	game::paused = true;
}

-(void) applicationWillEnterForeground:(UIApplication*)application 
{
//	[[CCDirector sharedDirector] startAnimation];
	game::paused = false;
	game::next_game_tick = mx3::GetTickCount();
	game::timer.update();
}


- (void)applicationSignificantTimeChange:(UIApplication *)application 
{
	//[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
	game::next_game_tick = mx3::GetTickCount();
	game::timer.update();
}

#pragma mark -
#pragma mark restoresave
- (void) saveGameState
{
	NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
	
	if (g_GameState.level <= 0)
	{
		g_GameState.level = 1;
		g_GameState.experience_needed_to_levelup = g_GameState.level*g_GameState.level*g_GameState.level+100;
	}
	
	[defs setInteger: g_GameState.experience forKey: @"gs_experience"];
	[defs setInteger: g_GameState.level forKey: @"gs_level"];
	[defs setInteger: g_GameState.score forKey: @"gs_score"];
	[defs synchronize];	
}

- (void) loadGameState
{
	NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
	
	NSInteger xp = [defs integerForKey: @"gs_experience"];
	NSInteger level = [defs integerForKey: @"gs_level"];
	NSInteger score = [defs integerForKey: @"gs_score"];
	if (level <= 0)
		level = 1;
	
	g_GameState.experience = xp;
	g_GameState.level = level;
	g_GameState.score = score;
	g_GameState.experience_needed_to_levelup =g_GameState.level*g_GameState.level*g_GameState.level+100;
	
}

@end
