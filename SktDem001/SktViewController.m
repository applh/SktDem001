//
//  SktViewController.m
//  SktDem001
//
//  Created by APPLH.COM on 13/01/2014.
//  Copyright (c) 2014 APPLH.COM. All rights reserved.
//

#import "SktViewController.h"
#import "SktMyScene.h"

@implementation SktViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    Boolean debug = YES;
    
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    
    // DEBUG
    if (debug) {
        skView.showsFPS = YES;
        skView.showsNodeCount = YES;
    }
    
    // Create and configure the scene.
    SktMyScene * scene = [SktMyScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [skView presentScene:scene];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
