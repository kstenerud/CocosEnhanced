//
//  CountdownTimer.h
//  CocosEnhanced
//
//  Created by Karl Stenerud on 10-01-02.
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


/** A UI component to show a time countdown.
 * When started, it updates itself once per second with the new time value.
 */
@protocol CountdownTimerDelegate;
@interface CountdownTimer : CCNode
{
	CCLabelTTF* timeLabel_;
    ccColor3B color_;
	ccTime timeRemaining_;
	NSString* prefix_;
	id target_;
	SEL selector_;
    BOOL _timeIsLow;
	
	CCActionInterval* bumpScaleAction_;
    
    void (^_onTimeLow)();
    void (^_onTimeout)();
}
/** The prefix to show before the time value */
@property(readwrite,retain) NSString* prefix;
/** The timer value, in seconds */
@property(readwrite,assign) ccTime timeRemaining;
/** The opacity (alpha value) of this component */
@property(readwrite,assign) GLubyte opacity;
/** The color for the text label */
@property(readwrite, assign) ccColor3B color;

@property(readwrite,copy) void (^onTimeLow)();
@property(readwrite,copy) void (^onTimeout)();
@property (nonatomic, assign) id<CountdownTimerDelegate> delegate;
// used for counting the time a game takes instead of down
@property (nonatomic, assign) BOOL countsUp;

/** Make a new timer with the specified prefix */
+ (id) timerWithPrefix:(NSString*) prefix fontName:(NSString*) fontName fontSize:(int) fontSize;

/** Init a timer with the specified prefix */
- (id) initWithPrefix:(NSString*) prefix fontName:(NSString*) fontName fontSize:(int) fontSize;

/** The target to call when the countdown completes */
- (void) setTimeoutCallbackTarget:(id) target selector:(SEL) selector;

/** Start with whatever timeRemaining is set to */
- (void) start;

/** Stop the countdown. timeRemaining remains unchanged. */
- (void) stop;

- (void) setTime:(ccTime) time;

- (NSString *)currentTime;

@end

@protocol CountdownTimerDelegate <NSObject>
// called when there is less than 10 seconds left in the game
- (void)gameWillEnd;
@end
