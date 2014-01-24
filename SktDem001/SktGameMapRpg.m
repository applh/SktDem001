//
//  SktGameMapRpg.m
//  SktDem001
//
//  Created by APPLH.COM on 24/01/2014.
//  Copyright (c) 2014 APPLH.COM. All rights reserved.
//

#import "SktGameMapRpg.h"
#import "SktSceneGame.h"

@implementation SktGameMapRpg
@synthesize scene;

// METHODS
-(void) restartGame
{
    NSLog(@"RPG");

    // SCALE THE MAP
    self.scene.world2scale = .1;
    self.scene.player2vmax2scale = self.scene.world2scale * (self.scene.world2scale + .25);
    
    // THE WORLD IS ROUND
    self.scene.world2mode = 0;
    
}

@end
