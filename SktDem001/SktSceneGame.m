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

@implementation SktSceneGame

-(id) initWithSize: (CGSize)size {
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
    self.playerWinner = 0;
    self.playerLevel = 1;
    // SCORE TO WIN
    self.playerScoreWin = 100;
    
    [self setupHud];
    [self setupNewGame];
}

-(void) setupNewGame
{
    if (self.userGameChoice == 0) {
        // SCALE THE MAP
        self.world2scale = .2;
        self.player2vmax2scale = self.world2scale * (self.world2scale + .25);
        
        // THE WORLD IS ROUND
        self.world2mode = 0;
    }
    else if (self.userGameChoice == 1) {
        // SCALE THE MAP
        self.world2scale = .2;
        self.player2vmax2scale = self.world2scale * (self.world2scale + .25);
        
        // THE WORLD IS ROUND
        self.world2mode = 0;
    }
    else if (self.userGameChoice == 2) {
        // SCALE THE MAP
        self.world2scale = .1;
        self.player2vmax2scale = self.world2scale * (self.world2scale + .25);
        
        // THE WORLD IS ROUND
        self.world2mode = 0;
    }
    else if (self.userGameChoice == 3) {
        // SCALE THE MAP
        self.world2scale = .05;
        self.player2vmax2scale = self.world2scale * (self.world2scale + .25);
        
        // THE WORLD IS ROUND
        self.world2mode = 0;
    }
    
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
    
    float fontSize1 = 30;
    
    SKNode* bg = [SKNode node];
    SKNode* fg = [SKNode node];
    SKNode* pop = [SKNode node];
    [self.hud addChild:bg];
    [self.hud addChild:fg];
    [self.hud addChild:pop];
    
    self.hud2bg = bg;
    self.hud2fg = fg;
    self.hud2popup = pop;
    
    SKLabelNode *myLabel;
    
    myLabel = [SKLabelNode labelNodeWithFontNamed:@"AvenirNext-HeavyItalic"];
    myLabel.text = @"LEVEL 1";
    myLabel.fontSize = fontSize1;
    myLabel.fontColor = [SKColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                   CGRectGetMaxY(self.frame)-1.5*fontSize1);
    self.hud2top = myLabel;
    [self.hud2fg addChild:myLabel];

    myLabel = [SKLabelNode labelNodeWithFontNamed:@"AvenirNext-HeavyItalic"];
    myLabel.text = @"LEVEL 1";
    myLabel.fontSize = 50;
    myLabel.fontColor = [SKColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                   CGRectGetMidY(self.frame));
    self.hud2center = myLabel;
    [self.hud2fg addChild:myLabel];

    myLabel = [SKLabelNode labelNodeWithFontNamed:@"AvenirNext-HeavyItalic"];
    myLabel.text = @"LEVEL 1";
    myLabel.fontSize = fontSize1;
    myLabel.fontColor = [SKColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                   CGRectGetMinY(self.frame) + 1.0*fontSize1);
    myLabel.name = @"bottom label";
    self.hud2bottom = myLabel;
    [self.hud2fg addChild:myLabel];

}

-(void) setupWorld {
    
    self.ccPlayer   =  0x1 << 0;
    self.ccOrb      =  0x1 << 1;
    self.ccRobot    =  0x1 << 2;
    self.ccBonus    =  0x1 << 3;
    self.ccRock     =  0x1 << 4;

    
    SKAction* scale0 = [SKAction scaleTo:1 duration:0];
    [self.world runAction:scale0];

    SKNode* bg = [SKNode node];
    SKNode* fg = [SKNode node];
    
    [self.world addChild:bg];
    [self.world addChild:fg];
    
    self.world2bg = bg;
    self.world2fg = fg;
    
    // build the world limits depending on screen resolution
    float sizeMax = self.init2size.width;
    if (sizeMax < self.init2size.height) sizeMax = self.init2size.height;
    
    self.world2min = CGPointMake(-sizeMax/self.world2scale, -sizeMax/self.world2scale);
    self.world2max = CGPointMake(sizeMax/self.world2scale, sizeMax/self.world2scale);
    
    //NSLog(@"MIN: %.2f,%.2f", self.world2min.x, self.world2min.y);
    //NSLog(@"MAX: %.2f,%.2f", self.world2max.x, self.world2max.y);
    
    SKSpriteNode *sprite2bg = [SKSpriteNode spriteNodeWithTexture:
                               [SKTexture textureWithImageNamed: @"world-bg-512"]];
    sprite2bg.size = CGSizeMake(self.world2max.x - self.world2min.x,
                                self.world2max.y - self.world2min.y);
    
    [self.world2bg addChild:sprite2bg];
    
    [self setupPlayer]; // player and camera
    
    SKAction* scale = [SKAction scaleTo:self.world2scale duration:1];
    [self.world runAction:scale];
    
    
}

