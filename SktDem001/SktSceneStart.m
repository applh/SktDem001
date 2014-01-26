//
//  SktSceneStart.m
//  SktDem001
//
//  Created by APPLH.COM on 16/01/2014.
//  Copyright (c) 2014 APPLH.COM. All rights reserved.
//

#import "SktSceneStart.h"
#import "SktSceneGame.h"

@implementation SktSceneStart

-(id) initWithSize: (CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        self.backgroundColor = [SKColor colorWithWhite:1.0 alpha:1.0];
        
        // USER HAS TO SELECT A GAME
        self.gameChoice = 0;
        
        if (self.gameChoice == 0) {
            [self showGameSelection];
        }
        else {
            // FIXME
            // CONFIGURE GAME SETTINGS
            [self showGameLoading];
        }

    }
    return self;
}

-(void) showGameLoading
{
    SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"AvenirNext-HeavyItalic"];
    
    myLabel.text = @"LOADING GAME";
    myLabel.fontSize = 60;
    myLabel.fontColor = [SKColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                   2 * CGRectGetMidY(self.frame));
    SKAction* action = [SKAction moveByX:0 y:-CGRectGetMidY(self.frame) duration:1];

    [myLabel runAction: action completion: ^{ [self showGameScene]; } ];
    [self addChild:myLabel];

   
}

-(void) showGameSelection
{
    SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"AvenirNext-HeavyItalic"];
    
    myLabel.text = @"SELECT YOUR GAME";
    myLabel.fontSize = 40;
    myLabel.fontColor = [SKColor colorWithWhite:0.0 alpha:1.0];
    myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                   2*CGRectGetMidY(self.frame));
    SKAction* action = [SKAction moveByX:0 y: -0.30 * CGRectGetMidY(self.frame) duration:.5];
    [myLabel runAction: action];
    [self addChild:myLabel];
    
    // CHOICE 1
    [self addChoice:@"adventure" inCode: @"adventure"];
    // CHOICE 2
    [self addChoice:@"arcade" inCode: @"arcade"];
    // CHOICE 3
    [self addChoice:@"gravity" inCode: @"gravity"];
    // CHOICE 4
    [self addChoice:@"happy" inCode: @"happy"];
    
}

-(void) addChoice: (NSString*) name inCode: (NSString*) code
{
    self.nbChoice++;

    SKLabelNode *choice = [SKLabelNode labelNodeWithFontNamed:@"AvenirNext-HeavyItalic"];
    
    choice.text = [NSString stringWithFormat:@"(%d)  %@", self.nbChoice, name];

    choice.name = code;
    choice.fontSize = 20;
    choice.fontColor = [ SKColor colorWithHue: arc4random_uniform(360) / 360.0
                                   saturation: 1.0
                                   brightness: 1.0
                                        alpha: 0.8 ];
    
    choice.position = CGPointMake(CGRectGetMidX(self.frame), -2*CGRectGetMidY(self.frame));
    SKAction* action = [SKAction moveByX: 0
                                       y: (((5 - self.nbChoice) * .3) +2) * CGRectGetMidY(self.frame)
                                duration: 1];
    [choice runAction: action];
    [self addChild:choice];

    
}

-(void) showGameScene
{
    // Create and configure the scene.
    SKView * skView = (SKView *)self.view;
    
    SktSceneGame * scene = [SktSceneGame sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // SET THE GAME CHOICE
    scene.userGameChoice = self.gameChoice;
    
    // ADD TRANSITION EFFECT
    SKTransition *doors = [SKTransition
                           flipHorizontalWithDuration:1.0];
    // Present the scene.
    [skView presentScene:scene transition:doors];
   
}

-(void) touchesBegan: (NSSet *) touches withEvent: (UIEvent *) event
{
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        NSArray *nodes = [self nodesAtPoint:[touch locationInNode:self]];
        for (SKNode *node in nodes) {
            // GET THE BUTTON
            if ([node.name isEqualToString:@"adventure"]) {
                self.gameChoice = 1;
            }
            else if ([node.name isEqualToString:@"arcade"]) {
                self.gameChoice = 2;
            }
            else if ([node.name isEqualToString:@"gravity"]) {
                self.gameChoice = 3;
            }
            else if ([node.name isEqualToString:@"happy"]) {
                self.gameChoice = 4;
            }
        }
        
    }
    
    if (self.gameChoice > 0) {
        // FIXME
        // CONFIGURE GAME SETTINGS
        [self showGameScene];
    }
    
}

@end
