
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

using namespace mx3;
using namespace game;



const int TICKS_PER_SECOND = 60;
const int SKIP_TICKS = 1000 / TICKS_PER_SECOND;
const int MAX_FRAMESKIP = 5;
const double FIXED_DELTA = (1.0/TICKS_PER_SECOND);
unsigned int next_game_tick = 1;//SDL_GetTicks();
int loops;
float interpolation;
bool paused = false;

/* returns the system time in milliseconds */
unsigned int My_SDL_GetTicks()
{
	timeval v;
	gettimeofday(&v, 0);
	//long millis = (v.tv_sec * 1000) + (v.tv_usec / 1000);
	//return millis;
	
	return (v.tv_sec * 1000) + (v.tv_usec / 1000);
}




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
	
	scene = new Scene();
	scene->init();
	
	RenderDevice::sharedInstance()->init ();
	next_game_tick = My_SDL_GetTicks();
#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
	displayLink = [CADisplayLink displayLinkWithTarget: self selector:@selector(renderScene)];
	[displayLink setFrameInterval: 1];
	[displayLink addToRunLoop: [NSRunLoop currentRunLoop] forMode: NSDefaultRunLoopMode];
#elif defined(__MAC_OS_X_VERSION_MAX_ALLOWED)
	//mac init
#endif
	
	paused = false;
	//timer = new Timer();
	//timer->update();
	g_ActiveGFX = GFX_NONE;
	
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
	if (paused)
		return;
	static float r = 0;
	timer.update();
	g_FPS = timer.printFPS(false);
	
#define FIXED_STEP_LOOP
#ifdef FIXED_STEP_LOOP
	loops = 0;
	while( My_SDL_GetTicks() > next_game_tick && loops < MAX_FRAMESKIP) 
	{
		scene->update(FIXED_DELTA);
		next_game_tick += SKIP_TICKS;
		loops++;	
		r += 32.0 * FIXED_DELTA;
	}

#else
	r+=32.0*timer.fdelta();
	scene->update(timer.fdelta());	//blob rotation doesn't work well with high dynamic delta! fix this before enabling dynamic delta
#endif

	/*[glView startDrawing];
	RenderDevice::sharedInstance()->beginRender();
	scene->render(1.0);
	scene->frameDone();
	RenderDevice::sharedInstance()->endRender();
	[glView endDrawing];
	
	
	return;*/
	//draw
	[glView startDrawing];

//	glEnable(GL_ALPHA_TEST);
	//glEnable(GL_BLEND);
	
	if (g_ActiveGFX == GFX_NONE)
	{
		RenderDevice::sharedInstance()->setRenderTargetScreen();

		RenderDevice::sharedInstance()->beginRender();
		scene->render(1.0);
		scene->frameDone();
		RenderDevice::sharedInstance()->endRender();
		[glView endDrawing];
		return;
		
	}
	
	
	//gfxe
	RenderDevice::sharedInstance()->setRenderTargetBackingTexture();
	RenderDevice::sharedInstance()->beginRender();
	scene->render(1.0);
	scene->frameDone();
	RenderDevice::sharedInstance()->endRender();
	
	RenderDevice::sharedInstance()->setRenderTargetScreen();


//	glDisable(GL_ALPHA_TEST);
	//glDisable(GL_BLEND);
	
	RenderDevice::sharedInstance()->beginRender();	

	//rotozoom
	if (g_ActiveGFX == GFX_ROTOZOOM)
	{
		glLoadIdentity();

		int _x = SCREEN_W; 		//= viewport size in meters
		int _y = SCREEN_H;
		
		float xscale = fabs(sin (DEG2RAD (r))) + 0.2;
//		float yscale = (cos (DEG2RAD (r))) * 2.0;
		
		glTranslatef( (0.5 * _x),  (0.5 * _y), 0);
		glScalef(xscale, xscale, 1.0);
		glRotatef(r, 0, 0, 1.0);
		glTranslatef( -(0.5 * _x),  -(0.5 * _y), 0);
		
		glPushMatrix();
		glTranslatef(-_x, -_y, 0);
		RenderDevice::sharedInstance()->renderBackingTextureToScreen();
		glPopMatrix();
		
		
		glPushMatrix();
		glTranslatef(0, -_y, 0);
		RenderDevice::sharedInstance()->renderBackingTextureToScreen();
		glPopMatrix();
		
		glPushMatrix();
		glTranslatef(_x, -_y, 0);
		RenderDevice::sharedInstance()->renderBackingTextureToScreen();
		glPopMatrix();
		
		glPushMatrix();
		glTranslatef(-_x, 0, 0);
		RenderDevice::sharedInstance()->renderBackingTextureToScreen();
		glPopMatrix();
		
		glPushMatrix();
		glTranslatef(0, 0, 0);
		RenderDevice::sharedInstance()->renderBackingTextureToScreen();
		glPopMatrix();
		
		glPushMatrix();
		glTranslatef(_x, 0, 0);
		RenderDevice::sharedInstance()->renderBackingTextureToScreen();
		glPopMatrix();
		
		glPushMatrix();
		glTranslatef(-_x, _y, 0);
		RenderDevice::sharedInstance()->renderBackingTextureToScreen();
		glPopMatrix();
		
		glPushMatrix();
		glTranslatef(0, _y, 0);
		RenderDevice::sharedInstance()->renderBackingTextureToScreen();
		glPopMatrix();
		
		glPushMatrix();
		glTranslatef(_x, _y, 0);
		RenderDevice::sharedInstance()->renderBackingTextureToScreen();
		glPopMatrix();
	}
	else
	{
		glLoadIdentity();
		RenderDevice::sharedInstance()->renderBackingTextureToScreen();
	}
	RenderDevice::sharedInstance()->endRender();	
	
	[glView endDrawing];
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
	paused = true;
	//	[[CCDirector sharedDirector] pause];
}

- (void)applicationDidBecomeActive:(UIApplication *)application 
{
//	[[CCDirector sharedDirector] resume];
		paused = false;
	next_game_tick = My_SDL_GetTicks();
	timer.update();
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application 
{
//	[[CCDirector sharedDirector] purgeCachedData];
}

-(void) applicationDidEnterBackground:(UIApplication*)application 
{
//	[[CCDirector sharedDirector] stopAnimation];
	paused = true;
}

-(void) applicationWillEnterForeground:(UIApplication*)application 
{
//	[[CCDirector sharedDirector] startAnimation];
	paused = false;
	next_game_tick = My_SDL_GetTicks();
	timer.update();
}


- (void)applicationSignificantTimeChange:(UIApplication *)application 
{
	//[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
	next_game_tick = My_SDL_GetTicks();
	timer.update();
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
