//
//  SktGameMapRpg.m
//  SktDem001
//
//  Created by APPLH.COM on 24/01/2014.
//  Copyright (c) 2014 APPLH.COM. All rights reserved.
//

#import "SktGameMapRpg.h"
#import "SktSceneGame.h"
#import "SktGame.h"
#import "SktPopup.h"

@implementation SktGameMapRpg
@synthesize scene;
@synthesize game;

// METHODS
-(id) init
{
    if (self = [super init])  {
        
    }
    return self;    
}

-(void) restartGame
{
    // NO GRAVITY
    self.scene.physicsWorld.gravity = CGVectorMake(0, 0);

    // SCALE THE MAP
    self.scene.world2scale = 1;
    self.scene.player2vmax2scale = self.scene.world2scale * (self.scene.world2scale + .25);
    
    // THE WORLD IS FLAT
    self.scene.world2mode = 1;
    
}

-(void) setupHud
{
    float fontSize1 = 30;
    NSString * fontName1 = @"PartyLetPlain";
    
    SKNode* bg = [SKNode node];
    SKNode* fg = [SKNode node];
    SKNode* pop = [SKNode node];
    [self.scene.hud addChild:bg];
    [self.scene.hud addChild:fg];
    [self.scene.hud addChild:pop];
    
    self.scene.hud2bg = bg;
    self.scene.hud2fg = fg;
    self.scene.hud2popup = pop;
    
    SKLabelNode *myLabel;
    
    myLabel = [SKLabelNode labelNodeWithFontNamed:fontName1];
    myLabel.text = @"LEVEL 1";
    myLabel.fontSize = fontSize1;
    myLabel.fontColor = [SKColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    myLabel.position = CGPointMake(CGRectGetMidX(self.scene.frame),
                                   CGRectGetMaxY(self.scene.frame)-1.5*fontSize1);
    self.scene.hud2top = myLabel;
    [self.scene.hud2fg addChild:myLabel];
    
    myLabel = [SKLabelNode labelNodeWithFontNamed:fontName1];
    myLabel.text = @"LEVEL 1";
    myLabel.fontSize = 50;
    myLabel.fontColor = [SKColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    myLabel.position = CGPointMake(CGRectGetMidX(self.scene.frame),
                                   CGRectGetMidY(self.scene.frame));
    self.scene.hud2center = myLabel;
    [self.scene.hud2fg addChild:myLabel];
    
    myLabel = [SKLabelNode labelNodeWithFontNamed:fontName1];
    myLabel.text = @"LEVEL 1";
    myLabel.fontSize = fontSize1;
    myLabel.fontColor = [SKColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    myLabel.position = CGPointMake(CGRectGetMidX(self.scene.frame),
                                   CGRectGetMinY(self.scene.frame) + 1.0*fontSize1);
    myLabel.name = @"bottom label";
    self.scene.hud2bottom = myLabel;
    [self.scene.hud2fg addChild:myLabel];

}

-(void) updateHud
{    
    // SCORE
    if (self.scene.playerScore < 0) self.scene.playerScore = 0;
    // ENERGY
    if (self.scene.playerEnergy < 0) self.scene.playerEnergy = 0;
    
    if (self.scene.playerScore >= self.scene.playerScoreWin) {
        self.scene.hud2center.text = @"YOU WIN";
        self.scene.hud2center.fontColor = [SKColor colorWithRed:0 green:1 blue:0 alpha:1];
    }
    else if (self.scene.playerEnergy == 0) {
        self.scene.hud2center.text = @"GAME OVER";
        self.scene.hud2center.fontColor = [SKColor colorWithRed:1 green:0 blue:0 alpha:1];
    }
    else {
        self.scene.hud2center.text = @"";
    }
    
    self.scene.hud2top.text = [NSString stringWithFormat:@"ADVENTURE LEVEL %d - ENERGY %d",
                               self.scene.playerLevel,
                               self.scene.playerEnergy];
    
    self.scene.hud2bottom.text = [NSString stringWithFormat:@"SCORE %d/%d",
                                  self.scene.playerScore,
                                  self.scene.playerScoreWin];
}

-(void) setupWorld
{
    self.ccPlayer   =  0x1 << 0;
    self.ccOrb      =  0x1 << 1;
    self.ccRobot    =  0x1 << 2;
    self.ccBonus    =  0x1 << 3;
    self.ccRock     =  0x1 << 4;
    
    SKAction* scale0 = [SKAction scaleTo:1 duration:0];
    [self.scene.world runAction:scale0];
    
    SKNode* bg = [SKNode node];
    SKNode* fg = [SKNode node];
    
    [self.scene.world addChild:bg];
    [self.scene.world addChild:fg];
    
    self.scene.world2bg = bg;
    self.scene.world2fg = fg;
    
    // build the world limits depending on screen resolution
    float sizeMax = self.scene.init2size.width;
    if (sizeMax < self.scene.init2size.height) sizeMax = self.scene.init2size.height;
    
    // make the world 8x8 tiles of 1024x1024
    sizeMax = 2 * sizeMax;
    
    self.scene.world2min = CGPointMake(-sizeMax/self.scene.world2scale, -sizeMax/self.scene.world2scale);
    self.scene.world2max = CGPointMake(sizeMax/self.scene.world2scale, sizeMax/self.scene.world2scale);
    
    SKTexture * bgTexture = [SKTexture textureWithImageNamed: @"rpg-bg-4"];
    bgTexture.usesMipmaps = YES;
    SKSpriteNode *sprite2bg = [SKSpriteNode spriteNodeWithTexture: bgTexture];
    
    sprite2bg.size = CGSizeMake(self.scene.world2max.x - self.scene.world2min.x,
                                self.scene.world2max.y - self.scene.world2min.y);
    
    [self.scene.world2bg addChild:sprite2bg];
    
    // FIXME
    [self setupLevel]; // buildings and monster

    [self.scene setupPlayer]; // player and camera
    
    SKAction* scale = [SKAction scaleTo:self.scene.world2scale duration:1];
    [self.scene.world runAction:scale];

}

- (void) setupLevel
{
    // add random rock
    int rmax = 5;
    
    rmax = 5;
    for (int r =0; r<rmax; r++)  {
        float radius = arc4random_uniform(self.scene.world2max.x);
        float theta = 2 * M_PI * arc4random_uniform(360) / 360;
        float x = radius * cos(theta);
        float y = radius * sin(theta);
        CGPoint newPos = CGPointMake(x,y);
        [self.game addRandomRockAt:newPos];
    }

    rmax = 10;
    for (int r =0; r<rmax; r++)  {
        float radius = arc4random_uniform(self.scene.world2max.x);
        float theta = 2 * M_PI * arc4random_uniform(360) / 360;
        float x = radius * cos(theta);
        float y = radius * sin(theta);
        CGPoint newPos = CGPointMake(x,y);
        [self.game addRandomRobotAt:newPos];
    }
    

}


- (void) setupPlayer
{
    self.scene.playerEnergy = 100;
    self.scene.playerScore = 0;
    
    // FIXME
    self.scene.player2vmax = self.scene.player2vmax2scale * self.scene.world2max.x;
        
    uint hero = arc4random_uniform(8);
    NSString* heroFile = [NSString stringWithFormat: @"1-%d", hero];
    SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed: heroFile];
    
    sprite.position = CGPointMake(CGRectGetMidX(self.scene.frame),
                                  CGRectGetMidY(self.scene.frame)) ;
    
    float angle = arc4random()%360*M_PI/180;
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
    sprite.physicsBody.categoryBitMask = self.ccPlayer;
    sprite.physicsBody.contactTestBitMask = self.ccPlayer | self.ccRobot | self.ccBonus | self.ccRock;
    
    //SKAction *action = [SKAction scaleTo:1.0 duration:1];
    //[sprite runAction:action];
    
    NSArray* tabTextures45 = @[
                                [SKTexture textureWithImageNamed:@"45-0"],
                                [SKTexture textureWithImageNamed:@"45-1"],
                                [SKTexture textureWithImageNamed:@"45-2"],
                                [SKTexture textureWithImageNamed:@"45-3"],
                                [SKTexture textureWithImageNamed:@"45-4"],
                                [SKTexture textureWithImageNamed:@"45-6"],
                                [SKTexture textureWithImageNamed:@"45-7"],
                                ];
    
    self.animation45 = [SKAction animateWithTextures: tabTextures45
                                         timePerFrame: 0.1];
    self.animation45 = [SKAction repeatActionForever: self.animation45];

    NSArray* tabTextures135 = @[
                               [SKTexture textureWithImageNamed:@"135-0"],
                               [SKTexture textureWithImageNamed:@"135-1"],
                               [SKTexture textureWithImageNamed:@"135-2"],
                               [SKTexture textureWithImageNamed:@"135-3"],
                               [SKTexture textureWithImageNamed:@"135-4"],
                               [SKTexture textureWithImageNamed:@"135-6"],
                               [SKTexture textureWithImageNamed:@"135-7"],
                               ];
    
    self.animation135 = [SKAction animateWithTextures: tabTextures135
                                        timePerFrame: 0.1];
    self.animation135 = [SKAction repeatActionForever: self.animation135];
    
    NSArray* tabTextures225 = @[
                                [SKTexture textureWithImageNamed:@"225-0"],
                                [SKTexture textureWithImageNamed:@"225-1"],
                                [SKTexture textureWithImageNamed:@"225-2"],
                                [SKTexture textureWithImageNamed:@"225-3"],
                                [SKTexture textureWithImageNamed:@"225-4"],
                                [SKTexture textureWithImageNamed:@"225-6"],
                                [SKTexture textureWithImageNamed:@"225-7"],
                                ];
    
    self.animation225 = [SKAction animateWithTextures: tabTextures225
                                         timePerFrame: 0.1];
    self.animation225 = [SKAction repeatActionForever: self.animation225];

    NSArray* tabTextures315 = @[
                                [SKTexture textureWithImageNamed:@"315-0"],
                                [SKTexture textureWithImageNamed:@"315-1"],
                                [SKTexture textureWithImageNamed:@"315-2"],
                                [SKTexture textureWithImageNamed:@"315-3"],
                                [SKTexture textureWithImageNamed:@"315-4"],
                                [SKTexture textureWithImageNamed:@"315-6"],
                                [SKTexture textureWithImageNamed:@"315-7"],
                                ];
    
    self.animation315 = [SKAction animateWithTextures: tabTextures315
                                         timePerFrame: 0.1];
    self.animation315 = [SKAction repeatActionForever: self.animation315];
    
    // ANIMATE
    [sprite runAction:self.animation225 withKey: @"animation"];
    self.playerCurAnimation = 225;
    
    [self.scene.world2fg addChild:sprite];
    
    self.scene.world2player = sprite;
    
    // SETUP CAMERA
    SKNode *camera = [SKNode node];
    camera.name = @"camera";
    [self.scene.world addChild:camera];
    self.scene.world2camera = camera;
    self.scene.world2camera.position = self.scene.world2player.position;
    
    // SETUP MISSILE
    self.game.minMissileT = .5; // ONE MISSILE PER SECOND
    
}

-(void) updateNextFrame:(NSTimeInterval)currentTime
{
    // MAX SPEED
    float curV = hypot(self.scene.world2player.physicsBody.velocity.dx,
                       self.scene.world2player.physicsBody.velocity.dy);
    if (curV > self.scene.player2vmax) {
        self.scene.world2player.physicsBody.velocity =
        CGVectorMake(self.scene.player2vmax * cos(self.scene.world2player.zRotation),
                     self.scene.player2vmax * sin(self.scene.world2player.zRotation));
        self.scene.world2player.physicsBody.angularVelocity = 0;
    }
    // KEEP THE PLAYER STRAIGHT
    self.scene.world2player.zRotation =0;

    // UPDATE PLAYER ANIMATION FOLLOWING DIRECTION
    float nextAnimation;
    if (self.scene.world2player.physicsBody.velocity.dx > 0) {
        if (self.scene.world2player.physicsBody.velocity.dy > 0) {
            nextAnimation = 45;
            if (nextAnimation != self.playerCurAnimation) {
                [self.scene.world2player runAction: self.animation45
                                           withKey: @"animation"];
                self.playerCurAnimation = nextAnimation;
            }
        }
        else {
            nextAnimation = 315;
            if (nextAnimation != self.playerCurAnimation) {
                [self.scene.world2player runAction: self.animation315
                                           withKey: @"animation"];
                self.playerCurAnimation = nextAnimation;
            }
        }
    }
    else {
        if (self.scene.world2player.physicsBody.velocity.dy > 0) {
            nextAnimation = 135;
            if (nextAnimation != self.playerCurAnimation) {
                [self.scene.world2player runAction: self.animation135
                                           withKey: @"animation"];
                self.playerCurAnimation = nextAnimation;
            }
        }
        else {
            nextAnimation = 225;
            if (nextAnimation != self.playerCurAnimation) {
                [self.scene.world2player runAction: self.animation225
                                           withKey: @"animation"];
                self.playerCurAnimation = nextAnimation;
            }
        }
    }

    // LAUNCH MISSILE
    //[self.scene launchMissile:self.scene.world2player Time:currentTime];
    
    // KEEP FPS > 25
    if (self.scene.deltaUpdateT < .04) {
        
        float random = 0;
        
        // add random bonus
        random = arc4random_uniform(10000);
        float bonus2random  = 20;
        if (random < bonus2random) {
            float radius = arc4random_uniform(self.scene.world2max.x);
            float theta = 2 * M_PI * arc4random_uniform(360) / 360;
            float x = radius * cos(theta);
            float y = radius * sin(theta);
            CGPoint newPos = CGPointMake(x,y);
            [self.game addRandomBonusAt:newPos];
        }
        
    }
    else {
        //NSLog(@"WARNING/FPS/delta/%.2f ms", 1000*self.deltaUpdateT);
    }
    
    
}

-(void) touchesBegan: (NSSet *)     touches
           withEvent: (UIEvent *)   event
{
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self.scene.world2fg];
        CGPoint curLoc = self.scene.world2player.position;
        float dx = location.x - curLoc.x;
        float dy = location.y - curLoc.y;
        self.scene.world2player.physicsBody.velocity = CGVectorMake(dx, dy);
        self.scene.world2player.physicsBody.angularVelocity = 0;
        //self.scene.world2player.zRotation = atan2f(dy, dx);
    }
}

