//
//  SktMyScene.m
//  SktDem001
//
//  Created by APPLH.COM on 13/01/2014.
//  Copyright (c) 2014 APPLH.COM. All rights reserved.
//

#import "SktMyScene.h"
#import "SktSceneGame.h"

@implementation SktMyScene

-(id) initWithSize: (CGSize) size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:1.0 green:0.4 blue:0.0 alpha:1.0];
        
        SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"AvenirNext-HeavyItalic"];
        
        myLabel.text = @"HELLIX";
        myLabel.fontSize = 100;
        myLabel.fontColor = [SKColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                        2*CGRectGetMidY(self.frame));

        SKLabelNode *myLabel2 = [SKLabelNode labelNodeWithFontNamed:@"AvenirNext-HeavyItalic"];
        
        myLabel2.text = @"touch to start";
        myLabel2.fontSize = 30;
        myLabel2.fontColor = [SKColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];

        myLabel2.position = CGPointMake(CGRectGetMidX(self.frame), 0);
        SKAction* action = [SKAction moveByX:0 y:-CGRectGetMidY(self.frame) duration:1];
        SKAction* action2 = [SKAction moveByX:0 y:CGRectGetMidY(self.frame)/2 duration:2];
        
        [myLabel runAction: action];
        [myLabel2 runAction: action2];

        [self addChild:myLabel];
        [self addChild:myLabel2];
        
        
    }
    return self;
}

-(void) touchesBegan: (NSSet *) touches withEvent: (UIEvent *) event {
    /* Called when a touch begins */
    // Create and configure the scene.
    SKView * skView = (SKView *)self.view;

    SktSceneGame * scene = [SktSceneGame sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;

    // ADD TRANSITION EFFECT
    SKTransition *doors = [SKTransition
                           flipHorizontalWithDuration:1.0];
    // Present the scene.
    [skView presentScene:scene transition:doors];
   
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
