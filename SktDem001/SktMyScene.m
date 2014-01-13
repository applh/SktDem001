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
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        
        myLabel.text = @"Hellix";
        myLabel.fontSize = 30;
        myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                       CGRectGetMidY(self.frame));
        
        [self addChild:myLabel];
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
