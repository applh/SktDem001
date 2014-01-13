//
//  SktDemGame.h
//  SktDem001
//
//  Created by APPLH.COM on 13/01/2014.
//  Copyright (c) 2014 APPLH.COM. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SktSceneGame : SKScene

// OVERRIDE
-(id) initWithSize: (CGSize) size;
-(void)touchesBegan: (NSSet *) touches withEvent: (UIEvent *) event;

@end
