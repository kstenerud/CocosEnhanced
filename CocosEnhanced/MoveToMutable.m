//
//  MoveToMutable.m
//  CocosEnhanced
//
//  Created by Karl Stenerud on 19/11/09.
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

#import "MoveToMutable.h"

@implementation MoveToMutable

+ (id) actionWithPixelsPerSecond:(float) pixelsPerSecond position:(CGPoint) position
{
	return [[[self alloc] initWithPixelsPerSecond:pixelsPerSecond position:position] autorelease];
}

+ (id) actionWithDuration:(ccTime) duration position:(CGPoint) position
{
	return [[[self alloc] initWithDuration:duration position:position] autorelease];
}


- (id) initWithPixelsPerSecond:(float) pixelsPerSecondIn position:(CGPoint) positionIn
{
	if(nil != (self = [super initWithDuration:0 position:positionIn]))
	{
		pixelsPerSecond = pixelsPerSecondIn;
		needsDurationUpdate = YES;
	}
	return self;
}

- (id) initWithDuration:(ccTime) durationIn position:(CGPoint) positionIn
{
	if(nil != (self = [super initWithDuration:durationIn position:positionIn]))
	{
		pixelsPerSecond = 0;
		needsDurationUpdate = NO;
	}
	return self;
}

- (id) copyWithZone: (NSZone*) zone
{
	if(pixelsPerSecond > 0)
	{
		return [[[self class] allocWithZone:zone] initWithPixelsPerSecond:pixelsPerSecond position:endPosition];
	}
	return [[[self class] allocWithZone:zone] initWithDuration:self.duration position: endPosition];
}

- (void) setDuration:(ccTime) durationIn
{
	duration_ = durationIn;
	pixelsPerSecond = 0;
	needsDurationUpdate = NO;
}

- (ccTime) duration
{
	return duration_;
}

- (void) setPixelsPerSecond:(float) pixelsPerSecondIn
{
	pixelsPerSecond = pixelsPerSecondIn;
	needsDurationUpdate |= pixelsPerSecond > 0;
}

- (float) pixelsPerSecond
{
	return pixelsPerSecond;
}

- (void) setEndPosition:(CGPoint) endPositionIn
{
	endPosition = endPositionIn;
	needsDurationUpdate |= pixelsPerSecond > 0;
}

- (CGPoint) endPosition
{
	return endPosition;
}

- (void) updateDuration:(CCNode*)aTarget
{
	if(needsDurationUpdate)
	{
        duration_ = ccpDistance(aTarget.position, endPosition) / pixelsPerSecond;
		needsDurationUpdate = NO;
	}
}

@end
