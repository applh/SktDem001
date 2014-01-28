//
//  SktGame.m
//  SktDem001
//
//  Created by APPLH.COM on 24/01/2014.
//  Copyright (c) 2014 APPLH.COM. All rights reserved.
//

#import "SktGame.h"

#import "SktSceneGame.h"
#import "SktGameInterface.h"
#import "SktGameMapShoot.h"
#import "SktGameMapRpg.h"
#import "SktGameGravity.h"
#import "SktGameHappy.h"
#import "SktPopup.h"

@implementation SktGame

-(void) setupGame:(int) g
        withScene:(SktSceneGame*) scene
{
    self.scene = scene;
    
    self.userChoice = g;
    
    // CREATE DELEGATE DEPENDING ON USER CHOICE
    if (g == 1)  {
        self.game = [SktGameMapRpg new];
    }
    else if (g == 2)  {
        self.game = [SktGameMapShoot new];
    }
    else if (g == 3)  {
        self.game = [SktGameGravity new];
    }
    else if (g == 4)  {
        self.game = [SktGameHappy new];
    }
    
    // SETUP SCENE WITH GAME DELEGATE
    self.game.scene = scene;
    self.game.game = self;
    

}

-(BOOL) isLandscape
{
    // FIXME: LOOKS UGLY :-/
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    BOOL res = UIInterfaceOrientationIsLandscape(orientation);
    if (res) {
        self.sceneLandscape = 1;
    }
    else {
        self.sceneLandscape = 0;
    }
    return res;
}

-(void) restartGame
{
    [self.game restartGame];
}

-(void) setupHud
{
    [self.game setupHud];
}

-(void) setupWorld
{
    self.ccPlayer   =  0x1 << 0;
    self.ccOrb      =  0x1 << 1;
    self.ccRobot    =  0x1 << 2;
    self.ccBonus    =  0x1 << 3;
    self.ccRock     =  0x1 << 4;

    [self.game setupWorld];
}

-(void) setupPlayer
{
    [self.game setupPlayer];
}

-(void) updateHud
{
    [self.game updateHud];
}

-(BOOL) updateHudOrientation
{
    BOOL res = [self isLandscape];
    
    if (res) {
        self.scene.hud2top.position = CGPointMake(CGRectGetMidX(self.scene.frame),
                                                  CGRectGetMidY(self.scene.frame)
                                                  + 250);
        self.scene.hud2bottom.position = CGPointMake(CGRectGetMidX(self.scene.frame),
                                                     CGRectGetMidY(self.scene.frame)
                                                     - 250);
        //NSLog(@"LANDSCAPE %.0fx%.0f", self.scene.frame.size.width, self.scene.frame.size.height);
    }
    else {
        self.scene.hud2top.position = CGPointMake(CGRectGetMidX(self.scene.frame),
                                                  CGRectGetMidY(self.scene.frame)
                                                  + 450);
        self.scene.hud2bottom.position = CGPointMake(CGRectGetMidX(self.scene.frame),
                                                     CGRectGetMidY(self.scene.frame)
                                                     - 450);
        //NSLog(@"PORTRAIT %.0fx%.0f", self.scene.frame.size.width, self.scene.frame.size.height);
    }
    
    return res;
}


-(void) updateNextFrame: (NSTimeInterval) currentTime
{
    [self.game updateNextFrame:currentTime];
}

-(void) touchesBegan: (NSSet *) touches
           withEvent: (UIEvent *) event
{
    /* Called when a touch begins */
    [self.game touchesBegan:touches
                  withEvent:event];
}

-(void) touchesMoved: (NSSet *) touches
           withEvent: (UIEvent *) event
{
    /* Called when a touch begins */
    [self.game touchesMoved:touches
                  withEvent:event];
}

-(void) touchesEnded: (NSSet *) touches
           withEvent: (UIEvent *) event
{
    /* Called when a touch begins */
    [self.game touchesEnded:touches
                  withEvent:event];
    
    for (UITouch *touch in touches) {
        if (self.scene.popup) {
            SKNode* popup = [self.scene.hud2popup childNodeWithName: @"popup"];
            NSArray *nodes = [popup nodesAtPoint:[touch locationInNode:popup]];
            for (SKNode *node in nodes) {
                if (node) {
                    // GET THE BUTTON
                    if ([node.name isEqualToString:@"OK"]) {
                        self.scene.userRestart = 1;
                        self.scene.userPause = 1;
                        self.scene.popup = [self.scene.popup close];
                    }
                    // GET THE BUTTON
                    if ([node.name isEqualToString:@"CANCEL"]) {
                        self.scene.userRestart = 0;
                        self.scene.userPause = 0;
                        self.scene.popup = [self.scene.popup close];
                    }
                    // GET THE BUTTON
                    if ([node.name isEqualToString:@"EXIT"]) {
                        self.scene.userRestart = 1;
                        self.scene.userPause = 1;
                        self.scene.popup = [self.scene.popup close];
                        
                        [self.scene showGameStart];
                    }
                    
                    if (self.scene.popup && node) {
                        [self.scene.popup processNode:node];
                    }
                }
            }
        }
        else {
            NSArray *nodes = [self.scene nodesAtPoint:[touch locationInNode:self.scene.hud2fg]];
            for (SKNode *node in nodes) {
                // GET THE BUTTON
                if ([node.name isEqualToString:@"bottom label"]) {
                    self.scene.userPause = 1;
                    [self.scene pausePopup];
                }
                else if ([node.name isEqualToString:@"top label"]) {
                    self.scene.userPause = 1;
                    [self.scene keyboardPopup];
                }
            }
        }
    }

}