-(void) setupPlayer {
    
    self.playerEnergy = 100;
    self.playerScore = 0;
    
    // FIXME
    self.player2vmax = self.player2vmax2scale * self.world2max.x;
    
    SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
    
    sprite.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)) ;
    
    float angle = arc4random()%360*M_PI/180;
    float speed = 100;
    float dx = speed * cos(angle);
    float dy = speed * sin(angle);
    
    // warning: apply scaling also to physics body
    sprite.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:sprite.size.width*self.world2scale/2];
    sprite.physicsBody.dynamic = YES;
    sprite.physicsBody.velocity = CGVectorMake(dx,dy);
    sprite.physicsBody.angularVelocity = 0;
    sprite.physicsBody.linearDamping = 0;
    sprite.physicsBody.angularDamping = 0;
    sprite.physicsBody.restitution = 0;

    // CONTACT AND COLLISION
    sprite.physicsBody.categoryBitMask = self.ccPlayer;
    sprite.physicsBody.contactTestBitMask = self.ccPlayer | self.ccRobot | self.ccBonus | self.ccRock;
    
    SKAction *action = [SKAction rotateByAngle:angle duration:.5];
    [sprite runAction:action];
    
    [self.world2fg addChild:sprite];
    
    self.world2player = sprite;

    // SETUP CAMERA
    SKNode *camera = [SKNode node];
    camera.name = @"camera";
    [self.world addChild:camera];
    self.world2camera = camera;
    self.world2camera.position = self.world2player.position;
    
    // SETUP MISSILE
    self.minMissileT = .5; // ONE MISSILE PER SECOND

}

-(void) touchesBegan: (NSSet *) touches withEvent: (UIEvent *) event {
    /* Called when a touch begins */
    
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

-(void) launchMissile:(SKNode*) from Time: (NSTimeInterval) currentTime
{
    // MISSILE FPS
    if ((currentTime - self.lastMissileT) < self.minMissileT)
        return;
    if (self.playerEnergy < 1)
        return;
    
    self.lastMissileT = currentTime;
    
    // LAUNCH NEW MISSILE
    SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"orb-42x42"];
    
    
    float speed = 2;
    float dx = speed * from.physicsBody.velocity.dx;
    float dy = speed * from.physicsBody.velocity.dy;
    float angle = atan2f(dy, dx);

    sprite.position = CGPointMake(from.position.x + dx, from.position.y + dy) ;

    dx += cos(angle) * 2 * self.player2vmax;
    dy += sin(angle) * 2 * self.player2vmax;;

    
    // warning: apply scaling also to physics body
    sprite.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:sprite.size.width*self.world2scale/2];
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
    
    [self.world2fg addChild:sprite];
}

-(void) addRandomRobotAt:(CGPoint) location {
    SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"disk-256x256"];
    
    sprite.position = location;
    
    float angle = arc4random_uniform(360) * M_PI / 180;
    float speed = 100;
    float dx = speed * cos(angle);
    float dy = speed * sin(angle);
    
    // warning: apply scaling also to physics body
    sprite.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:sprite.size.width*self.world2scale/2];
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
    
    [self.world2fg addChild:sprite];

}

-(void) addRandomRockAt:(CGPoint) location {
    NSString * spriteName = [NSString stringWithFormat:@"rock%d",
                             (int) (1+floor(sqrt(arc4random_uniform(9))))];
    SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:spriteName];
    
    sprite.position = location;
    
    float angle = arc4random_uniform(360) * M_PI / 180;
    float speed = 100;
    float dx = speed * cos(angle);
    float dy = speed * sin(angle);
    
    // warning: apply scaling also to physics body
    sprite.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:sprite.size.width*self.world2scale/2];
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
    
    [self.world2fg addChild:sprite];
    
}


-(void) addRandomBonusAt:(CGPoint) location {
    
    uint index = 1 + arc4random_uniform(3);
    NSString * gemName = [NSString stringWithFormat:@"gem%d", index];
    SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:gemName];
    
    sprite.position = location;
    
    float angle = arc4random_uniform(360) * M_PI / 180;
    float speed = 100;
    float dx = speed * cos(angle);
    float dy = speed * sin(angle);
    
    // warning: apply scaling also to physics body
    sprite.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:sprite.size.width*self.world2scale/2];
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
    
    [self.world2fg addChild:sprite];
    
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

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
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

