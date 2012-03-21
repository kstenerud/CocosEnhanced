//
//  Slider.m
//  CocosEnhanced
//
//  Created by Karl Stenerud on 10-05-30.
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

#import "Slider.h"


@implementation Slider

+ (id) sliderWithTrack:(CCNode*) track knob:(CCNode*) knob target:(id) target moveSelector:(SEL) moveSelector dropSelector:(SEL) dropSelector
{
	return [[[self alloc] initWithTrack:track knob:knob target:target moveSelector:moveSelector dropSelector:dropSelector] autorelease];
}

- (id) initWithTrack:(CCNode*) trackIn knob:(CCNode*) knobIn
{
	if(nil != (self = [super init]))
	{
		track = trackIn;
		[self addChild:track z:10];
		
		knob = knobIn;
		[self addChild:knob z:20];
        
		scaleUpAction = [[CCScaleBy actionWithDuration:0.1 scale:1.2] retain];
		scaleDownAction = [[CCSequence actionOne:[CCScaleBy actionWithDuration:0.02 scale:1.1]
											 two:[CCScaleTo actionWithDuration:0.05 scaleX:knob.scaleX scaleY:knob.scaleY]] retain];
        
		CGSize knobSize = CGSizeMake(knob.contentSize.width * knob.scaleX, knob.contentSize.height * knob.scaleY);
		CGSize trackSize = CGSizeMake(track.contentSize.width * track.scaleX, track.contentSize.height * track.scaleY);
		CGSize combinedSize = CGSizeMake(knobSize.width > trackSize.width ? knobSize.width : trackSize.width,
										 knobSize.height > trackSize.height ? knobSize.height : trackSize.height);
		
		self.contentSize = combinedSize;
		touchPriority = 0;
		targetedTouches = YES;
		swallowTouches = YES;
		isTouchEnabled = YES;
		self.isRelativeAnchorPoint = YES;
		self.anchorPoint = ccp(0.5, 0.5);		
	}
	return self;
}

- (id) initWithTrack:(CCNode*) trackIn
                knob:(CCNode*) knobIn
              target:(id) targetIn
        moveSelector:(SEL) moveSelectorIn
        dropSelector:(SEL) dropSelectorIn
{
    if([self initWithTrack:trackIn knob:knobIn])
	{
		target = targetIn;
		moveSelector = moveSelectorIn;
		dropSelector = dropSelectorIn;
	}
	return self;
}


+ (Slider*) sliderWithTrack:(CCNode*) track
                       knob:(CCNode*) knob
                     onMove:(void(^)(Slider* slider)) moveBlock
                     onDrop:(void(^)(Slider* slider)) dropBlock
{
    return [[[self alloc] initWithTrack:track
                                   knob:knob
                                 onMove:moveBlock
                                 onDrop:dropBlock] autorelease];
}

- (id) initWithTrack:(CCNode*) trackIn
                knob:(CCNode*) knobIn
              onMove:(void(^)(Slider* slider)) moveBlock
              onDrop:(void(^)(Slider* slider)) dropBlock
{
    if([self initWithTrack:trackIn knob:knobIn])
	{
        onMove = [moveBlock copy];
        onDrop = [dropBlock copy];
	}
	return self;
}

- (void) dealloc
{
    [onMove release];
    [onDrop release];
	[scaleUpAction release];
	[scaleDownAction release];
	
	[super dealloc];
}

- (bool) setKnobPosition:(CGPoint) pos
{
	return NO;
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
	if([self touch:touch hitsNode:self])
	{
		CGPoint local = [self convertTouchToNodeSpace:touch];
		[self setKnobPosition:local];
		[knob stopAllActions];
		[knob runAction:scaleUpAction];
		if(nil != moveSelector)
		{
			[target performSelector:moveSelector withObject:self];
		}
        if(nil != onMove)
        {
            onMove(self);
        }
		return YES;
	}
	return NO;
}

-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
	CGPoint local = [self convertTouchToNodeSpace:touch];
	
	if([self setKnobPosition:local])
    {
        if(nil != moveSelector)
        {
            [target performSelector:moveSelector withObject:self];
        }
        if(nil != onMove)
        {
            onMove(self);
        }
    }
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
	[knob stopAllActions];
	[knob runAction:scaleDownAction];
	if(nil != dropSelector)
	{
		[target performSelector:dropSelector withObject:self];
	}
    if(nil != onDrop)
    {
        onDrop(self);
    }
}

-(void) ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
	[knob stopAllActions];
	[knob runAction:scaleDownAction];
}

