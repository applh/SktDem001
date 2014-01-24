//
//  SktGame.m
//  SktDem001
//
//  Created by APPLH.COM on 24/01/2014.
//  Copyright (c) 2014 APPLH.COM. All rights reserved.
//

#import "SktGame.h"

#import "SktGameInterface.h"
#import "SktGameMapShoot.h"
#import "SktGameMapRpg.h"
#import "SktGameGravity.h"

@implementation SktGame

-(void) setupGame:(int) g
        withScene:(SktSceneGame*) scene
{
    self.scene = scene;
    
    self.userChoice = g;
    
    // CREATE DELEGATE DEPENDING ON USER CHOICE
    if (g == 1)  {
        self.game = [SktGameMapShoot new];
    }
    else if (g == 2)  {
        self.game = [SktGameMapRpg new];
    }
    else if (g == 3)  {
        self.game = [SktGameGravity new];
    }
    
    // SETUP SCENE WITH GAME DELEGATE
    self.game.scene = scene;
}

-(void) restartGame
{
    [self.game restartGame];
}

@end
