//
//  TouchableNode.m
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

#import "TouchableNode.h"

@interface TouchableNode (Private)

- (void) unregisterWithTouchDispatcher;

@end

@implementation TouchableNode

@synthesize isTouchEnabled;
@synthesize touchPriority;
@synthesize targetedTouches;
@synthesize swallowTouches;

- (void) dealloc
{
	[self unregisterWithTouchDispatcher];
	
	[super dealloc];
}

-(void) registerWithTouchDispatcher
{
	[self unregisterWithTouchDispatcher];
	
	if(targetedTouches)
	{
		[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:touchPriority swallowsTouches:swallowTouches];
	}
	else 
	{
		[[CCTouchDispatcher sharedDispatcher] addStandardDelegate:self priority:touchPriority];
	}
	registeredWithDispatcher = YES;
}

- (void) unregisterWithTouchDispatcher
{
	if(registeredWithDispatcher)
	{
		[[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
		registeredWithDispatcher = NO;
	}
}

- (void) setTargetedTouches:(BOOL) value
{
	if(targetedTouches != value)
	{
		targetedTouches = value;
		
		if(isRunning_ && isTouchEnabled)
		{
			[self registerWithTouchDispatcher];
		}
	}
}

- (void) setSwallowTouches:(BOOL) value
{
	if(swallowTouches != value)
	{
		swallowTouches = value;
		
		if(isRunning_ && isTouchEnabled)
		{
			[self registerWithTouchDispatcher];
		}
	}
}

- (void) setTouchPriority:(int) value
{
	if(touchPriority != value)
	{
		touchPriority = value;
		if(isRunning_ && isTouchEnabled)
		{
			[self registerWithTouchDispatcher];
		}
	}
}

-(void) setIsTouchEnabled:(BOOL)enabled
{
	if( isTouchEnabled != enabled )
	{
		isTouchEnabled = enabled;
		if( isRunning_ )
		{
			if( isTouchEnabled )
			{
				[self registerWithTouchDispatcher];
			}
			else
			{
				[self unregisterWithTouchDispatcher];
			}
		}
	}
}

- (void)cleanup
{
	self.isTouchEnabled = NO;
}

#pragma mark TouchableNode - Callbacks
-(void) onEnter
{
	// register 'parent' nodes first
	// since events are propagated in reverse order
	if (isTouchEnabled)
	{
		[self registerWithTouchDispatcher];
	}
	
	// then iterate over all the children
	[super onEnter];
}

-(void) onExit
{
	if(isTouchEnabled)
	{
		[self unregisterWithTouchDispatcher];
	}
	
	[super onExit];
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
	NSAssert(NO, @"TouchableNode#ccTouchBegan override me");
	return YES;
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	NSAssert(NO, @"TouchableNode#ccTouchesBegan override me");
}

- (BOOL) touchHitsSelf:(UITouch*) touch
{
	return [self touch:touch hitsNode:self];
}

- (BOOL) touch:(UITouch*) touch hitsNode:(CCNode*) node
{
	CGRect r = CGRectMake(0, 0, node.contentSize.width, node.contentSize.height);
	CGPoint local = [node convertTouchToNodeSpace:touch];
	
	return CGRectContainsPoint(r, local);
}

@end
