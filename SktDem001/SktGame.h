//
//  SktGame.h
//  SktDem001
//
//  Created by APPLH.COM on 24/01/2014.
//  Copyright (c) 2014 APPLH.COM. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "SktGameInterface.h"

// DECLARATION FORWARD
@class SktSceneGame;

@interface SktGame : NSObject

// ATTRIBUTES
@property SktSceneGame*         scene;
@property int                   userChoice;
@property id <SktGameInterface> game;

@property double  lastMissileT; // MISSILE FPS
@property double  minMissileT; // MISSILE FPS


@property uint32_t ccPlayer;
@property uint32_t ccOrb;
@property uint32_t ccRobot;
@property uint32_t ccBonus;
@property uint32_t ccRock;



// METHODS
-(void) setupGame:(int) g
        withScene:(SktSceneGame*) scene;

-(void) restartGame;
-(void) setupHud;
-(void) setupWorld;
-(void) setupPlayer;
-(void) updateHud;
-(void) updateNextFrame: (NSTimeInterval) currentTime;

-(void) touchesBegan: (NSSet *)     touches
           withEvent: (UIEvent *)   event;

-(void) launchMissile:(SKNode*)         from
                 Time: (NSTimeInterval) currentTime;

-(void) addRandomRockAt: (CGPoint)  location;
-(void) addRandomRobotAt: (CGPoint) location;
-(void) addRandomBonusAt: (CGPoint) location;

-(void) didBeginContact: (SKPhysicsContact *) contact;


@end
