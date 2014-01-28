//
//  SktMyScene.m
//  SktDem001
//
//  Created by APPLH.COM on 13/01/2014.
//  Copyright (c) 2014 APPLH.COM. All rights reserved.
//

#import "SktMyScene.h"
#import "SktSceneStart.h"

@implementation SktMyScene

-(id) initWithSize: (CGSize) size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [ SKColor colorWithHue: arc4random_uniform(360) / 360.0
                                           saturation: 1.0
                                           brightness: 0.8
                                                alpha: 1.0 ];
        
        self.anchorPoint = CGPointMake(.5, .5);

        SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"AvenirNext-HeavyItalic"];
        
        myLabel.text = @"hellios";
        myLabel.fontSize = 60;
        myLabel.fontColor = [SKColor colorWithWhite:1.0 alpha:1.0 ];

        SKLabelNode *myLabel2 = [SKLabelNode labelNodeWithFontNamed:@"AvenirNext-HeavyItalic"];
        
        myLabel2.text = @"touch to start";
        myLabel2.fontSize = 20;
        myLabel2.fontColor = [SKColor colorWithWhite: 1.0
                                               alpha: 1.0 ];

        myLabel.position = CGPointMake(CGRectGetMidX(self.frame), 2*CGRectGetMidY(self.frame));
        myLabel2.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMinY(self.frame));
        
        SKAction* action = [SKAction moveToY: CGRectGetMidY(self.frame)
                                    duration: 1];
        SKAction* action2 = [SKAction moveToY: CGRectGetMidY(self.frame) - (2 * myLabel2.fontSize)
                                     duration: 2];
        
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

    SktSceneStart * scene = [SktSceneStart sceneWithSize:skView.bounds.size];
//    scene.scaleMode = SKSceneScaleModeAspectFit;
    scene.scaleMode = SKSceneScaleModeResizeFill;

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
