//
//  SktGameGravity.h
//  SktDem001
//
//  Created by APPLH.COM on 24/01/2014.
//  Copyright (c) 2014 APPLH.COM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SktGameInterface.h"

@interface SktGameGravity : NSObject <SktGameInterface>

// ATTRIBUTES
@property uint32_t ccPlayer;
@property uint32_t ccOrb;
@property uint32_t ccRobot;
@property uint32_t ccBonus;
@property uint32_t ccRock;

// METHODS
-(id)   init;

-(void) restartGame;
-(void) setupHud;
-(void) setupWorld;
-(void) setupPlayer;

-(void) updateHud;
-(void) updateNextFrame:(NSTimeInterval) currentTime;

-(void) touchesBegan: (NSSet *)     touches
           withEvent: (UIEvent *)   event;

-(void) touchesMoved: (NSSet *)     touches
           withEvent: (UIEvent *)   event;

-(void) touchesEnded: (NSSet *)     touches
           withEvent: (UIEvent *)   event;

- (id) addRandomRobotAt: (CGPoint) location;

- (id) addRandomRockAt: (CGPoint)  location;

- (id) addRandomBonusAt: (CGPoint)  location;

- (id) didBeginContact: (SKPhysicsContact *) contact;

@end
