//
//  SktDemGame.m
//  SktDem001
//
//  Created by APPLH.COM on 13/01/2014.
//  Copyright (c) 2014 APPLH.COM. All rights reserved.
//

#import "SktSceneGame.h"

@implementation SktSceneGame

-(id) initWithSize: (CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0.05 green:0.05 blue:0.20 alpha:1.0];
        
        // create the parent nodes
        self.hud = [SKNode node];
        self.world = [SKNode node];
        
        self.anchorPoint = CGPointMake(.5, .5);
        self.world2scale = .1;

        // NO GRAVITY
        self.physicsWorld.gravity = CGVectorMake(0, 0);
        
        // add to the scene
        [self addChild:self.world];
        [self addChild:self.hud];
        
        // SETUP
        self.init2size = size;
        
        [self setupHud];
        [self setupWorld];

    }
    return self;
}

// CUSTOM
-(void) setupHud {
    SKNode* bg = [SKNode node];
    SKNode* fg = [SKNode node];
    [self.hud addChild:bg];
    [self.hud addChild:fg];
    
    self.hud2fg = fg;
    
    SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"AvenirNext-HeavyItalic"];
    
    myLabel.text = @"LEVEL 1";
    myLabel.fontSize = 50;
    myLabel.fontColor = [SKColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                   CGRectGetMidY(self.frame));
    
    [self.hud2fg addChild:myLabel];

}

-(void) setupWorld {
    
    self.player2vmax2scale = .025;
    
    // THE WORLD IS FLAT
    self.world2mode = 1;
    
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
    
    SKAction* scale = [SKAction scaleBy:self.world2scale duration:1];
    [self.world runAction:scale];
    
    
}

-(void) setupPlayer {
    
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

}

-(void) touchesBegan: (NSSet *) touches withEvent: (UIEvent *) event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self.world2fg];
    }
}

-(void) addRandomRobotAt:(CGPoint) location {
    SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship2"];
    
    sprite.position = location;
    
    float angle = arc4random_uniform(360) * M_PI / 180;
    float speed = 100;
    float dx = speed * cos(angle);
    float dy = speed * sin(angle);
    
    // warning: apply scaling also to physics body
    sprite.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:sprite.size.width*self.world2scale/2];
    sprite.physicsBody.dynamic = YES;
    sprite.physicsBody.velocity = CGVectorMake(dx,dy);
    
    SKAction *action = [SKAction rotateByAngle:angle duration:.5];
    [sprite runAction:action];
    
    [self.world2fg addChild:sprite];

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

- (void) update:(NSTimeInterval)currentTime {
    
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
    
    // add random robot
    float random = arc4random_uniform(100);
    float robot2random  = 2;
    if (random < robot2random) {
        float radius = arc4random_uniform(self.world2max.x);
        float theta = 2 * M_PI * arc4random_uniform(360) / 360;
        float x = radius * cos(theta);
        float y = radius * sin(theta);
        CGPoint newPos = CGPointMake(x,y);
        [self addRandomRobotAt:newPos];
    }
    
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

@end