-(void) touchesMoved: (NSSet *)     touches
           withEvent: (UIEvent *)   event
{
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self.scene.world2fg];
        CGPoint curLoc = self.scene.world2player.position;
        float dx = location.x - curLoc.x;
        float dy = location.y - curLoc.y;
        self.scene.world2player.physicsBody.velocity = CGVectorMake(dx, dy);
        self.scene.world2player.physicsBody.angularVelocity = 0;
        self.scene.world2player.zRotation = atan2f(dy, dx);
    }
}

-(void) touchesEnded: (NSSet *)     touches
           withEvent: (UIEvent *)   event
{
    /* Called when a touch ends */
    
    for (UITouch *touch in touches) {
        if (self.scene.popup) {
            SKNode* popup = [self.scene.hud2popup childNodeWithName: @"popup"];
            NSArray *nodes = [popup nodesAtPoint:[touch locationInNode:popup]];
            for (SKNode *node in nodes) {
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
            }
        }
    }
    
}

-(id) addRandomRobotAt: (CGPoint) location
{
    uint r = 1+ arc4random_uniform(22);
    NSString* spriteFile = [NSString stringWithFormat: @"rpg-bot-%d", r];
    SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:spriteFile];
    
    sprite.position = location;
    
    float angle = arc4random_uniform(360) * M_PI / 180;
    float speed = 100;
    float dx = speed * cos(angle);
    float dy = speed * sin(angle);
    
    float customScale = .5;
    
    // warning: apply scaling also to physics body
    sprite.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:
                            customScale * sprite.size.width * self.scene.world2scale/2];
    
    sprite.physicsBody.dynamic = YES;
    sprite.physicsBody.velocity = CGVectorMake(dx,dy);
    sprite.physicsBody.angularVelocity = 0;
    sprite.physicsBody.linearDamping = 0;
    sprite.physicsBody.angularDamping = 0;
    sprite.physicsBody.restitution = 0;
    
    // CONTACT AND COLLISION
    sprite.physicsBody.categoryBitMask = self.ccRobot;
    sprite.physicsBody.contactTestBitMask = self.ccPlayer | self.ccRobot | self.ccBonus;
    
    SKAction *action1 = [SKAction waitForDuration:600];
    SKAction *action2 = [SKAction fadeOutWithDuration:.5];
    SKAction *action3 = [SKAction removeFromParent];
    
    [sprite runAction: [SKAction sequence: @[action1, action2, action3]]
              withKey: @"lifetime"];

    SKAction *action4 = [SKAction repeatActionForever: [SKAction rotateToAngle: 0
                                                                      duration: 1
                                                               shortestUnitArc: YES]];
    [sprite runAction: action4
              withKey: @"rotation0"];

    SKAction *scale = [SKAction scaleTo: customScale
                                duration: 0];
    
    [sprite runAction:scale withKey:@"scale"];

    [self.scene.world2fg addChild:sprite];
    
    return self;
}

- (id) addRandomRockAt: (CGPoint) location
{
    NSString * spriteName = [NSString stringWithFormat:@"rock%d",
                             (int) (1+floor(sqrt(arc4random_uniform(9))))];
    SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:spriteName];
    
    sprite.position = location;
    
    float angle = arc4random_uniform(360) * M_PI / 180;
    float speed = 0;
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
    
    SKAction *action0 = [SKAction rotateByAngle:angle duration:0];
    SKAction *action1 = [SKAction waitForDuration:600];
    SKAction *action2 = [SKAction fadeOutWithDuration:.5];
    SKAction *action3 = [SKAction removeFromParent];
    [sprite runAction: [SKAction sequence: @[action0, action1, action2, action3]]];
    
    [self.scene.world2fg addChild:sprite];
    
    return self;
}

- (id) didBeginContact: (SKPhysicsContact *) contact
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
    
    // NO ROTATION
    firstBody.angularVelocity = 0;
    secondBody.angularVelocity = 0;
    
    return self;
}


- (id) addRandomBonusAt: (CGPoint)  location;
{
    return nil;
}


@end
