//
//  SktGameGravity.m
//  SktDem001
//
//  Created by APPLH.COM on 24/01/2014.
//  Copyright (c) 2014 APPLH.COM. All rights reserved.
//

#import "SktGameGravity.h"
#import "SktSceneGame.h"

@implementation SktGameGravity
@synthesize scene;

// METHODS
-(void) restartGame
{
    NSLog(@"GRAVITY");

    // SCALE THE MAP
    self.scene.world2scale = .05;
    self.scene.player2vmax2scale = self.scene.world2scale * (self.scene.world2scale + .25);
    
    // THE WORLD IS ROUND
    self.scene.world2mode = 0;
   
}


@end
