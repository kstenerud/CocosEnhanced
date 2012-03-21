//
//  Environment.m
//  CocosEnhanced
//
//  Created by Karl Stenerud on 14/11/09.
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

#import "Environment.h"

SYNTHESIZE_SINGLETON_FOR_CLASS_PROTOTYPE(Environment);

@implementation Environment

SYNTHESIZE_SINGLETON_FOR_CLASS(Environment);

@synthesize screenSize;
@synthesize screenArea;
@synthesize screenCenter;

- (BOOL)isIpad
{
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
}

- (void) setScreenSize:(CGSize) screenSizeIn
{
	screenSize = screenSizeIn;
	screenArea = CGRectMake(0, 0, screenSize.width, screenSize.height);
	screenCenter = ccp(screenSize.width/2, screenSize.height/2);
}

- (CGPoint) fromCenterX:(float) x y:(float) y
{
	return ccp(screenCenter.x + x, screenCenter.y + y);
}

- (CGPoint) fromBottomLeftX:(float) x y:(float) y
{
	return ccp(x, y);
}

- (CGPoint) fromBottomRightX:(float) x y:(float) y
{
	return ccp(screenSize.width - x, y);
}

- (CGPoint) fromTopLeftX:(float) x y:(float) y
{
	return ccp(x, screenSize.height - y);
}

- (CGPoint) fromTopRightX:(float) x y:(float) y
{
	return ccp(screenSize.width - x, screenSize.height - y);
}

- (CGPoint) fromTopMiddleX:(float) x y:(float) y
{
	return ccp(screenSize.width/2 + x, screenSize.height - y);
}

- (CGPoint) fromBottomMiddleX:(float) x y:(float) y
{
	return ccp(screenSize.width/2 + x, y);
}

- (CGPoint) fromLeftMiddleX:(float) x y:(float) y
{
	return ccp(x, screenSize.height/2 + y);
}

- (CGPoint) fromRightMiddleX:(float) x y:(float) y
{
	return ccp(screenSize.width - x, screenSize.height/2 + y);
}



- (CGPoint) propFromCenterX:(float) x y:(float) y
{
	return ccp(screenCenter.x + x*screenSize.width, screenCenter.y + y*screenSize.height);
}

- (CGPoint) propFromBottomLeftX:(float) x y:(float) y
{
	return ccp(x*screenSize.width, y*screenSize.height);
}

- (CGPoint) propFromBottomRightX:(float) x y:(float) y
{
	return ccp(screenSize.width - x*screenSize.width, y*screenSize.height);
}

- (CGPoint) propFromTopLeftX:(float) x y:(float) y
{
	return ccp(x*screenSize.width, screenSize.height - y*screenSize.height);
}

- (CGPoint) propFromTopRightX:(float) x y:(float) y
{
	return ccp(screenSize.width - x*screenSize.width, screenSize.height - y*screenSize.height);
}

- (CGPoint) propFromTopMiddleX:(float) x y:(float) y
{
	return ccp(screenSize.width/2 + x*screenSize.width, screenSize.height - y*screenSize.height);
}

- (CGPoint) propFromBottomMiddleX:(float) x y:(float) y
{
	return ccp(screenSize.width/2 + x*screenSize.width, y*screenSize.height);
}

- (CGPoint) propFromLeftMiddleX:(float) x y:(float) y
{
	return ccp(x*screenSize.width, screenSize.height/2 + y*screenSize.height);
}

- (CGPoint) propFromRightMiddleX:(float) x y:(float) y
{
	return ccp(screenSize.width - x*screenSize.width, screenSize.height/2 + y*screenSize.height);
}

@end
