//
//  RecalculatingSpawn.m
//  CocosEnhanced
//
//  Created by Karl Stenerud on 23/11/09.
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

#import "RecalculatingSpawn.h"


@implementation RecalculatingSpawn

+(id) actions: (CCFiniteTimeAction*) action1, ...
{
	va_list params;
	va_start(params,action1);
	
	CCFiniteTimeAction *now;
	CCFiniteTimeAction *prev = action1;
	
	while( action1 ) {
		now = va_arg(params,CCFiniteTimeAction*);
		if ( now )
			prev = [RecalculatingSpawn actionOne: prev two: now];
		else
			break;
	}
	va_end(params);
	return prev;
}

+(id) actionsFromArray: (NSArray*) actions
{
	NSEnumerator* actionEnum = [actions objectEnumerator];
	
	CCFiniteTimeAction *now;
	CCFiniteTimeAction *prev = [actionEnum nextObject];
	
	while(nil != (now = [actionEnum nextObject]) )
	{
		prev = [RecalculatingSpawn actionOne: prev two: now];
	}
	return prev;
}

+(id) actionOne: (CCFiniteTimeAction*) one two: (CCFiniteTimeAction*) two
{	
	return [[[self alloc] initOne:one two:two ] autorelease];
}

-(id) initOne: (CCFiniteTimeAction*) one_ two: (CCFiniteTimeAction*) two_
{
	NSAssert( one_!=nil, @"RecalculatingSpawn: argument one must be non-nil");
	NSAssert( two_!=nil, @"RecalculatingSpawn: argument two must be non-nil");
	
	ccTime d1 = [one_ duration];
	ccTime d2 = [two_ duration];	
	
	if(nil != (self = [super initWithDuration: fmaxf(d1,d2)]))
	{
		one = one_;
		two = two_;
		delayOne = [CCDelayTime actionWithDuration:0];
		delayTwo = [CCDelayTime actionWithDuration:0];
		sequenceOne = [[RecalculatingSequence actionOne:one two:delayOne] retain];
		sequenceTwo = [[RecalculatingSequence actionOne:two two:delayTwo] retain];
	}
	return self;
}

-(id) copyWithZone: (NSZone*) zone
{
	return [[[self class] allocWithZone: zone] initOne:[[one copyWithZone:zone] autorelease] two:[[two copyWithZone:zone] autorelease]];
}

-(void) dealloc
{
	[sequenceOne release];
	[sequenceTwo release];
	[super dealloc];
}

-(void) startWithTarget:(id)aTarget
{
	[super startWithTarget:aTarget];
	[sequenceOne startWithTarget:target_];
	[sequenceTwo startWithTarget:target_];
}

- (void) updateDuration:(id)aTarget
{
	[one updateDuration:aTarget];
	[two updateDuration:aTarget];

	ccTime maxDuration = fmaxf(one.duration, two.duration);
	if(one.duration < maxDuration)
	{
		delayOne.duration = maxDuration - one.duration;
	}
	else
	{
		delayOne.duration = 0;
	}
	
	if(two.duration < maxDuration)
	{
		delayTwo.duration = maxDuration - two.duration;
	}
	else
	{
		delayTwo.duration = 0;
	}

	sequenceOne.duration = sequenceTwo.duration = self.duration = maxDuration;
}

-(void) stop
{
	[sequenceOne stop];
	[sequenceTwo stop];
	[super stop];
}

-(void) update: (ccTime) t
{
	[sequenceOne update:t];
	[sequenceTwo update:t];
}

- (CCActionInterval *) reverse
{
	return [RecalculatingSpawn actionOne:[one reverse] two:[two reverse]];
}

@end
