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
    
    // SETUP SCENE WITH GAME DELEGATE
    self.game.scene = scene;
    self.game.game = self;
    
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

@end
