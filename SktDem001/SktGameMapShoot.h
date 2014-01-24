//
//  SktGameMapShoot.h
//  SktDem001
//
//  Created by APPLH.COM on 24/01/2014.
//  Copyright (c) 2014 APPLH.COM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SktGameInterface.h"

@interface SktGameMapShoot : NSObject <SktGameInterface>

// ATTRIBUTES
@property uint32_t ccPlayer;
@property uint32_t ccOrb;
@property uint32_t ccRobot;
@property uint32_t ccBonus;
@property uint32_t ccRock;


// METHODS
-(id) init;
-(void) restartGame;
-(void) setupHud;
-(void) setupWorld;


@end
