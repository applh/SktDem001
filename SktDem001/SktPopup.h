//
//  SktPopup.h
//  SktDem001
//
//  Created by APPLH.COM on 23/01/2014.
//  Copyright (c) 2014 APPLH.COM. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SktPopup : NSObject
@property SKScene*      scene;
@property SKNode*       parentNode;
@property SKShapeNode*  popupRootNode;

-(id) init;

+(id) initWithName:(NSString*)  name
          showText:(NSString*)  text
            showOk:(NSString*)  textOk
        showCancel:(NSString*)  textCancel
          showExit:(NSString*)  textExit
           inScene:(SKScene*)   scene
        parentNode:(SKNode*)    parent;

-(id) close;

@end
