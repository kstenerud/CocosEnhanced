//
//  Button.m
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

#import "Button.h"
#import "CCNode+ChildContentSize.h"

#define kPathContentSize @"contentSize"
#define kPathScale @"scale"
#define kPathScaleX @"scaleX"
#define kPathScaleY @"scaleY"


@interface Button ()

- (void) addObserversToChild:(CCNode*) child;

- (void) removeObserversFromChild:(CCNode*) child;

@end

@implementation Button

@synthesize touchablePortion;
@synthesize target;
@synthesize selector;
@synthesize touchAreaScale;
@synthesize touchAreaIsCircle;
@synthesize downHandler;
@synthesize upHandler;
@synthesize onPressed = _onPressed;

+ (id) buttonWithSize:(CGSize)size target:(id)target selector:(SEL)selector
{
    CCNode *node = [CCNode node];
    node.contentSize = size;
    return [Button buttonWithTouchablePortion:node target:target selector:selector];
}

+ (id) buttonWithTouchablePortion:(CCNode*) node target:(id) target selector:(SEL) selector
{
	return [[[self alloc] initWithTouchablePortion:node target:target selector:selector] autorelease];
}

- (id) initWithTouchablePortion:(CCNode*) node target:(id) targetIn selector:(SEL) selectorIn
{
	if(nil != (self = [super init]))
	{
		self.touchablePortion = node;
		
		touchPriority = 0;
		targetedTouches = YES;
		swallowTouches = YES;
		isTouchEnabled = YES;
		
		target = targetIn;
		selector = selectorIn;
		
		self.isRelativeAnchorPoint = YES;
		self.anchorPoint = ccp(0.5, 0.5);
	}
	return self;
}

+ (id) buttonWithTouchablePortion:(CCNode *)node block:(ButtonActionHandler) onPressed
{
    return [[[self alloc] initWithTouchablePortion:node block:onPressed] autorelease];
}

- (id) initWithTouchablePortion:(CCNode *)node block:(ButtonActionHandler) onPressed
{
    if((self = [super init]))
    {
		self.touchablePortion = node;
		
		touchPriority = 0;
		targetedTouches = YES;
		swallowTouches = YES;
		isTouchEnabled = YES;
		
        _onPressed = [onPressed copy];
		
		self.isRelativeAnchorPoint = YES;
		self.anchorPoint = ccp(0.5, 0.5);
    }
    return self;
}

- (void) dealloc
{
    [self removeObserversFromChild:touchablePortion];
    [_onPressed release];
    self.downHandler = nil;
    self.upHandler = nil;
    [super dealloc];
}

- (void) addObserversToChild:(CCNode*) child
{
    [child addObserver:self
            forKeyPath:kPathContentSize
               options:NSKeyValueObservingOptionNew
               context:NULL];
    [child addObserver:self
            forKeyPath:kPathScale
               options:NSKeyValueObservingOptionNew
               context:NULL];
    [child addObserver:self
            forKeyPath:kPathScaleX
               options:NSKeyValueObservingOptionNew
               context:NULL];
    [child addObserver:self
            forKeyPath:kPathScaleY
               options:NSKeyValueObservingOptionNew
               context:NULL];
}

- (void) removeObserversFromChild:(CCNode*) child
{
    [child removeObserver:self forKeyPath:kPathContentSize];
    [child removeObserver:self forKeyPath:kPathScale];
    [child removeObserver:self forKeyPath:kPathScaleX];
    [child removeObserver:self forKeyPath:kPathScaleY];
}

- (float) squaredDistanceFrom:(CGPoint) source to:(CGPoint) destination
{
	float distanceX = destination.x - source.x;
	float distanceY = destination.y - source.y;
	return distanceX * distanceX + distanceY * distanceY;
}

