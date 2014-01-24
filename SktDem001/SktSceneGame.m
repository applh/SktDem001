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
#import "SktGame.h"

@implementation SktSceneGame

-(id) initWithSize: (CGSize)size
{
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.userGameChoice = 0;
        
        self.backgroundColor = [SKColor colorWithRed:0.05 green:0.05 blue:0.20 alpha:1.0];
        
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

-(void) didMoveToView:(SKView *)view
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

    // NO GRAVITY
    self.physicsWorld.gravity = CGVectorMake(0, 0);
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

-(void) touchesBegan: (NSSet *)     touches
           withEvent: (UIEvent *)   event
{
    /* Called when a touch begins */
    [self.userGame touchesBegan:touches
                      withEvent:event];  
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

-(void) touchesEnded: (NSSet *)     touches
           withEvent: (UIEvent *)   event
{
    /* Called when a touch ends */
    
    for (UITouch *touch in touches) {
        if (self.popup) {
            SKNode* popup = [self.hud2popup childNodeWithName: @"popup"];
            NSArray *nodes = [popup nodesAtPoint:[touch locationInNode:popup]];
            for (SKNode *node in nodes) {
                // GET THE BUTTON
                if ([node.name isEqualToString:@"OK"]) {
                    self.userRestart = 1;
                    self.userPause = 1;
                    self.popup = [self.popup close];
                }
                // GET THE BUTTON
                if ([node.name isEqualToString:@"CANCEL"]) {
                    self.userRestart = 0;
                    self.userPause = 0;
                    self.popup = [self.popup close];
                }
                // GET THE BUTTON
                if ([node.name isEqualToString:@"EXIT"]) {
                    self.userRestart = 1;
                    self.userPause = 1;
                    self.popup = [self.popup close];
                    
                    [self showGameStart];
                }
            }
        }
        else {
            NSArray *nodes = [self nodesAtPoint:[touch locationInNode:self.hud2fg]];
            for (SKNode *node in nodes) {
                // GET THE BUTTON
                if ([node.name isEqualToString:@"bottom label"]) {
                    self.userPause = 1;
                    [self pausePopup];
                }
            }
        }
    }

}


-(void) pausePopup
{
    if (self.popup == nil) {
        self.popup =
        [SktPopup initWithName:@"popup"
                      showText:@"START A NEW GAME ?"
                        showOk:@"Restart"
                    showCancel:@"Back"
                      showExit:@"exit"
                       inScene:self
                    parentNode:self.hud2popup];
    }
    
}

-(void) touchesMoved: (NSSet *)     touches
           withEvent: (UIEvent *)   event
{
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self.world2fg];
        CGPoint curLoc = self.world2player.position;
        float dx = location.x - curLoc.x;
        float dy = location.y - curLoc.y;
        self.world2player.physicsBody.velocity = CGVectorMake(dx, dy);
        self.world2player.physicsBody.angularVelocity = 0;
        self.world2player.zRotation = atan2f(dy, dx);
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
    float dx = self.world2camera.position.x - self.world2player.position.x;
    float dy = self.world2camera.position.y - self.world2player.position.y;
    float d2 = dx*dx + dy*dy;
    // FIXME: how do we compute this threshold?
    // half of max screen size divided by scale ?
    float d2max = self.init2size.width*self.init2size.height * .5 / self.world2scale; // 5000000;
    
    if (d2 > d2max ) {
        // animate the camera
        SKAction *action = [SKAction moveTo:self.world2player.position duration: .5];
        [self.world2camera runAction:action];
    }
    [self centerOnNode: self.world2camera];

    // keep the world round or flat
    [self manageWorldLimit];
    
}

- (void) centerOnNode: (SKNode *) node
{
    CGPoint cameraPositionInScene = [node.scene convertPoint:node.position fromNode:node.parent];
    self.world.position = CGPointMake(self.world.position.x - cameraPositionInScene.x,
                                       self.world.position.y - cameraPositionInScene.y);
}


-(void) manageWorldLimit
{
    
    // loop on all elements and check position
    // warning: might be CPU consuming if too many elements
    for (SKNode* curN in [self.world2fg children]) {
        CGPoint curPos = curN.position;
        float curX = curPos.x;
        float curY = curPos.y;
        
        if (self.world2mode == 0) {
            // THE WORLD IS ROUND
            if (curX < self.world2min.x) {
                curX = self.world2min.x;
                curN.position = CGPointMake(self.world2max.x, curY);
            }
            else if (curX > self.world2max.x) {
                curX = self.world2max.x;
                curN.position = CGPointMake(self.world2min.x, curY);
            }
            
            if (curY < self.world2min.y) curN.position = CGPointMake(curX, self.world2max.y);
            else if (curY > self.world2max.y) curN.position = CGPointMake(curX, self.world2min.y);
            
        }
        else {
            // THE WORLD IS FLAT
            if (curX < self.world2min.x) {
                curX = self.world2min.x;
                curN.position = CGPointMake(self.world2min.x, curY);
            }
            else if (curX > self.world2max.x) {
                curX = self.world2max.x;
                curN.position = CGPointMake(self.world2max.x, curY);
            }

            if (curY < self.world2min.y) curN.position = CGPointMake(curX, self.world2min.y);
            else if (curY > self.world2max.y) curN.position = CGPointMake(curX, self.world2max.y);
            
        }
    }
}


- (void) didBeginContact: (SKPhysicsContact *) contact
{
    [self.userGame didBeginContact: contact];
}

@end
