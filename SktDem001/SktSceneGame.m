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
    SKNode* bg = [SKNode node];
    SKNode* fg = [SKNode node];
    
    
    [self.world addChild:bg];
    [self.world addChild:fg];
    
    self.world2bg = bg;
    self.world2fg = fg;
    
    [self setupPlayer];
    
    SKNode *camera = [SKNode node];
    camera.name = @"camera";
    [self.world addChild:camera];
    self.world2camera = camera;
    self.world2camera.position = self.world2player.position;
    
    SKAction* scale = [SKAction scaleBy:self.world2scale duration:1];
    [self.world runAction:scale];
    
}

-(void) setupPlayer {
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
    
    SKAction *action = [SKAction rotateByAngle:angle duration:.5];
    [sprite runAction:action];
    
    [self.world2fg addChild:sprite];
    
    self.world2player = sprite;
    
}

-(void) touchesBegan: (NSSet *) touches withEvent: (UIEvent *) event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self.world2fg];
        
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship2"];
        
        sprite.position = location;
        
        float angle = arc4random_uniform(360)*M_PI/180;
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
}

- (void)didSimulatePhysics
{
    float dx = self.world2camera.position.x - self.world2player.position.x;
    float dy = self.world2camera.position.y - self.world2player.position.y;
    float d2 = dx*dx + dy*dy;
    // FIXME: how do we compute this threshold?
    // half of max screen size divided by scale ?
    float d2max = 1024*1024*10/2; // 5000000;
    
    if (d2 > d2max ) {
        // animate the camera
        SKAction *action = [SKAction moveTo:self.world2player.position duration:1];
        [self.world2camera runAction:action];
    }
    [self centerOnNode: self.world2camera];
}

- (void) centerOnNode: (SKNode *) node
{
    CGPoint cameraPositionInScene = [node.scene convertPoint:node.position fromNode:node.parent];
    self.world.position = CGPointMake(self.world.position.x - cameraPositionInScene.x,
                                       self.world.position.y - cameraPositionInScene.y);
}

@end
