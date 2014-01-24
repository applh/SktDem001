//
//  SktGameInterface.h
//  SktDem001
//
//  Created by APPLH.COM on 24/01/2014.
//  Copyright (c) 2014 APPLH.COM. All rights reserved.
//

#import <Foundation/Foundation.h>

// FORWARD CLASS DECLARATION
@class SktSceneGame;
@class SktGame;

@protocol SktGameInterface <NSObject>
// ATTRIBUTES
@property SktSceneGame* scene;
@property SktGame* game;

// METHODS
@required
-(void) restartGame;

@required
-(void) setupHud;
@required
-(void) setupWorld;
@required
-(void) setupPlayer;
@required
-(void) updateHud;
@required
-(void) updateNextFrame:(NSTimeInterval)currentTime;

@required
-(void) touchesBegan: (NSSet *) touches withEvent: (UIEvent *) event;

@end
