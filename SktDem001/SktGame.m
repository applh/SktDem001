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
{
    self.userChoice = g;
    
    if (g == 0)  {
        self.game = [SktGameMapShoot new];
    }
    else if (g == 1)  {
        self.game = [SktGameMapRpg new];
    }
    else if (g == 2)  {
        self.game = [SktGameGravity new];
    }
}

-(void) restartGame
{
    [self.game restartGame];
}

@end
