//
//  Environment.h
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

#import "cocos2d.h"
#import "SynthesizeSingleton.h"

/** Helper for global enviromnental data
 */
@interface Environment : NSObject
{
	CGSize screenSize;
	CGRect screenArea;
	CGPoint screenCenter;
}
/** The current screen size (size of the iPhone display, in current orientation) */
@property(nonatomic,readwrite,assign) CGSize screenSize;
/** The current screen area.  This is basically screenSize with origin 0,0 */
@property(nonatomic,readonly) CGRect screenArea;
/** The center of the screen */
@property(nonatomic,readonly) CGPoint screenCenter;

SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(Environment);

- (BOOL)isIpad;

// Get a position relative to a screen area.
- (CGPoint) fromCenterX:(float) x y:(float) y;
- (CGPoint) fromBottomLeftX:(float) x y:(float) y;
- (CGPoint) fromBottomRightX:(float) x y:(float) y;
- (CGPoint) fromTopLeftX:(float) x y:(float) y;
- (CGPoint) fromTopRightX:(float) x y:(float) y;
- (CGPoint) fromTopMiddleX:(float) x y:(float) y;
- (CGPoint) fromBottomMiddleX:(float) x y:(float) y;
- (CGPoint) fromLeftMiddleX:(float) x y:(float) y;
- (CGPoint) fromRightMiddleX:(float) x y:(float) y;

- (CGPoint) propFromCenterX:(float) x y:(float) y;
- (CGPoint) propFromBottomLeftX:(float) x y:(float) y;
- (CGPoint) propFromBottomRightX:(float) x y:(float) y;
- (CGPoint) propFromTopLeftX:(float) x y:(float) y;
- (CGPoint) propFromTopRightX:(float) x y:(float) y;
- (CGPoint) propFromTopMiddleX:(float) x y:(float) y;
- (CGPoint) propFromBottomMiddleX:(float) x y:(float) y;
- (CGPoint) propFromLeftMiddleX:(float) x y:(float) y;
- (CGPoint) propFromRightMiddleX:(float) x y:(float) y;

@end
