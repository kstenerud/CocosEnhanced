//
//  Button.h
//  CocosEnhanced
//
//  Created by Karl Stenerud on 10-01-21.
//
// Copyright 2010 Karl Stenerud
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall remain in place
// in this source code.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import "cocos2d.h"
#import "TouchableNode.h"

@class Button;

typedef void(^ButtonActionHandler)(Button *button);

/**
 * A button is a touchable node that sends a message back to a listener when touched and released.
 * Note: It will only trigger if both the touch and release occur within the active area
 * (rectangle defined by the button's position and the touchableNode's contentSize).
 */
@interface Button : TouchableNode <CCRGBAProtocol>
{
	CCNode* touchablePortion;
    CGSize touchAreaScale;
    BOOL touchAreaIsCircle;
	BOOL touchInProgress;
	BOOL buttonWasDown;
	
	id target;
	SEL selector;
    void(^_onPressed)(Button* button);
}
/** The portion of this button that is actually touchable */
@property(nonatomic,readwrite,retain) CCNode* touchablePortion;

@property(readwrite,assign) id target;
@property(readwrite,assign) SEL selector;

@property(readwrite,assign) CGSize touchAreaScale;
@property(readwrite,assign) BOOL touchAreaIsCircle;
@property(nonatomic,copy) ButtonActionHandler downHandler;
@property(nonatomic,copy) ButtonActionHandler upHandler;
@property(nonatomic,copy) ButtonActionHandler onPressed;

/** Create a new button.
 * @param node the node to use as a touchable portion.
 * @param target the target to notify when the button is pressed.
 * @param selector the selector to call when the button is pressed.
 * @return a new button.
 */
+ (id) buttonWithTouchablePortion:(CCNode*) node target:(id) target selector:(SEL) selector;

+ (id) buttonWithSize:(CGSize)size target:(id)target selector:(SEL)selector;

/** Initialize a button.
 * @param node the node to use as a touchable portion.
 * @param target the target to notify when the button is pressed.
 * @param selector the selector to call when the button is pressed.
 * @return the initialized button.
 */
- (id) initWithTouchablePortion:(CCNode*) node target:(id) target selector:(SEL) selector;

+ (id) buttonWithTouchablePortion:(CCNode *)node block:(ButtonActionHandler) onPressed;

- (id) initWithTouchablePortion:(CCNode *)node block:(ButtonActionHandler) onPressed;

/** Called when a button press is detected.
 * Subclasses can use this method to add behavior to a button push.
 */
- (void) onButtonPressed;

/** Called when a button is pushed down.
 * Subclasses can use this method to add behavior to a button push.
 */
- (void) onButtonDown;

/** Called when a button is released.
 * Subclasses can use this method to add behavior to a button push.
 */
- (void) onButtonUp;

@end
