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


-(SKShapeNode*) addPlayerPartV2: (NSString*)  name
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
    
    //CGPathAddEllipseInRect(pathBody, NULL, CGRectFromString(sBody));
    CGPathAddRoundedRect(pathBody, NULL, CGRectFromString(sBody), 10, 10);
    shapeBody.path=pathBody;
    shapeBody.lineWidth = 1.0;
    shapeBody.fillColor = cFill;
    shapeBody.strokeColor = [SKColor whiteColor];
    shapeBody.glowWidth = 0.0;
    shapeBody.name= name;
    
    return shapeBody;
}

-(SKNode*) buildPlayerPartsV2: (NSString*) name
                  bodyColor: (SKColor*) bColor
                  headColor: (SKColor*) hColor
{
    SKNode* res;
    SKNode* playerNode = [SKNode new];
    CGPoint botCenter = CGPointMake(CGRectGetMidX(self.scene.frame), CGRectGetMidY(self.scene.frame));
    
    // COMPOSE PLAYER
    // HEAD
    SKShapeNode* shapeHead = [self addPlayerPartV2: @"center head r0"
                                                 x: 0
                                                 y: 0
                                                 w: 100
                                                 h: 100
                                              fill: bColor];
    shapeHead.position = CGPointMake(botCenter.x, botCenter.y+200);
    [playerNode addChild:shapeHead];

    // SHOULDERS
    SKShapeNode* shapeShoulders = [self addPlayerPartV2: @"center shoulders r0"
                                                      x: 0
                                                      y: 0
                                                      w: 100
                                                      h: 100
                                                   fill: bColor];
    shapeShoulders.position = CGPointMake(botCenter.x, botCenter.y+100);
    [playerNode addChild:shapeShoulders];

    // BODY
    SKShapeNode* shapeBody = [self addPlayerPartV2: @"center body r0"
                                                 x: 0
                                                 y: 0
                                                 w: 200
                                                 h: 200
                                              fill: bColor];
    shapeBody.position = botCenter;
    [playerNode addChild:shapeBody];

    // LEGS
    SKShapeNode* shapeLegLeft = [self addPlayerPartV2: @"leg left r1"
                                                    x: 0
                                                    y: 0
                                                    w: 100
                                                    h: 100
                                                 fill: bColor];
    shapeLegLeft.position = CGPointMake(botCenter.x-50, botCenter.y-100);
    [playerNode addChild:shapeLegLeft];

    SKShapeNode* shapeLegRight = [self addPlayerPartV2: @"leg right r1"
                                                    x: 0
                                                    y: 0
                                                    w: 100
                                                    h: 100
                                                 fill: bColor];
    shapeLegRight.position = CGPointMake(botCenter.x+50, botCenter.y-100);
    [playerNode addChild:shapeLegRight];

    // FOOT
    SKShapeNode* shapeFeetLeft = [self addPlayerPartV2: @"feet left r2"
                                                    x: 0
                                                    y: 0
                                                    w: 100
                                                    h: 100
                                                 fill: bColor];
    shapeFeetLeft.position = CGPointMake(botCenter.x-50, botCenter.y-200);
    [playerNode addChild:shapeFeetLeft];
    
    SKShapeNode* shapeFeetRight = [self addPlayerPartV2: @"feet right r2"
                                                     x: 0
                                                     y: 0
                                                     w: 100
                                                     h: 100
                                                  fill: bColor];
    shapeFeetRight.position = CGPointMake(botCenter.x+50, botCenter.y-200);
    [playerNode addChild:shapeFeetRight];

    // SHOE
    SKShapeNode* shapeShoeLeft = [self addPlayerPartV2: @"shoe left r3"
                                                     x: 0
                                                     y: 0
                                                     w: 100
                                                     h: 100
                                                  fill: bColor];
    shapeShoeLeft.position = CGPointMake(botCenter.x-50, botCenter.y-300);
    [playerNode addChild:shapeShoeLeft];
    
    SKShapeNode* shapeShoeRight = [self addPlayerPartV2: @"shoe right r3"
                                                      x: 0
                                                      y: 0
                                                      w: 100
                                                      h: 100
                                                   fill: bColor];
    shapeShoeRight.position = CGPointMake(botCenter.x+50, botCenter.y-300);
    [playerNode addChild:shapeShoeRight];

    // HANDS
    SKShapeNode* shapeHandLeft = [self addPlayerPartV2: @"hand left r2"
                                                    x: 0
                                                    y: 0
                                                    w: 100
                                                    h: 100
                                                 fill: bColor];
    shapeHandLeft.position = CGPointMake(botCenter.x-150, botCenter.y+50);
    [playerNode addChild:shapeHandLeft];
    
    SKShapeNode* shapeHandRight = [self addPlayerPartV2: @"hand right r2"
                                                     x: 0
                                                     y: 0
                                                     w: 100
                                                     h: 100
                                                  fill: bColor];
    shapeHandRight.position = CGPointMake(botCenter.x+150, botCenter.y+50);
    [playerNode addChild:shapeHandRight];

    // ARMS
    SKShapeNode* shapeArmLeft = [self addPlayerPartV2: @"arm left r1"
                                                    x: 0
                                                    y: 0
                                                    w: 100
                                                    h: 100
                                                 fill: bColor];
    shapeArmLeft.position = CGPointMake(botCenter.x-100, botCenter.y+75);
    [playerNode addChild:shapeArmLeft];
    
    SKShapeNode* shapeArmRight = [self addPlayerPartV2: @"arm right r1"
                                                     x: 0
                                                     y: 0
                                                     w: 100
                                                     h: 100
                                                  fill: bColor];
    shapeArmRight.position = CGPointMake(botCenter.x+100, botCenter.y+75);
    [playerNode addChild:shapeArmRight];

    // TOOLS
    SKShapeNode* shapeToolLeft = [self addPlayerPartV2: @"tool left r3"
                                                     x: 0
                                                     y: 0
                                                     w: 100
                                                     h: 100
                                                  fill: bColor];
    shapeToolLeft.position = CGPointMake(botCenter.x-150, botCenter.y-50);
    [playerNode addChild:shapeToolLeft];
    
    SKShapeNode* shapeToolRight = [self addPlayerPartV2: @"tool right r3"
                                                      x: 0
                                                      y: 0
                                                      w: 100
                                                      h: 100
                                                   fill: bColor];
    shapeToolRight.position = CGPointMake(botCenter.x+150, botCenter.y-50);
    [playerNode addChild:shapeToolRight];

    // ANIMATION
    SKAction * act1 = [SKAction moveBy:CGVectorMake(50, 0) duration:1];
    SKAction * act2 = [SKAction moveBy:CGVectorMake(-50, 0) duration:1];
    SKAction * act3 = [SKAction moveBy:CGVectorMake(150, 0) duration:1];
    SKAction * act4 = [SKAction moveBy:CGVectorMake(-150, 0) duration:1];

    self.animationMoveMLL3 = [SKAction  repeatActionForever: [SKAction  sequence:@[act1, act2]]];
    self.animationMoveMLR3 = [SKAction  repeatActionForever: [SKAction  sequence:@[act2, act1]]];
    self.animationMoveMUL3 = [SKAction  repeatActionForever: [SKAction  sequence:@[act3, act4]]];
    self.animationMoveMUR3 = [SKAction  repeatActionForever: [SKAction  sequence:@[act4, act3]]];
    
    [shapeLegLeft runAction:self.animationMoveMLL3 withKey:@"move"];
    [shapeFeetLeft runAction:self.animationMoveMLL3 withKey:@"move"];
    [shapeShoeLeft runAction:self.animationMoveMLL3 withKey:@"move"];

    [shapeLegRight runAction:self.animationMoveMLR3 withKey:@"move"];
    [shapeFeetRight runAction:self.animationMoveMLR3 withKey:@"move"];
    [shapeShoeRight runAction:self.animationMoveMLR3 withKey:@"move"];

    [shapeArmLeft runAction:self.animationMoveMUL3 withKey:@"move"];
    [shapeHandLeft runAction:self.animationMoveMUL3 withKey:@"move"];
    [shapeToolLeft runAction:self.animationMoveMUL3 withKey:@"move"];

    shapeArmLeft.speed = 1.0;
    shapeHandLeft.speed = 1.0;
    shapeToolLeft.speed = 1.0;
    
    [shapeArmRight runAction:self.animationMoveMUR3 withKey:@"move"];
    [shapeHandRight runAction:self.animationMoveMUR3 withKey:@"move"];
    [shapeToolRight runAction:self.animationMoveMUR3 withKey:@"move"];

    shapeArmRight.speed = 1.0;
    shapeHandRight.speed = 1.0;
    shapeToolRight.speed = 1.0;

    res = playerNode;
    return res;
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
    
    CGPathAddEllipseInRect(pathBody, NULL, CGRectFromString(sBody));
    shapeBody.path=pathBody;
    shapeBody.lineWidth = 1.0;
    shapeBody.fillColor = cFill;
    shapeBody.strokeColor = [SKColor whiteColor];
    shapeBody.glowWidth = 0.0;
    
    return shapeBody;
}