-(void) touchesMoved: (NSSet *) touches withEvent: (UIEvent *) event {
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

-(void) updateNextFrame:(NSTimeInterval)currentTime {
    if (self.userPause > 0) return;
    
    // UPDATE FPS COMPUTING
    self.lastUpdateT = self.curUpdateT;
    self.curUpdateT = currentTime;
    self.deltaUpdateT = self.curUpdateT - self.lastUpdateT;
    
    // MAX SPEED
    float curV = hypot(self.world2player.physicsBody.velocity.dx,
                       self.world2player.physicsBody.velocity.dy);
    if (curV > self.player2vmax) {
        //NSLog(@"%.2f", curV);
        
        self.world2player.physicsBody.velocity =
        CGVectorMake(self.player2vmax * cos(self.world2player.zRotation),
                     self.player2vmax * sin(self.world2player.zRotation));
        self.world2player.physicsBody.angularVelocity = 0;
    }
    
    // LAUNCH MISSILE
    [self launchMissile:self.world2player Time:currentTime];
    
    // KEEP FPS > 25
    if (self.deltaUpdateT < .04) {
        
        float random = 0;
        
        // add random robot
        random = arc4random_uniform(10000);
        float rock2random  = 50;
        if (random < rock2random) {
            float radius = arc4random_uniform(self.world2max.x);
            float theta = 2 * M_PI * arc4random_uniform(360) / 360;
            float x = radius * cos(theta);
            float y = radius * sin(theta);
            CGPoint newPos = CGPointMake(x,y);
            [self addRandomRockAt:newPos];
        }
        
        // add random robot
        random = arc4random_uniform(10000);
        float robot2random  = 300;
        if (random < robot2random) {
            float radius = arc4random_uniform(self.world2max.x);
            float theta = 2 * M_PI * arc4random_uniform(360) / 360;
            float x = radius * cos(theta);
            float y = radius * sin(theta);
            CGPoint newPos = CGPointMake(x,y);
            [self addRandomRobotAt:newPos];
        }
        
        // add random bonus
        random = arc4random_uniform(10000);
        float bonus2random  = 20;
        if (random < bonus2random) {
            float radius = arc4random_uniform(self.world2max.x);
            float theta = 2 * M_PI * arc4random_uniform(360) / 360;
            float x = radius * cos(theta);
            float y = radius * sin(theta);
            CGPoint newPos = CGPointMake(x,y);
            [self addRandomBonusAt:newPos];
        }
        
    }
    else {
        //NSLog(@"WARNING/FPS/delta/%.2f ms", 1000*self.deltaUpdateT);
    }
    

}


-(void) updateHud
{
    // SCORE
    if (self.playerScore < 0) self.playerScore = 0;
    // ENERGY
    if (self.playerEnergy < 0) self.playerEnergy = 0;

    if (self.playerScore >= self.playerScoreWin) {
        self.hud2center.text = @"YOU WIN";
        self.hud2center.fontColor = [SKColor colorWithRed:0 green:1 blue:0 alpha:1];
    }
    else if (self.playerEnergy == 0) {
        self.hud2center.text = @"GAME OVER";
        self.hud2center.fontColor = [SKColor colorWithRed:1 green:0 blue:0 alpha:1];
    }
    else {
        self.hud2center.text = @"";
    }

    self.hud2top.text = [NSString stringWithFormat:@"LEVEL %d - ENERGY %d",
                                self.playerLevel,
                                self.playerEnergy];
    
    self.hud2bottom.text = [NSString stringWithFormat:@"SCORE %d/%d",
                                self.playerScore,
                                self.playerScoreWin];
}

- (void) update:(NSTimeInterval)currentTime {
    
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
        //NSLog(@"%.2f, %.2f", self.world2player.position.x, self.world2player.position.y);
        // animate the camera
        SKAction *action = [SKAction moveTo:self.world2player.position duration: .5];
        [self.world2camera runAction:action];
    }
    [self centerOnNode: self.world2camera];

    // keep the world round
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


- (void) didBeginContact:(SKPhysicsContact *)contact
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
            
            [self.world2fg addChild:emitter];

            // SCORE
            self.playerScore += 10;
        }
        else if (secondBody.categoryBitMask == self.ccOrb) {
            // SCORE
            self.playerEnergy -= 1;
        }
        else if (secondBody.categoryBitMask == self.ccRobot) {
            // SCORE
            self.playerEnergy -= 1;
        }
        else if (secondBody.categoryBitMask == self.ccRock) {
            // SCORE
            self.playerEnergy -= 1;
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
            
            [self.world2fg addChild:emitter];
            
            // SCORE
            self.playerScore += 1;
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
            
            [self.world2fg addChild:emitter];

            // SCORE
            self.playerScore += 10;
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
        
        [self.world2fg addChild:emitter];
    }
}

@end
