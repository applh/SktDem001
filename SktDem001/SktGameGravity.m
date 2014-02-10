//
//  SktGameGravity.m
//  SktDem001
//
//  Created by APPLH.COM on 24/01/2014.
//  Copyright (c) 2014 APPLH.COM. All rights reserved.
//

#import "SktGameGravity.h"
#import "SktSceneGame.h"
#import "SktGame.h"
#import "SktPopup.h"

@implementation SktGameGravity

// ATTRIBUTES
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
    self.scene.world2scale = .25;
    self.scene.player2vmax2scale = self.scene.world2scale * (self.scene.world2scale + .25);
    
    // THE WORLD IS FLAT
    self.scene.world2mode = 1;
   
}

-(void) setupHud
{
    float fontSize1 = 30;
    NSString * fontName1 = @"Chalkduster";
    
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
    
    self.scene.hud2top.text = [NSString stringWithFormat:@"GRAVITY LEVEL %d - ENERGY %d",
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
    
    self.scene.world2min = CGPointMake(-sizeMax/self.scene.world2scale, -sizeMax/self.scene.world2scale);
    self.scene.world2max = CGPointMake(sizeMax/self.scene.world2scale, sizeMax/self.scene.world2scale);
    
    SKSpriteNode *sprite2bg = [SKSpriteNode spriteNodeWithColor: [UIColor colorWithWhite:.8
                                                                                   alpha:1]
                                                           size: CGSizeMake(sizeMax, sizeMax)];
    
    sprite2bg.size = CGSizeMake(self.scene.world2max.x - self.scene.world2min.x,
                                self.scene.world2max.y - self.scene.world2min.y);
    
    [self.scene.world2bg addChild:sprite2bg];
    
    [self.scene setupPlayer]; // player and camera
    
    SKAction* scale = [SKAction scaleTo:self.scene.world2scale duration:1];
    [self.scene.world runAction:scale];

}

-(SKShapeNode*) addPlayerPart: (NSString*)  name
                            x: (CGFloat)    xBody
                            y: (CGFloat)    yBody
                            w: (CGFloat)    wBody
                            h: (CGFloat)    hBody
                         fill: (SKColor*)   cFill
{
    // BODY
    SKShapeNode * shapeBody = [SKShapeNode new];
    CGMutablePathRef pathBody = CGPathCreateMutable();
    
    xBody -= wBody*.5;
    yBody -= hBody*.5;
    
    NSString* sBody = [NSString stringWithFormat:@"{{%.0f,%.0f},{%.0f,%.0f}}", xBody, yBody, wBody, hBody];
    NSLog(@"%@", sBody);
    
    CGPathAddEllipseInRect(pathBody, NULL, CGRectFromString(sBody));
    shapeBody.path=pathBody;
    shapeBody.lineWidth = 1.0;
    shapeBody.fillColor = cFill;
    shapeBody.strokeColor = [SKColor whiteColor];
    shapeBody.glowWidth = 0.5;

    return shapeBody;
}

-(void) setupPlayer
{
    self.scene.playerEnergy = 100;
    self.scene.playerScore = 0;
    
    // FIXME
    self.scene.player2vmax = self.scene.player2vmax2scale * self.scene.world2max.x;
    
    // COMPOSE PLAYER
    // BODY
    SKShapeNode* shapeBody = [self addPlayerPart: @"body"
                                               x: 0
                                               y: 0
                                               w: 90
                                               h: 100
                                            fill: [SKColor orangeColor]];
    // HEAD
    SKShapeNode* shapeHead = [self addPlayerPart: @"head"
                                               x: 0
                                               y: 0
                                               w: 50
                                               h: 60
                                            fill: [SKColor redColor]];
    // BELL
    SKShapeNode* shapeBell = [self addPlayerPart: @"bell"
                                               x: 0
                                               y: 0
                                               w: 60
                                               h: 60
                                            fill: [SKColor orangeColor]];

    // LEFT LEG
    SKShapeNode* shapeLegLeft = [self addPlayerPart: @"left leg"
                                               x: 0
                                               y: 0
                                               w: 40
                                               h: 120
                                            fill: [SKColor orangeColor]];
    // LEFT BOOT
    SKShapeNode* shapeBootLeft = [self addPlayerPart: @"left boot"
                                                  x: 0
                                                  y: 0
                                                  w: 30
                                                  h: 120
                                               fill: [SKColor orangeColor]];
    // RIGHT LEG
    SKShapeNode* shapeLegRight = [self addPlayerPart: @"right leg"
                                               x: 0
                                               y: 0
                                               w: 40
                                               h: 120
                                            fill: [SKColor orangeColor]];
    // RIGHT BOOT
    SKShapeNode* shapeBootRight = [self addPlayerPart: @"right boot"
                                                   x: 0
                                                   y: 0
                                                   w: 30
                                                   h: 120
                                                fill: [SKColor orangeColor]];

    // LEFT shoulder
    SKShapeNode* shapeShoulderLeft = [self addPlayerPart: @"left shoulder"
                                                  x: 0
                                                  y: 0
                                                  w: 30
                                                  h: 80
                                               fill: [SKColor orangeColor]];
    // LEFT arm
    SKShapeNode* shapeArmLeft = [self addPlayerPart: @"left arm"
                                                   x: 0
                                                   y: 0
                                                   w: 20
                                                   h: 80
                                                fill: [SKColor orangeColor]];
    // RIGHT shoulder
    SKShapeNode* shapeShoulderRight = [self addPlayerPart: @"right shoulder"
                                                   x: 0
                                                   y: 0
                                                   w: 30
                                                   h: 80
                                                fill: [SKColor orangeColor]];
    // RIGHT arm
    SKShapeNode* shapeArmRight = [self addPlayerPart: @"right arm"
                                                    x: 0
                                                    y: 0
                                                    w: 20
                                                    h: 80
                                                 fill: [SKColor orangeColor]];

    shapeBody.position = CGPointMake(CGRectGetMidX(self.scene.frame), CGRectGetMidY(self.scene.frame));
    
    shapeHead.position = CGPointMake(shapeBody.position.x,              shapeBody.position.y +90);
    shapeBell.position = CGPointMake(shapeBody.position.x,              shapeBody.position.y -65);
    
    shapeLegLeft.position = CGPointMake(shapeBody.position.x -25,           shapeBody.position.y -125);
    shapeBootLeft.position = CGPointMake(shapeBody.position.x -25,          shapeBody.position.y -230);
    shapeLegRight.position = CGPointMake(shapeBody.position.x +25,          shapeBody.position.y -125);
    shapeBootRight.position = CGPointMake(shapeBody.position.x +25,         shapeBody.position.y -230);

    shapeShoulderLeft.position = CGPointMake(shapeBody.position.x -50,      shapeBody.position.y +0);
    shapeArmLeft.position = CGPointMake(shapeBody.position.x -55,           shapeBody.position.y -75);
    shapeShoulderRight.position = CGPointMake(shapeBody.position.x +50,    shapeBody.position.y +0);
    shapeArmRight.position = CGPointMake(shapeBody.position.x +55,         shapeBody.position.y -75);

    SKNode* playerNode = [SKNode new];
    // BUILD PLAYER
    [playerNode addChild:shapeBody];
    [playerNode addChild:shapeHead];
    [playerNode addChild:shapeBell];
    [playerNode addChild:shapeLegLeft];
    [playerNode addChild:shapeLegRight];
    [playerNode addChild:shapeBootLeft];
    [playerNode addChild:shapeBootRight];
    [playerNode addChild:shapeShoulderLeft];
    [playerNode addChild:shapeShoulderRight];
    [playerNode addChild:shapeArmLeft];
    [playerNode addChild:shapeArmRight];
    
    // BREATHE
    SKAction* act1 = [SKAction scaleTo:1.2 duration:2];
    SKAction* act2 = [SKAction scaleTo:1.0 duration:2];
    SKAction* act3 = [SKAction sequence:@[act1, act2]];
    SKAction* act4 = [SKAction repeatActionForever:act3];
    
    [shapeBody runAction:act4 withKey:@"breathe"];

    // STANDUP
    SKAction* act5 = [SKAction rotateToAngle:0 duration:1 shortestUnitArc:TRUE];
    SKAction* act6 = [SKAction repeatActionForever:act5];
    [shapeBody runAction:act6 withKey:@"standup"];
    
    float angle = 0;
    float speed = 0;
    float dx = speed * cos(angle);
    float dy = speed * sin(angle);
    
    [self.scene.world2fg addChild:playerNode];
    self.scene.world2player = playerNode;

    // warning: apply scaling also to physics body
    playerNode.physicsBody =
        [SKPhysicsBody bodyWithCircleOfRadius: 200
                                                    * self.scene.world2scale / 2];
    
    playerNode.physicsBody.dynamic = YES;
    playerNode.physicsBody.velocity = CGVectorMake(0,0);
    playerNode.physicsBody.angularVelocity = 0;
    playerNode.physicsBody.linearDamping = 0;
    playerNode.physicsBody.angularDamping = 0;
    playerNode.physicsBody.restitution = 0.2;
    
    // CONTACT AND COLLISION
    playerNode.physicsBody.categoryBitMask = self.ccPlayer;
    playerNode.physicsBody.contactTestBitMask = self.ccPlayer | self.ccRobot | self.ccBonus | self.ccRock;
    
    
    // SETUP CAMERA
    SKNode *camera = [SKNode node];
    camera.name = @"camera";
    [self.scene.world addChild:camera];
    self.scene.world2camera = camera;
    self.scene.world2camera.position = self.scene.world2player.position;
    
    // SETUP MISSILE
    self.game.minMissileT = .5; // ONE MISSILE PER SECOND
    
}

-(void) updateNextFrame: (NSTimeInterval) currentTime
{
    // MAX SPEED
    float curV = hypot(self.scene.world2player.physicsBody.velocity.dx,
                       self.scene.world2player.physicsBody.velocity.dy);
    if (curV > self.scene.player2vmax) {
        self.scene.world2player.physicsBody.velocity =
        CGVectorMake(self.scene.player2vmax * cos(self.scene.world2player.zRotation),
                     self.scene.player2vmax * sin(self.scene.world2player.zRotation));
    }
    self.scene.world2player.physicsBody.angularVelocity = 0;
    self.scene.world2player.zRotation=0;
    
    // LAUNCH MISSILE
    //[self.game launchMissile:self.scene.world2player Time:currentTime];
    
    // KEEP FPS > 25
    if (self.scene.deltaUpdateT < .01) {
        
        float random = 0;
        
        // add random robot
        random = arc4random_uniform(10000);
        float rock2random  = 50;
        if (random < rock2random) {
            float radius = arc4random_uniform(self.scene.world2max.x);
            float theta = 2 * M_PI * arc4random_uniform(360) / 360;
            float x = radius * cos(theta);
            float y = radius * sin(theta);
            CGPoint newPos = CGPointMake(x,y);
            [self.game addRandomRockAt:newPos];
        }
        
        // add random robot
        random = arc4random_uniform(10000);
        float robot2random  = 300;
        if (random < robot2random) {
            float radius = arc4random_uniform(self.scene.world2max.x);
            float theta = 2 * M_PI * arc4random_uniform(360) / 360;
            float x = radius * cos(theta);
            float y = radius * sin(theta);
            CGPoint newPos = CGPointMake(x,y);
            [self.game addRandomRobotAt:newPos];
        }
        
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
        self.scene.world2player.zRotation = atan2f(dy, dx);
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

- (id) addRandomRobotAt: (CGPoint) location
{
    return nil;
}

- (id) addRandomRockAt: (CGPoint)  location;
{
    return nil;
}

- (id) addRandomBonusAt: (CGPoint)  location;
{
    return nil;
}

- (id) didBeginContact: (SKPhysicsContact *) contact;
{
    return nil;
}


@end
