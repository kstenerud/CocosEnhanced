//
//  CCResizeAction.m
//  CocosEnhanced
//
//  Created by Karl Stenerud on 10-01-24.
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

#import "CCResizeAction.h"

@implementation CCResizeTo

+(id) actionWithDuration:(ccTime) duration size:(CGSize) size
{	
	return [[[self alloc] initWithDuration:duration size:size] autorelease];
}

-(id) initWithDuration:(ccTime) duration size:(CGSize) size
{
	if((self=[super initWithDuration:duration]))
    {
		_endSize = size;
	}
	return self;
}

-(id) copyWithZone:(NSZone*) zone
{
	return [[[self class] allocWithZone: zone] initWithDuration:[self duration]
                                                           size:_endSize];
}

-(void) startWithTarget:(CCNode*) target
{
	[super startWithTarget:target];
	_startSize = [(CCNode*)target_ contentSize];
    _delta = CGSizeMake(_endSize.width - _startSize.width,
                        _endSize.height - _startSize.height);
}

-(void) update: (ccTime) t
{
    [target_ setContentSize:CGSizeMake(_startSize.width + _delta.width * t,
                                       _startSize.height + _delta.height * t)];
}

@end

@implementation CCResizeBy

+(id) actionWithDuration:(ccTime) duration size:(CGSize) size
{	
	return [[[self alloc] initWithDuration:duration size:size] autorelease];
}

-(id) initWithDuration:(ccTime) duration size:(CGSize) size
{
	if( (self=[super initWithDuration:duration]) )
		_delta = size;
	
	return self;
}

-(id) copyWithZone: (NSZone*) zone
{
	return [[[self class] allocWithZone: zone] initWithDuration:[self duration]
                                                           size:_delta];
}

-(void) startWithTarget:(CCNode *) aTarget
{
	CGSize tmp = _delta;
	[super startWithTarget:aTarget];
	_delta = tmp;
}

-(CCActionInterval*) reverse
{
	return [[self class] actionWithDuration:duration_ size:CGSizeMake(-_delta.width, -_delta.height)];
}

@end
