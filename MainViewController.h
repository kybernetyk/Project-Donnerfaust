//
//  MainViewController.h
//  ComponentV3
//
//  Created by jrk on 15/11/10.
//  Copyright 2010 flux forge. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EAGLView;

@interface MainViewController : UIViewController 
{
	EAGLView *glView;
}

- (IBAction) spawnOne: (id) sender;

- (IBAction) spawnPlayer: (id) sender;

@property (nonatomic, retain) IBOutlet EAGLView *glView;

@end