-(SKNode*) buildPlayerParts: (NSString*) name
                  bodyColor: (SKColor*) bColor
                  headColor: (SKColor*) hColor
{
    // COMPOSE PLAYER
    // BODY
    SKShapeNode* shapeBody = [self addPlayerPart: @"body"
                                               x: 0
                                               y: 0
                                               w: 90
                                               h: 100
                                            fill: bColor];
    // HEAD
    SKShapeNode* shapeHead = [self addPlayerPart: @"head"
                                               x: 0
                                               y: 0
                                               w: 50
                                               h: 60
                                            fill: hColor];
    // BELL
    SKShapeNode* shapeBell = [self addPlayerPart: @"bell"
                                               x: 0
                                               y: 0
                                               w: 60
                                               h: 60
                                            fill: bColor];
    
    // LEFT LEG
    SKShapeNode* shapeLegLeft = [self addPlayerPart: @"left leg"
                                                  x: 0
                                                  y: 0
                                                  w: 40
                                                  h: 120
                                               fill: bColor];
    // LEFT BOOT
    SKShapeNode* shapeBootLeft = [self addPlayerPart: @"left boot"
                                                   x: 0
                                                   y: 0
                                                   w: 30
                                                   h: 120
                                                fill: bColor];
    // RIGHT LEG
    SKShapeNode* shapeLegRight = [self addPlayerPart: @"right leg"
                                                   x: 0
                                                   y: 0
                                                   w: 40
                                                   h: 120
                                                fill: bColor];
    // RIGHT BOOT
    SKShapeNode* shapeBootRight = [self addPlayerPart: @"right boot"
                                                    x: 0
                                                    y: 0
                                                    w: 30
                                                    h: 120
                                                 fill: bColor];
    
    // LEFT shoulder
    SKShapeNode* shapeShoulderLeft = [self addPlayerPart: @"left shoulder"
                                                       x: 0
                                                       y: 0
                                                       w: 30
                                                       h: 80
                                                    fill: bColor];
    // LEFT arm
    SKShapeNode* shapeArmLeft = [self addPlayerPart: @"left arm"
                                                  x: 0
                                                  y: 0
                                                  w: 20
                                                  h: 80
                                               fill: bColor];
    // RIGHT shoulder
    SKShapeNode* shapeShoulderRight = [self addPlayerPart: @"right shoulder"
                                                        x: 0
                                                        y: 0
                                                        w: 30
                                                        h: 80
                                                     fill: bColor];
    // RIGHT arm
    SKShapeNode* shapeArmRight = [self addPlayerPart: @"right arm"
                                                   x: 0
                                                   y: 0
                                                   w: 20
                                                   h: 80
                                                fill: bColor];
    
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
//    SKAction* act1 = [SKAction scaleTo:1.2 duration:2];
//    SKAction* act2 = [SKAction scaleTo:1.0 duration:2];
//    SKAction* act3 = [SKAction sequence:@[act1, act2]];
//    SKAction* act4 = [SKAction repeatActionForever:act3];
    
    //[shapeBody runAction:act4 withKey:@"breathe"];
    
    // STANDUP
    SKAction* act5 = [SKAction rotateToAngle:0 duration:2 shortestUnitArc:TRUE];
    SKAction* act6 = [SKAction repeatActionForever:act5];
    //[shapeBody runAction:act6 withKey:@"standup"];

    SKTexture* texture = [self.scene.view textureFromNode:playerNode];
    SKSpriteNode* sprite = [SKSpriteNode spriteNodeWithTexture:texture];
    [sprite runAction:act6 withKey:@"standup"];
    
    SKNode* res;
    res = sprite;
    
    //res = playerNode;
    
    return res;
    
}

