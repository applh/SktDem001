//
//  SktGameInterface.h
//  SktDem001
//
//  Created by APPLH.COM on 24/01/2014.
//  Copyright (c) 2014 APPLH.COM. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SktSceneGame;

@protocol SktGameInterface <NSObject>
// ATTRIBUTES
@property SktSceneGame* scene;

// METHODS
@required
-(void) restartGame;


@end
