//
//  MainViewController.m
//  ComponentV3
//
//  Created by jrk on 15/11/10.
//  Copyright 2010 flux forge. All rights reserved.
//
#import "ComponentV3.h"
#import "MainViewController.h"
#import "EAGLView.h"

@implementation MainViewController
@synthesize glView;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
//	return YES;
    // Return YES for supported orientations
#ifdef ORIENTATION_LANDSCAPE
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight ||
			interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
#endif
	
#ifdef ORIENTATION_PORTRAIT
	return (interfaceOrientation == UIInterfaceOrientationPortrait ||
			interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
#endif
	
	//else
	return YES;
	
}


- (void)didReceiveMemoryWarning 
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc 
{
    [super dealloc];
}

extern bool spawn_one;

- (IBAction) spawnOne: (id) sender
{
	spawn_one = true;	
}

extern bool spawn_player;

- (IBAction) spawnPlayer: (id) sender
{
	spawn_player = true;
}

@end
