//
//  TargetedAction.m
//  CocosEnhanced
//
//  Created by Karl Stenerud on 09-12-24.
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

#import "TargetedAction.h"

@interface TargetedAction (Private)

// Ugly hack to get around a compiler bug.
- (id) initWithTarget:(id) targetIn actionByAnotherName:(CCFiniteTimeAction*) actionIn;

@end


@implementation TargetedAction

@synthesize forcedTarget;

+ (id) actionWithTarget:(id) target action:(CCFiniteTimeAction*) action
{
	return [[[self alloc] initWithTarget:target actionByAnotherName:action] autorelease];
}

- (id) initWithTarget:(id) targetIn action:(CCFiniteTimeAction*) actionIn
{
	return [self initWithTarget:targetIn actionByAnotherName:actionIn];
}

- (id) initWithTarget:(id) targetIn actionByAnotherName:(CCFiniteTimeAction*) actionIn
{
	if(nil != (self = [super initWithDuration:actionIn.duration]))
	{
		forcedTarget = [targetIn retain];
		action = [actionIn retain];
	}
	return self;
}

- (void) dealloc
{
	[forcedTarget release];
	[action release];
	[super dealloc];
}

- (void) updateDuration:(id)aTarget
{
	[action updateDuration:forcedTarget];
	duration_ = action.duration;
}

- (void) startWithTarget:(id)aTarget
{
	[super startWithTarget:forcedTarget];
	[action startWithTarget:forcedTarget];
}

- (void) stop
{
	[action stop];
}

- (void) update:(ccTime) time
{
	[action update:time];
}

@end
