//
//  SktDemGame.h
//  SktDem001
//
//  Created by APPLH.COM on 13/01/2014.
//  Copyright (c) 2014 APPLH.COM. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SktSceneGame : SKScene <SKPhysicsContactDelegate>

@property uint32_t ccPlayer;
@property uint32_t ccOrb;
@property uint32_t ccRobot;
@property uint32_t ccBonus;
@property uint32_t ccRock;

@property SKNode* hud;              // HEAD UP DISPLAY
@property SKNode* hud2fg;           // HUD FOREGROUND

@property SKLabelNode* hud2top;     // HUD TOP
@property SKLabelNode* hud2center;  // HUD CENTER
@property SKLabelNode* hud2bottom;  // HUD BOTTOM

@property float   world2scale;  // ZOOM FACTOR
@property SKNode* world;        // WORLD
@property SKNode* world2fg;     // WORLD FOREGROUND
@property SKNode* world2bg;     // WORLD BACKGROUND
@property SKNode* world2camera; // WORLD CAMERA NODE / POSITION
@property SKNode* world2player; // WORLD PLAYER

@property CGSize  init2size;
@property CGPoint world2min;
@property CGPoint world2max;
@property int     world2mode;   // 0 = round, 1 = flat


@property float   player2vmax;  // Velocity max
@property float   player2vmax2scale;  // Velocity max factor

@property float   game2fps;     // REALTIME FPS
@property double  lastUpdateT;  // REALTIME FPS
@property double  curUpdateT;   // REALTIME FPS
@property double  deltaUpdateT; // REALTIME FPS

@property double  lastMissileT; // MISSILE FPS
@property double  minMissileT; // MISSILE FPS

@property int playerEnergy;
@property int playerScore;

@property int userRestart;

// OVERRIDE
-(id)   initWithSize: (CGSize) size;
-(void) touchesBegan: (NSSet *) touches withEvent: (UIEvent *) event;
-(void) didBeginContact: (SKPhysicsContact *) contact;

// CUSTOM
-(void) setupNewGame;
-(void) setupHud;
-(void) setupWorld;
-(void) setupPlayer;

-(void) centerOnNode: (SKNode *) node;
-(void) manageWorldLimit;
-(void) addRandomRobotAt:(CGPoint) location;

-(void) updateNextFrame:(NSTimeInterval)currentTime;
    
@end