-(void) setupPlayer
{
    self.scene.playerEnergy = 100;
    self.scene.playerScore = 0;
    
    // FIXME
    self.scene.player2vmax = self.scene.player2vmax2scale * self.scene.world2max.x;
    
    SKColor* bColor=[SKColor orangeColor];
    SKColor* hColor=[SKColor redColor];
    SKNode* playerNode = [self buildPlayerPartsV2: @"player"
                                        bodyColor: bColor
                                        headColor: hColor];
    
//    float angle = 0;
//    float speed = 0;
//    float dx = speed * cos(angle);
//    float dy = speed * sin(angle);
    
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

-(void) updatePerspective25
{
    // 2.5D perspective
    // objects at the top are further than objects at the bottom
    NSArray* tabFG = [self.scene.world2fg children];
    for (SKNode* curN in tabFG) {
        curN.zPosition = 10000-curN.position.y;
    }

}

-(void) updatePerspectivePlayer
{
    SKNode * curBot = self.scene.world2player;
    
    CGFloat curZ = curBot.zPosition;
    CGFloat curDx = curBot.physicsBody.velocity.dx;
    CGFloat curDy = curBot.physicsBody.velocity.dy;

    if (curDx < 0) {
        curBot.speed = 1.0;
        // MOVING WEST
        for (SKNode* mNode in [curBot children]) {
            NSRange mSide = [mNode.name rangeOfString:@"left"];
            if (mSide.length > 0) {
                mNode.zPosition = curZ-1;
                mSide = [mNode.name rangeOfString:@"r1"];
                if (mSide.length > 0) {
                    mNode.zPosition = curZ-2;
                }
                mSide = [mNode.name rangeOfString:@"r2"];
                if (mSide.length > 0) {
                    mNode.zPosition = curZ-3;
                }
                mSide = [mNode.name rangeOfString:@"r3"];
                if (mSide.length > 0) {
                    mNode.zPosition = curZ-4;
                }
            }
            mSide = [mNode.name rangeOfString:@"right"];
            if (mSide.length > 0) {
                mNode.zPosition = curZ+1;
                mSide = [mNode.name rangeOfString:@"r1"];
                if (mSide.length > 0) {
                    mNode.zPosition = curZ+2;
                }
                mSide = [mNode.name rangeOfString:@"r2"];
                if (mSide.length > 0) {
                    mNode.zPosition = curZ+3;
                }
                mSide = [mNode.name rangeOfString:@"r3"];
                if (mSide.length > 0) {
                    mNode.zPosition = curZ+4;
                }
            }
            mSide = [mNode.name rangeOfString:@"center"];
            if (mSide.length > 0) {
                mNode.zPosition = curZ;
            }
        }
    }
    else if (curDx > 0) {
        curBot.speed = 1.0;
        // MOVING EST
        for (SKNode* mNode in [curBot children]) {
            NSRange mSide = [mNode.name rangeOfString:@"left"];
            if (mSide.length > 0) {
                mNode.zPosition = curZ+1;
                mSide = [mNode.name rangeOfString:@"r1"];
                if (mSide.length > 0) {
                    mNode.zPosition = curZ+2;
                }
                mSide = [mNode.name rangeOfString:@"r2"];
                if (mSide.length > 0) {
                    mNode.zPosition = curZ+3;
                }
                mSide = [mNode.name rangeOfString:@"r3"];
                if (mSide.length > 0) {
                    mNode.zPosition = curZ+4;
                }
            }
            mSide = [mNode.name rangeOfString:@"right"];
            if (mSide.length > 0) {
                mNode.zPosition = curZ-1;
                mSide = [mNode.name rangeOfString:@"r1"];
                if (mSide.length > 0) {
                    mNode.zPosition = curZ-2;
                }
                mSide = [mNode.name rangeOfString:@"r2"];
                if (mSide.length > 0) {
                    mNode.zPosition = curZ-3;
                }
                mSide = [mNode.name rangeOfString:@"r3"];
                if (mSide.length > 0) {
                    mNode.zPosition = curZ-4;
                }
            }
            mSide = [mNode.name rangeOfString:@"center"];
            if (mSide.length > 0) {
                mNode.zPosition = curZ;
            }
        }
        
    }
    else {
        // MOVING NORTH OR SOUTH
    }
    
    if ((curDx == 0) && (curDy == 0)) {
        // STAND BY
        //actMove = [curBot actionForKey:@"move"];
        curBot.speed = 0.0;
    }

    float curV = hypot(self.scene.world2player.physicsBody.velocity.dx,
                       self.scene.world2player.physicsBody.velocity.dy);
    curBot.speed = 2.0f * curV / self.scene.player2vmax;
}

-(void) updateNextFrame: (NSTimeInterval) currentTime
{
    [self updatePerspective25];
    [self updatePerspectivePlayer];
    
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
    if (self.scene.deltaUpdateT < .04) {
        
        float random = 0;
        
        // add random rock
        random = arc4random_uniform(10000);
        float rock2random  = 50;
        if (random < rock2random) {
//            float radius = arc4random_uniform(self.scene.world2max.x);
//            float theta = 2 * M_PI * arc4random_uniform(360) / 360;
//            float x = radius * cos(theta);
//            float y = radius * sin(theta);
//            CGPoint newPos = CGPointMake(x,y);
            //[self.game addRandomRockAt:newPos];
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
//            float radius = arc4random_uniform(self.scene.world2max.x);
//            float theta = 2 * M_PI * arc4random_uniform(360) / 360;
//            float x = radius * cos(theta);
//            float y = radius * sin(theta);
//            CGPoint newPos = CGPointMake(x,y);
            //[self.game addRandomBonusAt:newPos];
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
    float hue1 = arc4random_uniform(360)/360.0f;
    float sat1 = 0.5f + arc4random_uniform(180)/360.0f;
    float bright1 = 0.5f + arc4random_uniform(180)/360.0f;
    float alpha1 = 1.0f;
    
    SKColor* bColor=[SKColor colorWithHue: hue1
                               saturation: sat1
                               brightness: bright1
                                    alpha: alpha1];

    float hue2 = arc4random_uniform(360)/360.0f;
    float sat2 = 0.5f + arc4random_uniform(180)/360.0f;
    float bright2 = 0.5f + arc4random_uniform(180)/360.0f;
    float alpha2 = 1.0f;
    
    SKColor* hColor=[SKColor colorWithHue: hue2
                               saturation: sat2
                               brightness: bright2
                                    alpha: alpha2];

    SKNode* robotNode = [self buildPlayerParts: @"player"
                                     bodyColor: bColor
                                     headColor: hColor];
    robotNode.position = location;
    // warning: apply scaling also to physics body
    robotNode.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:200*self.scene.world2scale/2];
    robotNode.physicsBody.dynamic = YES;
    robotNode.physicsBody.velocity = CGVectorMake(0, 0);
    robotNode.physicsBody.angularVelocity = 0;
    robotNode.physicsBody.linearDamping = 0;
    robotNode.physicsBody.angularDamping = 0;
    robotNode.physicsBody.restitution = 0;
    
    // CONTACT AND COLLISION
    robotNode.physicsBody.categoryBitMask = self.ccBonus;
    robotNode.physicsBody.contactTestBitMask = self.ccPlayer | self.ccRobot | self.ccBonus;
    
    [self.scene.world2fg addChild:robotNode];
    
    return robotNode;
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
