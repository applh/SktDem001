//
//  SktPopup.m
//  SktDem001
//
//  Created by APPLH.COM on 23/01/2014.
//  Copyright (c) 2014 APPLH.COM. All rights reserved.
//

#import "SktPopup.h"

@implementation SktPopup

-(id) init
{
    if (self = [super init]) {
        
    }
    
    return self;
}


+(id) initWithName:(NSString *) name
          showText:(NSString*)  text
            showOk:(NSString*)  textOk
        showCancel:(NSString*)  textCancel
          showExit:(NSString*)  textExit
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
        float w = 480;
        float h = 480;
        float x = -w/2;
        float y = -h/2;
        float fontSize = 20;
        
        res.popupRootNode.path = CGPathCreateWithRoundedRect(CGRectMake(x, y, w, h), 20, 20, 0);
        
        res.popupRootNode.position = CGPointMake(CGRectGetMidX(res.parentNode.frame),
                                   CGRectGetMidY(res.parentNode.frame));
        
        res.popupRootNode.fillColor = [SKColor colorWithWhite:.5 alpha:.5];
        res.popupRootNode.lineWidth = 0.1;
        
        if (text) {
            SKLabelNode* label0 = [SKLabelNode new];
            label0.text = text;
            label0.name = @"text";
            label0.fontSize = fontSize;
            label0.position = CGPointMake(0, +100);
            [res.popupRootNode addChild:label0];
        }
        
        if (textCancel) {
            SKLabelNode* label1 = [SKLabelNode new];
            label1.text = textCancel;
            label1.name = @"CANCEL";
            label1.fontSize = fontSize;
            label1.position = CGPointMake(-100, -100);
            [res.popupRootNode addChild:label1];
        }

        if (textOk) {
            SKLabelNode* label2 = [SKLabelNode new];
            label2.text = textOk;
            label2.name = @"OK";
            label2.fontSize = fontSize;
            label2.position = CGPointMake(100, -100);
            [res.popupRootNode addChild:label2];
        }

        if (textExit) {
            SKLabelNode* label3 = [SKLabelNode new];
            label3.text = textExit;
            label3.name = @"EXIT";
            label3.fontSize = fontSize;
            label3.position = CGPointMake(0, -200);
            [res.popupRootNode addChild:label3];
        }

        [res.parentNode addChild:res.popupRootNode];
    }
    return res;
}

-(void) processNode: (SKNode*) n
{
    [self processInput:n];
}

-(void) processInput: (SKNode*) n
{
    NSLog(@"Popup");
}

-(id) close
{
    SKAction* act1 = [SKAction fadeOutWithDuration:.25];
    SKAction* act2 = [SKAction removeFromParent];
    [self.popupRootNode runAction: [SKAction sequence:@[act1, act2]]];
    
    return nil;
}
@end