-(void) launchMissile: (SKNode*)        from
                 Time: (NSTimeInterval) currentTime
{
    // MISSILE FPS
    if ((currentTime - self.lastMissileT) < self.minMissileT)
        return;
    
    if (self.scene.playerEnergy < 1)
        return;
    
    self.lastMissileT = currentTime;
    
    // LAUNCH NEW MISSILE
    SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"orb-42x42"];
    
    float speed = 2;
    float dx = speed * from.physicsBody.velocity.dx;
    float dy = speed * from.physicsBody.velocity.dy;
    float angle = atan2f(dy, dx);
    
    sprite.position = CGPointMake(from.position.x + dx, from.position.y + dy) ;
    
    dx += cos(angle) * 2 * self.scene.player2vmax;
    dy += sin(angle) * 2 * self.scene.player2vmax;;
    
    
    // warning: apply scaling also to physics body
    sprite.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:sprite.size.width*self.scene.world2scale/2];
    sprite.physicsBody.dynamic = YES;
    sprite.physicsBody.velocity = CGVectorMake(dx,dy);
    sprite.physicsBody.angularVelocity = 0;
    sprite.physicsBody.linearDamping = 0;
    sprite.physicsBody.angularDamping = 0;
    sprite.physicsBody.restitution = 0.5;
    sprite.physicsBody.density = 50;   // HARD
    
    // CONTACT AND COLLISION
    sprite.physicsBody.categoryBitMask = self.ccOrb;
    sprite.physicsBody.contactTestBitMask = self.ccPlayer | self.ccRobot | self.ccBonus;
    
    SKAction *action0 = [SKAction waitForDuration:5];
    SKAction *action1 = [SKAction fadeOutWithDuration:.5];
    SKAction *action2 = [SKAction removeFromParent];
    [sprite runAction: [SKAction sequence: @[action0, action1, action2]]];
    
    [self.scene.world2fg addChild:sprite];
}

-(void) addRandomRobotAt: (CGPoint) location
{
    SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"disk-256x256"];
    
    sprite.position = location;
    
    float angle = arc4random_uniform(360) * M_PI / 180;
    float speed = 100;
    float dx = speed * cos(angle);
    float dy = speed * sin(angle);
    
    // warning: apply scaling also to physics body
    sprite.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:sprite.size.width*self.scene.world2scale/2];
    sprite.physicsBody.dynamic = YES;
    sprite.physicsBody.velocity = CGVectorMake(dx,dy);
    sprite.physicsBody.angularVelocity = 0;
    sprite.physicsBody.linearDamping = 0;
    sprite.physicsBody.angularDamping = 0;
    sprite.physicsBody.restitution = 0;
    
    // CONTACT AND COLLISION
    sprite.physicsBody.categoryBitMask = self.ccRobot;
    sprite.physicsBody.contactTestBitMask = self.ccPlayer | self.ccRobot | self.ccBonus;
    
    SKAction *action0 = [SKAction rotateByAngle:angle duration:.5];
    SKAction *action1 = [SKAction waitForDuration:500];
    SKAction *action2 = [SKAction fadeOutWithDuration:.5];
    SKAction *action3 = [SKAction removeFromParent];
    [sprite runAction: [SKAction sequence: @[action0, action1, action2, action3]]];
    
    [self.scene.world2fg addChild:sprite];
    
}

