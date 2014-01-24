//
//  SktGame.h
//  SktDem001
//
//  Created by APPLH.COM on 24/01/2014.
//  Copyright (c) 2014 APPLH.COM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SktGameInterface.h"

// DECLARATION FORWARD
@class SktSceneGame;

@interface SktGame : NSObject

// ATTRIBUTES
@property SktSceneGame*         scene;
@property int                   userChoice;
@property id <SktGameInterface> game;


// METHODS
-(void) setupGame:(int) g
        withScene:(SktSceneGame*) scene;

-(void) restartGame;
-(void) setupHud;
-(void) setupWorld;

@end
