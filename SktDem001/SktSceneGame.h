//
//  SktDemGame.h
//  SktDem001
//
//  Created by APPLH.COM on 13/01/2014.
//  Copyright (c) 2014 APPLH.COM. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SktSceneGame : SKScene

@property SKNode* hud;          // HEAD UP DISPLAY
@property SKNode* hud2fg;       // HUD FOREGROUND

@property float   world2scale;  // ZOOM FACTOR
@property SKNode* world;        // WORLD
@property SKNode* world2fg;     // WORLD FOREGROUND
@property SKNode* world2bg;     // WORLD BACKGROUND
@property SKNode* world2camera; // WORLD CAMERA NODE / POSITION
@property SKNode* world2player; // WORLD PLAYER

// OVERRIDE
-(id)   initWithSize: (CGSize) size;
-(void) touchesBegan: (NSSet *) touches withEvent: (UIEvent *) event;

// CUSTOM
-(void) setupHud;
-(void) setupWorld;
-(void) setupPlayer;

-(void) centerOnNode: (SKNode *) node;

@end