-(void) addRandomRockAt: (CGPoint) location
{
    NSString * spriteName = [NSString stringWithFormat:@"rock%d",
                             (int) (1+floor(sqrt(arc4random_uniform(9))))];
    SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:spriteName];
    
    sprite.position = location;
    
    float angle = arc4random_uniform(360) * M_PI / 180;
    float speed = 100;
    float dx = speed * cos(angle);
    float dy = speed * sin(angle);
    
    // warning: apply scaling also to physics body
    sprite.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:sprite.size.width*self.scene.world2scale/2];
    sprite.physicsBody.dynamic = YES;
    sprite.physicsBody.velocity = CGVectorMake(dx,dy);
    sprite.physicsBody.angularVelocity = 0;
    sprite.physicsBody.linearDamping = 0;
    sprite.physicsBody.angularDamping = 0;
    sprite.physicsBody.restitution = 0;
    sprite.physicsBody.density = 100;   // HARD
    
    // CONTACT AND COLLISION
    sprite.physicsBody.categoryBitMask = self.ccRock;
    sprite.physicsBody.contactTestBitMask = self.ccPlayer | self.ccRobot | self.ccBonus | self.ccRock;
    
    SKAction *action0 = [SKAction rotateByAngle:angle duration: arc4random_uniform(10)];
    SKAction *action1 = [SKAction waitForDuration:5000];
    SKAction *action2 = [SKAction fadeOutWithDuration:.5];
    SKAction *action3 = [SKAction removeFromParent];
    [sprite runAction: [SKAction sequence: @[action0, action1, action2, action3]]];
    
    [self.scene.world2fg addChild:sprite];
    
}


-(void) addRandomBonusAt: (CGPoint) location
{
    
    uint index = 1 + arc4random_uniform(3);
    NSString * gemName = [NSString stringWithFormat:@"gem%d", index];
    SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:gemName];
    
    sprite.position = location;
    
    float angle = arc4random_uniform(360) * M_PI / 180;
    float speed = 100;
    float dx = speed * cos(angle);
    float dy = speed * sin(angle);
    
    // warning: apply scaling also to physics body
    sprite.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:sprite.size.width*self.scene.world2scale/2];
    sprite.physicsBody.dynamic = YES;
    sprite.physicsBody.velocity = CGVectorMake(dx,dy);
    sprite.physicsBody.angularVelocity = 0;
    sprite.physicsBody.linearDamping = 0;
    sprite.physicsBody.angularDamping = 0;
    sprite.physicsBody.restitution = 0;
    
    // CONTACT AND COLLISION
    sprite.physicsBody.categoryBitMask = self.ccBonus;
    sprite.physicsBody.contactTestBitMask = self.ccPlayer | self.ccRobot | self.ccBonus;
    
    SKAction *action0 = [SKAction rotateByAngle:angle duration:.5];
    SKAction *action1 = [SKAction waitForDuration:600];
    SKAction *action2 = [SKAction fadeOutWithDuration:.5];
    SKAction *action3 = [SKAction removeFromParent];
    [sprite runAction: [SKAction sequence: @[action0, action1, action2, action3]]];
    
    [self.scene.world2fg addChild:sprite];
    
}

