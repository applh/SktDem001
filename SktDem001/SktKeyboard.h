//
//  SktKeyboard.h
//  SktDem001
//
//  Created by APPLH.COM on 25/01/2014.
//  Copyright (c) 2014 APPLH.COM. All rights reserved.
//

#import "SktPopup.h"

@class SKLabelNode;

@interface SktKeyboard : SktPopup

@property NSString*     curText;
@property SKLabelNode*  curLabel;

-(id) init;

+(id) initWithName: (NSString*)  name
        parentNode: (SKNode*)    parent;

-(void) processNode: (SKNode*) n;

-(void) processInput: (SKNode*) n;

@end