- (GLubyte) opacity
{
	for(CCNode* child in self.children)
	{
		if([child conformsToProtocol:@protocol(CCRGBAProtocol)])
		{
			return ((id<CCRGBAProtocol>)child).opacity;
		}
	}
	return 255;
}

- (void) setOpacity:(GLubyte) newValue
{
	for(CCNode* child in self.children)
	{
		if([child conformsToProtocol:@protocol(CCRGBAProtocol)])
		{
			[(id<CCRGBAProtocol>)child setOpacity:newValue];
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

- (void) setColor:(ccColor3B) newValue
{
	for(CCNode* child in self.children)
	{
		if([child conformsToProtocol:@protocol(CCRGBAProtocol)])
		{
			[(id<CCRGBAProtocol>)child setColor:newValue];
		}
	}
}

- (float) value
{
	return 0;
}

- (void) setValue:(float) value
{
	// Do nothing
}

@end



@implementation VerticalSlider

- (id) initWithTrack:(CCNode*) trackIn knob:(CCNode*) knobIn
{
	if(nil != (self = [super initWithTrack:trackIn knob:knobIn]))
	{
		CGSize knobSize = CGSizeMake(knob.contentSize.width * knob.scaleX, knob.contentSize.height * knob.scaleY);
		CGSize trackSize = CGSizeMake(track.contentSize.width * track.scaleX, track.contentSize.height * track.scaleY);
		CGSize combinedSize = CGSizeMake(knobSize.width > trackSize.width ? knobSize.width : trackSize.width,
										 knobSize.height > trackSize.height ? knobSize.height : trackSize.height);

		verticalMin = knobSize.height/2;
		verticalMax = trackSize.height - knobSize.height/2;
		horizontalLock = combinedSize.width/2;
		
		knob.anchorPoint = ccp(0.5,0.5);
		knob.position = ccp(horizontalLock, verticalMin);
		
		track.anchorPoint = ccp(0,0);
		track.position = ccp(combinedSize.width/2 - trackSize.width/2, 0);
	}
	return self;
}

- (float) value
{
	float spread = verticalMax - verticalMin;
	float position = knob.position.y - verticalMin;
	return position / spread;
}

- (void) setValue:(float) val
{
	float spread = verticalMax - verticalMin;
	float position = verticalMin + spread * val;
	knob.position = ccp(horizontalLock, position);
}

- (bool) setKnobPosition:(CGPoint) position
{
	float y = position.y;
	if(y < verticalMin)
	{
		y = verticalMin;
	}
	if(y > verticalMax)
	{
		y = verticalMax;
	}
	CGPoint finalPosition = ccp(horizontalLock, y);
	if(finalPosition.x != knob.position.x || finalPosition.y != knob.position.y)
	{
		knob.position = finalPosition;
		return YES;
	}
	return NO;
}

@end



@implementation HorizontalSlider

- (id) initWithTrack:(CCNode*) trackIn knob:(CCNode*) knobIn
{
	if(nil != (self = [super initWithTrack:trackIn knob:knobIn]))
	{
		CGSize knobSize = CGSizeMake(knob.contentSize.width * knob.scaleX, knob.contentSize.height * knob.scaleY);
		CGSize trackSize = CGSizeMake(track.contentSize.width * track.scaleX, track.contentSize.height * track.scaleY);
		CGSize combinedSize = CGSizeMake(knobSize.width > trackSize.width ? knobSize.width : trackSize.width,
										 knobSize.height > trackSize.height ? knobSize.height : trackSize.height);
		
		horizontalMin = knobSize.width/2;
		horizontalMax = trackSize.width - knobSize.width/2;
		verticalLock = combinedSize.height/2;
		
		knob.anchorPoint = ccp(0.5,0.5);
		knob.position = ccp(horizontalMin, verticalLock);
		
		track.anchorPoint = ccp(0,0);
		track.position = ccp(0, combinedSize.height/2 - trackSize.height/2);
	}
	return self;
}

- (float) value
{
	float spread = horizontalMax - horizontalMin;
	float position = knob.position.x - horizontalMin;
	return position / spread;
}

- (void) setValue:(float) val
{
	float spread = horizontalMax - horizontalMin;
	float position = horizontalMin + spread * val;
	knob.position = ccp(position, verticalLock);
}

- (bool) setKnobPosition:(CGPoint) position
{
	float x = position.x;
	if(x < horizontalMin)
	{
		x = horizontalMin;
	}
	if(x > horizontalMax)
	{
		x = horizontalMax;
	}
	CGPoint finalPosition = ccp(x, verticalLock);
	if(finalPosition.x != knob.position.x || finalPosition.y != knob.position.y)
	{
		knob.position = finalPosition;
		return YES;
	}
	return NO;
}

@end