- (BOOL) touchIsInHitArea:(UITouch*) touch
{
    CGSize touchAreaSize = CGSizeMake(touchablePortion.contentSize.width * touchAreaScale.width,
                                      touchablePortion.contentSize.height * touchAreaScale.height);
    CGPoint point = [touchablePortion convertTouchToNodeSpace:touch];
    if(touchAreaIsCircle)
    {
        CGFloat radius = touchAreaSize.width;
        if(touchAreaSize.height > radius)
        {
            radius = touchAreaSize.width;
        }
        
        CGFloat radius2 = radius * radius;
        return radius2 >= [self squaredDistanceFrom:point to:touchablePortion.position];
    }
    else
    {
        CGRect r = CGRectMake(0, 0, touchAreaSize.width, touchAreaSize.height);
        return CGRectContainsPoint(r, point);
    }
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
	if([self touch:touch hitsNode:touchablePortion])
	{
		touchInProgress = YES;
		buttonWasDown = YES;
		[self onButtonDown];
		return YES;
	}
	return NO;
}

-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{	
	if(touchInProgress)
	{
		if([self touch:touch hitsNode:touchablePortion])
		{
			if(!buttonWasDown)
			{
				[self onButtonDown];
			}
		}
		else
		{
			if(buttonWasDown)
			{
				[self onButtonUp];
			}
		}
	}
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{	
	if(buttonWasDown)
	{
		[self onButtonUp];
	}
	if(touchInProgress && [self touch:touch hitsNode:touchablePortion])
	{
		touchInProgress = NO;
		[self onButtonPressed];
	}
}

-(void) ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
	if(buttonWasDown)
	{
		[self onButtonUp];
	}
	touchInProgress = NO;
}

- (void) onButtonDown
{
	buttonWasDown = YES;
    if (downHandler != nil)
    {
        downHandler(self);
    }
}

- (void) onButtonUp
{
	buttonWasDown = NO;
    if (upHandler != nil)
    {
        upHandler(self);
    }
}

- (void) onButtonPressed
{
    if(target != nil)
    {
        [target performSelector:selector withObject:self];
    }
    if(_onPressed != nil)
    {
        _onPressed(self);
    }
}

- (GLubyte) opacity
{
	for(CCNode* child in self.children)
	{
		if([child respondsToSelector:@selector(setOpacity:)])
		{
			return ((id<CCRGBAProtocol>)child).opacity;
		}
	}
	return 255;
}

- (void) setOpacity:(GLubyte) value
{
	for(CCNode* child in self.children)
	{
		if([child respondsToSelector:@selector(setOpacity:)])
		{
			[(id<CCRGBAProtocol>)child setOpacity:value];
		}
	}
}

- (ccColor3B) color
{
	for(CCNode* child in self.children)
	{
		if([child conformsToProtocol:@protocol(CCRGBAProtocol)])
		{
			return ((id<CCRGBAProtocol>)child).color;
		}
	}
	return ccWHITE;
}

- (void) setColor:(ccColor3B) value
{
	for(CCNode* child in self.children)
	{
		if([child conformsToProtocol:@protocol(CCRGBAProtocol)])
		{
			[(id<CCRGBAProtocol>)child setColor:value];
		}
	}
}

- (void) resizeAndRealign
{
    self.contentSize = CGSizeMake(touchablePortion.contentSize.width * touchablePortion.scaleX,
                                  touchablePortion.contentSize.height * touchablePortion.scaleY);
    touchablePortion.anchorPoint = ccp(0.5,0.5);
    touchablePortion.position = ccp(self.contentSize.width * 0.5,
                                    self.contentSize.height * 0.5);
}

- (void) setTouchablePortion:(CCNode *) value
{
	if(nil != touchablePortion)
	{
        [self removeObserversFromChild:touchablePortion];
		[self removeChild:touchablePortion cleanup:YES];
	}
	if(nil != value)
	{
		touchablePortion = value;
		[self addChild:touchablePortion];
		touchablePortion.anchorPoint = ccp(0,0);
		touchablePortion.position = ccp(0,0);
        [self resizeAndRealign];
        [self addObserversToChild:touchablePortion];
	}
}

- (void) observeValueForKeyPath:(NSString *)keyPath
                       ofObject:(id)object
                         change:(NSDictionary *)change
                        context:(void *)context
{
    [self resizeAndRealign];
}

@end
