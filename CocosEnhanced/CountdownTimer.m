//
//  CountdownTimer.m
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

#import "CountdownTimer.h"
#import "CCNode+ChildContentSize.h"

#define kColorChangeThreshold 10.0f
#define kTimeLowThreshold 5.0f
#define kDefaultColor ccBLACK
#define kLowTimeColor ccRED

@interface CountdownTimer (Private)

- (void) updateTimeLabel;
- (void) updateTime:(NSTimeInterval) newTime;

@end



@interface TimerUpdateAction: CCActionInterval

@end

@implementation TimerUpdateAction

- (void) update:(ccTime)time
{
    [self.target updateTime:duration_ - time * duration_];
}

@end

@interface TimerCounterUpdateAction : CCAction

@end

@implementation TimerCounterUpdateAction

- (void)update:(ccTime)time
{
    [self.target updateTime:time];
}

@end


@implementation CountdownTimer

@synthesize onTimeLow = _onTimeLow;
@synthesize onTimeout = _onTimeout;
@synthesize delegate;
@synthesize countsUp;

+ (NSArray*) soundResources
{
    return [NSMutableArray arrayWithObjects:
            @"ClockTick.caf",
            nil];
}

+ (id) timerWithPrefix:(NSString*) prefix fontName:(NSString*) fontName fontSize:(int) fontSize
{
	return [[[self alloc] initWithPrefix:prefix fontName:fontName fontSize:fontSize] autorelease];
}


- (id) initWithPrefix:(NSString *) prefix fontName:(NSString*) fontName fontSize:(int) fontSize
{
	if(nil != (self = [super init]))
	{
		prefix_ = [prefix retain];
        
		timeLabel_ = [[CCLabelTTF labelWithString:@"0:00" fontName:fontName fontSize:fontSize] retain];
		timeLabel_.color = kDefaultColor;
		timeLabel_.anchorPoint = ccp(0.5,0.5);
		timeLabel_.position = ccp(timeLabel_.contentSize.width/2,timeLabel_.contentSize.height/2);
		[self addChild:timeLabel_];
        
		self.isRelativeAnchorPoint = YES;
		[self setContentSizeFromChildren];
		
		bumpScaleAction_ = [[CCSequence actions:
                             [CCScaleTo actionWithDuration:0.1f scale:1.5f],
                             [CCScaleTo actionWithDuration:0.3f scale:1.0f],
                             nil] retain];
        self.countsUp = NO;
	}
	return self;
}

- (void) dealloc
{
    self.delegate = nil;
    [_onTimeLow release];
    [_onTimeout release];
    [prefix_ release];
	[timeLabel_ release];
	[bumpScaleAction_ release];
	[super dealloc];
}

- (void) setTimeoutCallbackTarget:(id) targetIn selector:(SEL) selectorIn
{
	target_ = targetIn;
	selector_ = selectorIn;
}

- (void)update:(ccTime)delta
{
    [self setTime:self.timeRemaining + delta];
    [self updateTimeLabel];
}

- (void) updateTime:(ccTime) newTime
{
    if(newTime < kTimeLowThreshold && !_timeIsLow && !countsUp)
    {
        _timeIsLow = YES;
        if(_onTimeLow != nil)
        {
            _onTimeLow();
        }
    }
    
    if(timeRemaining_ < kTimeLowThreshold+1 && newTime < kTimeLowThreshold &&
       (int)newTime < (int)timeRemaining_ && [timeLabel_ numberOfRunningActions] == 0)
    {
		[timeLabel_ runAction:bumpScaleAction_];
    }
    timeRemaining_ = newTime;
    timeLabel_.color = (timeRemaining_ > kColorChangeThreshold || countsUp) ? color_ : kLowTimeColor;
    [self updateTimeLabel];
}

- (void) start
{
    _timeIsLow = NO;
    if (countsUp)
    {
        [self scheduleUpdate];
    }
    else
    {
        [self runAction:[CCSequence actions:
                         [TimerUpdateAction actionWithDuration:timeRemaining_],
                         [CCCallFunc actionWithTarget:target_ selector:selector_],
                         _onTimeout == nil ? nil : [CCCallBlock actionWithBlock:_onTimeout],
                         nil]];
    }
}

- (void) stop
{
    [self stopAllActions];
}

- (void) updateTimeLabel
{
	int minutes = (int)(timeRemaining_ / 60);
	int seconds = (int)timeRemaining_ % 60;
	
	NSString* str;
	if(nil == prefix_)
	{
		str = [NSString stringWithFormat:@"%d:%02d", minutes, seconds];
	}
	else
	{
		str = [NSString stringWithFormat:@"%@%d:%02d", prefix_, minutes, seconds];
	}
    
	[timeLabel_ setString:str];
}

- (GLubyte) opacity
{
	return timeLabel_.opacity;
}

- (void) setOpacity:(GLubyte) value
{
	timeLabel_.opacity = value;
}

- (ccColor3B) color
{
	return color_;
}

- (void) setColor:(ccColor3B) value
{
	color_ = value;
    if(timeRemaining_ > kColorChangeThreshold || countsUp)
    {
        timeLabel_.color = color_;
    }
}

- (ccTime) timeRemaining
{
    return timeRemaining_;
}

- (void) setTimeRemaining:(ccTime)timeRemaining
{
    timeRemaining_ = timeRemaining;
    timeLabel_.color = (timeRemaining_ > kColorChangeThreshold || countsUp) ? color_ : kLowTimeColor;
    [self updateTimeLabel];
}

- (NSString*) prefix
{
    return prefix_;
}

- (void) setPrefix:(NSString *)prefix
{
    [prefix_ autorelease];
    prefix_ = [prefix retain];
    [self updateTimeLabel];
}

- (void) setTime:(ccTime) time
{
    self.timeRemaining = time;
}

- (NSString *)currentTime
{
    return timeLabel_.string;
}

@end
