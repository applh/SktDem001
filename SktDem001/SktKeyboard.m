//
//  SktKeyboard.m
//  SktDem001
//
//  Created by APPLH.COM on 25/01/2014.
//  Copyright (c) 2014 APPLH.COM. All rights reserved.
//

#import "SktKeyboard.h"

@implementation SktKeyboard

-(id) init
{
    if (self = [super init]) {
        
    }
    
    return self;
}

+(id) initWithName:(NSString*)  name
        parentNode:(SKNode*)    parent
{
    SktPopup* res;
    
    res = [SktPopup new];
    if (res) {
        res.scene = parent.scene;
        res.parentNode = parent;
        res.popupRootNode = [SKShapeNode new];
        res.popupRootNode.name = name;
        float w = 480;
        float h = 480;
        float x = -w/2;
        float y = -h/2;
        
        res.popupRootNode.path = CGPathCreateWithRoundedRect(CGRectMake(x, y, w, h), 20, 20, 0);
        
        res.popupRootNode.position = CGPointMake(CGRectGetMidX(res.parentNode.frame),
                                                 CGRectGetMidY(res.parentNode.frame));
        
        res.popupRootNode.fillColor = [SKColor colorWithWhite:.5 alpha:.5];
        
        NSString* text=@"KEYBOARD";
        if (text) {
            SKLabelNode* label0 = [SKLabelNode new];
            label0.text = text;
            label0.name = @"text";
            label0.position = CGPointMake(0, +300);
            [res.popupRootNode addChild:label0];
        }

        float fontSize = 26;
        float curX0 = -100;
        int maxCol = 8;
        float curDX = 40;
        float curDY = 0;
        float curX = 0;
        float curY = 0;

        NSArray* tabV = @[@"A", @"E", @"I", @"O", @"U", @"Y"];
        curX = curX0;
        curY = 0;
        int curCol = 0;
        for (NSString* curL in tabV) {
            text = curL;
            
            if (text) {
                SKLabelNode* curLabel = [SKLabelNode new];
                curLabel.text = text;
                curLabel.name = text;
                curLabel.fontSize = fontSize;
                curLabel.position = CGPointMake(curX, curY);
                [res.popupRootNode addChild:curLabel];
            }
            // MOVE TO NEXT POSITION
            curX += curDX;
            curX += curDY;

        }
        
        NSArray* tabC = @[  @"B", @"C", @"D", @"F", @"G", @"H", @"J",
                            @"K", @"L", @"M", @"N", @"P", @"Q", @"R",
                            @"S", @"T", @"V", @"W", @"X", @"Z"
                        ];
        curX0 = -100;
        curX = curX0;
        curY = 160;
        curDY = -40;
        curCol = 0;
        for (NSString* curC in tabC) {
            text = curC;
            
            if (text) {
                SKLabelNode* curLabel = [SKLabelNode new];
                curLabel.text = text;
                curLabel.name = text;
                curLabel.fontSize = fontSize;
                curLabel.position = CGPointMake(curX, curY);
                [res.popupRootNode addChild:curLabel];
            }
            // MOVE TO NEXT POSITION
            curX += curDX;
            curCol++;
            if (0 == (curCol % maxCol)) {
                curX = curX0;
                curY += curDY;
            }
            
        }

        NSArray* tabN = @[  @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"0",
                            @"+", @"<", @"-", @">", @"*", @"/", @".", @",", @"(", @")"
                            @"[", @";", @"]", @"_", @"@", @"=", @"%", @"$", @"!", @"?"
                            ];
        curX0 = -100;
        curX = curX0;
        curY = -80;
        curDY = -40;
        curCol = 0;
        for (NSString* curN in tabN) {
            text = curN;
            
            if (text) {
                SKLabelNode* curLabel = [SKLabelNode new];
                curLabel.text = text;
                curLabel.name = text;
                curLabel.fontSize = fontSize;
                curLabel.position = CGPointMake(curX, curY);
                [res.popupRootNode addChild:curLabel];
            }
            // MOVE TO NEXT POSITION
            curX += curDX;
            curCol++;
            if (0 == (curCol % maxCol)) {
                curX = curX0;
                curY += curDY;
            }
            
        }

        
        [res.parentNode addChild:res.popupRootNode];
    }
    return res;
}

@end
