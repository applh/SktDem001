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
}

-(void) setupPlayer {
    SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
    
    sprite.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)) ;
    
    [self.world2fg addChild:sprite];
    
}

-(void) touchesBegan: (NSSet *) touches withEvent: (UIEvent *) event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship2"];
        
        sprite.position = location;
        
        SKAction *action = [SKAction rotateByAngle:M_PI duration:1];
        
        [sprite runAction:[SKAction repeatActionForever:action]];
        
        [self.world2fg addChild:sprite];
    }
}

@end
