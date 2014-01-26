//
//  SktDemGame.m
//  SktDem001
//
//  Created by APPLH.COM on 13/01/2014.
//  Copyright (c) 2014 APPLH.COM. All rights reserved.
//

#import "SktSceneGame.h"
#import "SktSceneStart.h"
#import "SktPopup.h"
#import "SktKeyboard.h"
#import "SktGame.h"

@implementation SktSceneGame

-(id) initWithSize: (CGSize)size
{
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.userGameChoice = 0;
        
        self.backgroundColor = [SKColor colorWithRed: 0.05
                                               green: 0.05
                                                blue: 0.20
                                               alpha: 1.0];
        
        // create the parent nodes
        self.hud = [SKNode node];
        self.world = [SKNode node];
        
        self.anchorPoint = CGPointMake(.5, .5);
        self.world2scale = .2;

        // add to the scene
        [self addChild:self.world];
        [self addChild:self.hud];
        
        // SETUP
        self.init2size = size;
        

    }
    return self;
}

-(void) didMoveToView: (SKView *)view
{
    // FORMER SCENE HAS SETUP USER CHOICES
    self.userGame = [SktGame new];
    [self.userGame setupGame:self.userGameChoice
                   withScene:self];
    
    self.playerWinner = 0;
    self.playerLevel = 1;
    // SCORE TO WIN
    self.playerScoreWin = 100;
    
    [self setupHud];
    [self setupNewGame];
}

-(void) setupNewGame
{
    [self.userGame restartGame];
        
    [self.world removeAllChildren];
    [self setupWorld];
    self.userRestart = 0;
    self.userPause = 0;

    if (self.playerWinner > 0) {
        self.playerLevel++;
        self.playerWinner = 0;
    }
    
    // SCORE TO WIN
    self.playerScoreWin = self.playerLevel * 100;

    // CONTACT DELEGATE
    self.physicsWorld.contactDelegate = self;
    
}

// CUSTOM
-(void) setupHud
{
    self.userRestart = 0;
    self.userPause = 0;
    
    [self.userGame setupHud];
}

-(void) setupWorld
{
    [self.userGame setupWorld];
}

-(void) setupPlayer
{
    [self.userGame setupPlayer];
}

-(void) showGameStart
{
    // Create and configure the scene.
    SKView * skView = (SKView *)self.view;
    
    SktSceneStart * scene = [SktSceneStart sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFit;
    
    // ADD TRANSITION EFFECT
    SKTransition *doors = [SKTransition
                           flipHorizontalWithDuration:1.0];
    // Present the scene.
    [skView presentScene:scene transition:doors];

}

-(void) touchesBegan: (NSSet *)     touches
           withEvent: (UIEvent *)   event
{
    /* Called when a touch begins */
    [self.userGame touchesBegan:touches
                      withEvent:event];
}

-(void) touchesMoved: (NSSet *)     touches
           withEvent: (UIEvent *)   event
{
    [self.userGame touchesMoved:touches
                      withEvent:event];
}

-(void) touchesEnded: (NSSet *)     touches
           withEvent: (UIEvent *)   event
{
    /* Called when a touch ends */
    [self.userGame touchesEnded:touches
                      withEvent:event];
}


-(void) pausePopup
{
    if (self.popup == nil) {
        self.popup =
        [SktPopup initWithName: @"popup"
                      showText: @"START A NEW GAME ?"
                        showOk: @"Restart"
                    showCancel: @"Back"
                      showExit: @"exit"
                       inScene: self
                    parentNode: self.hud2popup];
    }
    
}

-(void) keyboardPopup
{
    if (self.popup == nil) {
        self.popup =
        [SktKeyboard initWithName:@"popup"
                       parentNode:self.hud2popup];
    }
    
}


-(void) updateNextFrame: (NSTimeInterval) currentTime
{
    if (self.userPause > 0) return;
    
    // UPDATE FPS COMPUTING
    self.lastUpdateT = self.curUpdateT;
    self.curUpdateT = currentTime;
    self.deltaUpdateT = self.curUpdateT - self.lastUpdateT;
    
    [self.userGame updateNextFrame:currentTime];
}


-(void) updateHud
{
    [self.userGame updateHud];
}

- (void) update: (NSTimeInterval) currentTime
{
    
    if (self.userRestart == 1) {
        // RESTART NEW GAME
        [self setupNewGame];
    }
    else if (self.playerWinner < 1) {
        if (self.playerEnergy <= 0) {
            // GAME END
            self.userPause = 1;
            [self pausePopup];
        }
        else if (self.playerScore >= self.playerScoreWin) {
            // NEXT LEVEL
            self.playerWinner++;
            // GAME END
            self.userPause = 1;
            [self pausePopup];
        }
        
        // PAUSE
        if (self.userPause > 0) {
            self.physicsWorld.speed = 0;
        }
        else {
            self.physicsWorld.speed = 1;
            // GAME PLAY
            [self updateNextFrame:currentTime];
        }
    }
    
    // KEEP USER UP TO DATE
    [self updateHud];
    
}

- (void) didSimulatePhysics
{
    [self.userGame didSimulatePhysics];
}

- (void) centerOnNode: (SKNode *) node
{
    CGPoint cameraPositionInScene = [node.scene convertPoint: node.position
                                                    fromNode: node.parent];
    self.world.position = CGPointMake(self.world.position.x - cameraPositionInScene.x,
                                       self.world.position.y - cameraPositionInScene.y);
}


- (void) didBeginContact: (SKPhysicsContact *) contact
{
    [self.userGame didBeginContact: contact];
}

@end
