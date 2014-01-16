//
//  SktSceneStart.h
//  SktDem001
//
//  Created by APPLH.COM on 16/01/2014.
//  Copyright (c) 2014 APPLH.COM. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SktSceneStart : SKScene
@property int gameChoice;   // 0 = USER CHOICE FOR GAME
@property int nbChoice;     // nb of games choice

// OVERRIDE
-(void) touchesBegan: (NSSet *) touches withEvent: (UIEvent *) event;


// CUSTOM
-(void) showGameSelection;
-(void) showGameScene;

@end
