//
//  SktDemGame.h
//  SktDem001
//
//  Created by APPLH.COM on 13/01/2014.
//  Copyright (c) 2014 APPLH.COM. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>


// CLASS DECLARATION FORWARD
@class SktPopup;
@class SktGame;


@interface SktSceneGame : SKScene <SKPhysicsContactDelegate>

@property SKNode* hud;              // HEAD UP DISPLAY
@property SKNode* hud2bg;           // HUD BACKGROUND
@property SKNode* hud2fg;           // HUD FOREGROUND
@property SKNode* hud2popup;        // HUD POPUP

@property SktPopup* popup;          // POPUP

@property SKLabelNode* hud2top;     // HUD TOP
@property SKLabelNode* hud2center;  // HUD CENTER
@property SKLabelNode* hud2bottom;  // HUD BOTTOM

@property float   world2scale;      // ZOOM FACTOR
@property SKNode* world;            // WORLD
@property SKNode* world2fg;         // WORLD FOREGROUND
@property SKNode* world2bg;         // WORLD BACKGROUND
@property SKNode* world2rootile;    // WORLD ROOT TILE
@property SKNode* world2camera;     // WORLD CAMERA NODE / POSITION
@property SKNode* world2player;     // WORLD PLAYER

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


@property int playerLevel;
@property int playerWinner;

@property int playerEnergy;
@property int playerScore;
@property int playerScoreWin;

@property int userRestart;
@property int userPause;
@property int userGameChoice;

@property SktGame* userGame;

// OVERRIDE
- (id)   initWithSize: (CGSize) size;

- (void) didChangeSize: (CGSize) oldSize;

- (void) showGameStart;

- (void) touchesBegan: (NSSet *)    touches
            withEvent: (UIEvent *)   event;

- (void) touchesMoved: (NSSet *)    touches
            withEvent: (UIEvent *)   event;

- (void) touchesEnded: (NSSet *)    touches
            withEvent: (UIEvent *)   event;

- (void) didSimulatePhysics;

- (void) didBeginContact: (SKPhysicsContact *) contact;

// CUSTOM
- (void) setupNewGame;
- (void) setupHud;
- (void) setupWorld;
- (void) setupPlayer;

- (void) centerOnNode: (SKNode *) node;

- (void) updateNextFrame: (NSTimeInterval) currentTime;
- (void) updateHud;

- (void) pausePopup;
- (void) keyboardPopup;


@end