- (void) didBeginContact: (SKPhysicsContact *) contact
{
    SKPhysicsBody *firstBody, *secondBody;
    
    firstBody = contact.bodyA;
    secondBody = contact.bodyB;
    
    if (contact.bodyA.categoryBitMask > contact.bodyB.categoryBitMask) {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }
    
    if (firstBody.categoryBitMask == self.ccPlayer) {
        //NSLog(@"CONTACT/PLAYER");
        if (secondBody.categoryBitMask == self.ccBonus) {
            SKAction* act0 = [SKAction fadeOutWithDuration:.5];
            SKAction* act1 = [SKAction removeFromParent];
            
            [secondBody.node runAction:[SKAction sequence:@[act0, act1]]];
            
            // PARTICLE
            NSString * particlePath = [[NSBundle mainBundle] pathForResource:@"magic1" ofType:@"sks"];
            SKEmitterNode *emitter = [NSKeyedUnarchiver unarchiveObjectWithFile:particlePath];
            emitter.position = firstBody.node.position;
            
            SKAction* act2 = [SKAction waitForDuration:1+.1*arc4random_uniform(10)];
            SKAction* act3 = [SKAction removeFromParent];
            [emitter runAction:[SKAction sequence: @[act2, act3]]];
            
            [self.scene.world2fg addChild:emitter];
            
            // SCORE
            self.scene.playerScore += 10;
        }
        else if (secondBody.categoryBitMask == self.ccOrb) {
            // SCORE
            self.scene.playerEnergy -= 1;
        }
        else if (secondBody.categoryBitMask == self.ccRobot) {
            // SCORE
            self.scene.playerEnergy -= 1;
        }
        else if (secondBody.categoryBitMask == self.ccRock) {
            // SCORE
            self.scene.playerEnergy -= 1;
        }
    }
    else if (firstBody.categoryBitMask == self.ccOrb) {
        //NSLog(@"CONTACT/ORB");
        if (secondBody.categoryBitMask == self.ccRobot) {
            SKAction* act0 = [SKAction fadeOutWithDuration:.5];
            SKAction* act1 = [SKAction removeFromParent];
            
            [secondBody.node runAction:[SKAction sequence:@[act0, act1]]];
            
            // PARTICLE
            NSString * particlePath = [[NSBundle mainBundle] pathForResource:@"spark1" ofType:@"sks"];
            SKEmitterNode *emitter = [NSKeyedUnarchiver unarchiveObjectWithFile:particlePath];
            emitter.position = firstBody.node.position;
            
            SKAction* act2 = [SKAction waitForDuration:1+.1*arc4random_uniform(10)];
            SKAction* act3 = [SKAction removeFromParent];
            [emitter runAction:[SKAction sequence: @[act2, act3]]];
            
            [self.scene.world2fg addChild:emitter];
            
            // SCORE
            self.scene.playerScore += 1;
        }
        else if (secondBody.categoryBitMask == self.ccBonus) {
            SKAction* act0 = [SKAction fadeOutWithDuration:.5];
            SKAction* act1 = [SKAction removeFromParent];
            
            [secondBody.node runAction:[SKAction sequence:@[act0, act1]]];
            
            // PARTICLE
            NSString * particlePath = [[NSBundle mainBundle] pathForResource:@"flies1" ofType:@"sks"];
            SKEmitterNode *emitter = [NSKeyedUnarchiver unarchiveObjectWithFile:particlePath];
            emitter.position = firstBody.node.position;
            
            SKAction* act2 = [SKAction waitForDuration:1+.1*arc4random_uniform(10)];
            SKAction* act3 = [SKAction removeFromParent];
            [emitter runAction:[SKAction sequence: @[act2, act3]]];
            
            [self.scene.world2fg addChild:emitter];
            
            // SCORE
            self.scene.playerScore += 10;
        }
    }
    else if (firstBody.categoryBitMask == self.ccRock) {
        // PARTICLE
        NSString * particlePath = [[NSBundle mainBundle] pathForResource:@"fire1" ofType:@"sks"];
        SKEmitterNode *emitter = [NSKeyedUnarchiver unarchiveObjectWithFile:particlePath];
        emitter.position = firstBody.node.position;
        
        SKAction* act2 = [SKAction waitForDuration:1+.1*arc4random_uniform(10)];
        SKAction* act3 = [SKAction removeFromParent];
        [emitter runAction:[SKAction sequence: @[act2, act3]]];
        
        [self.scene.world2fg addChild:emitter];
    }
}


- (void) didSimulatePhysics
{
    float dx = self.scene.world2camera.position.x - self.scene.world2player.position.x;
    float dy = self.scene.world2camera.position.y - self.scene.world2player.position.y;
    float d2 = dx*dx + dy*dy;
    // FIXME: how do we compute this threshold?
    // half of max screen size divided by scale ?
    float d2max = self.scene.init2size.width
                    * self.scene.init2size.height
                    * .5
                    / self.scene.world2scale; // 5000000;
    
    if (d2 > d2max ) {
        // animate the camera
        SKAction *action = [SKAction moveTo:self.scene.world2player.position duration: .5];
        [self.scene.world2camera runAction:action];
    }
    [self.scene centerOnNode: self.scene.world2camera];
    
    // keep the world round or flat
    [self manageWorldLimit];
    
}

-(void) manageWorldLimit
{
    
    // loop on all elements and check position
    // warning: might be CPU consuming if too many elements
    for (SKNode* curN in [self.scene.world2fg children]) {
        CGPoint curPos = curN.position;
        float curX = curPos.x;
        float curY = curPos.y;
        
        if (self.scene.world2mode == 0) {
            // THE WORLD IS ROUND
            if (curX < self.scene.world2min.x) {
                curX = self.scene.world2min.x;
                curN.position = CGPointMake(self.scene.world2max.x, curY);
            }
            else if (curX > self.scene.world2max.x) {
                curX = self.scene.world2max.x;
                curN.position = CGPointMake(self.scene.world2min.x, curY);
            }
            
            if (curY < self.scene.world2min.y) curN.position = CGPointMake(curX, self.scene.world2max.y);
            else if (curY > self.scene.world2max.y) curN.position = CGPointMake(curX, self.scene.world2min.y);
            
        }
        else {
            // THE WORLD IS FLAT
            if (curX < self.scene.world2min.x) {
                curX = self.scene.world2min.x;
                curN.position = CGPointMake(self.scene.world2min.x, curY);
            }
            else if (curX > self.scene.world2max.x) {
                curX = self.scene.world2max.x;
                curN.position = CGPointMake(self.scene.world2max.x, curY);
            }
            
            if (curY < self.scene.world2min.y)
                curN.position = CGPointMake(curX, self.scene.world2min.y);
            else if (curY > self.scene.world2max.y)
                curN.position = CGPointMake(curX, self.scene.world2max.y);
            
        }
    }
}


@end
