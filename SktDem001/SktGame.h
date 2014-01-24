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

@interface SktGame : NSObject

@property int userChoice;

@property id <SktGameInterface> game;


-(void) setupGame:(int) g;

-(void) restartGame;

@end
