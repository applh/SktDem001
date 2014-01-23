//
//  SktPopup.m
//  SktDem001
//
//  Created by APPLH.COM on 23/01/2014.
//  Copyright (c) 2014 APPLH.COM. All rights reserved.
//

#import "SktPopup.h"

@implementation SktPopup


+(id) initWithName:(NSString *) name
          showText:(NSString*)  text
            showOk:(NSString*)  textOk
        showCancel:(NSString*)  textCancel
           inScene:(SKScene *)  scene
        parentNode:(SKNode *)   parent
{
    SktPopup* res;
    
    res = [SktPopup new];
    if (res) {
        res.scene = scene;
        res.parentNode = parent;
        res.popupRootNode = [SKShapeNode new];
        res.popupRootNode.name = name;
        float w = 640;
        float h = 480;
        float x = -w/2;
        float y = -h/2;
        
        res.popupRootNode.path = CGPathCreateWithRoundedRect(CGRectMake(x, y, w, h), 20, 20, 0);
        
        res.popupRootNode.position = CGPointMake(CGRectGetMidX(res.parentNode.frame),
                                   CGRectGetMidY(res.parentNode.frame));
        
        
        SKLabelNode* label0 = [SKLabelNode new];
        label0.text = text;
        label0.name = @"text";
        label0.position = CGPointMake(0, +100);
        [res.popupRootNode addChild:label0];

        SKLabelNode* label1 = [SKLabelNode new];
        label1.text = textCancel;
        label1.name = @"CANCEL";
        label1.position = CGPointMake(-200, -100);
        [res.popupRootNode addChild:label1];

        SKLabelNode* label2 = [SKLabelNode new];
        label2.text = textOk;
        label2.name = @"OK";
        label2.position = CGPointMake(200, -100);
        [res.popupRootNode addChild:label2];
        
        [res.parentNode addChild:res.popupRootNode];
    }
    return res;
}

-(id) close
{
    SKAction* act1 = [SKAction fadeOutWithDuration:.25];
    SKAction* act2 = [SKAction removeFromParent];
    [self.popupRootNode runAction: [SKAction sequence:@[act1, act2]]];
    
    return nil;
}
@end
