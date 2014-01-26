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
    SktKeyboard* res;
    
    res = [SktKeyboard new];
    if (res) {
        res.scene = parent.scene;
        res.parentNode = parent;
        res.popupRootNode = [SKShapeNode new];
        res.popupRootNode.name = name;
        float fontSize = 36;
        float w = 800;
        float h = 480;
        float x = -w/2;
        float y = -h/2;
        int maxCol = 10;
        
        res.popupRootNode.path = CGPathCreateWithRoundedRect(CGRectMake(x, y, w, h), 20, 20, 0);
        
        res.popupRootNode.position = CGPointMake(CGRectGetMidX(res.parentNode.frame),
                                                 CGRectGetMidY(res.parentNode.frame));
        
        res.popupRootNode.fillColor = [SKColor colorWithWhite:.5 alpha:.5];
        
        NSString* text=@"KEYBOARD";
        if (text) {
            SKLabelNode* label0 = [SKLabelNode new];
            label0.text = text;
            label0.name = @"text";
            label0.position = CGPointMake(0, +260);
            [res.popupRootNode addChild:label0];
            
            res.curLabel = label0;
            res.curText= @"";
            res.curLabel.text = res.curText;
        }
        
        NSString* textCancel = @"(x)";
        if (textCancel) {
            SKLabelNode* label1 = [SKLabelNode new];
            label1.text = textCancel;
            label1.name = @"CANCEL";
            label1.position = CGPointMake(-360, 200);
            [res.popupRootNode addChild:label1];
        }

        NSString* textBackspace = @"<<";
        if (textBackspace) {
            SKLabelNode* label2 = [SKLabelNode new];
            label2.text = textBackspace;
            label2.name = @"backspace";
            label2.position = CGPointMake(360, 200);
            [res.popupRootNode addChild:label2];
        }

        float curX0 = -260;
        float curDX = 60;
        float curDY = 0;
        float curX = 0;
        float curY = 0;

        NSArray* tabV = @[];
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
            curCol++;
            if (0 == (curCol % maxCol)) {
                curX = curX0;
                curY += curDY;
            }

        }
        
        NSArray* tabC = @[  @"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9",
                            @"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J",
                            @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T",
                            @"U", @"V", @"W", @"X", @"Y", @"Z", @",", @";", @".", @"@",
                        ];
        curX0 = -260;
        curX = curX0;
        curY = 140;
        curDY = -50;
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

        NSArray* tabN = @[  @"+", @"-", @">", @"<", @"*", @"/", @"(", @")", @"[", @"]",
                            @"_", @"=", @"%", @"$", @"!", @"?", @"\\", @"#"
                            ];
        curX0 = -260;
        curX = curX0;
        curY = -100;
        curDY = -50;
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

-(void) processNode: (SKNode*) n
{
    [self processInput:n];
}

-(void) processInput: (SKNode*) n
{
    
    long l = 0;
    if ([n.name length]) l = [n.name length];
    
    if ([n.name isEqualToString:@"backspace"]) {
        long tl = [self.curText length];
        if (tl > 0)
            self.curText = [self.curText substringToIndex: ([self.curText length] - 1)];
    }
    else if (l > 0) {
        self.curText = [NSString stringWithFormat:@"%@%@", self.curText, n.name];
    }
    
    self.curLabel.text = self.curText;
}

@end
