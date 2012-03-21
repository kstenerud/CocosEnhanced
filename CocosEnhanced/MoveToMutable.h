//
//  MoveToMutable.h
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

#import "cocos2d.h"

/** MoveToMutable is a MoveTo action that allows the end position to be modified.
 * Duration will be automatically modified to match the end position and rate of movement (pixelsPerSecond).
 * If pixelsPerSecond is 0, the duration value will not be updated.
 *
 * Note: If duration is specified during initialization, or duration is set via its property,
 * pixels per second will revert to 0, and no recalculation of duration will occur.
 */
@interface MoveToMutable : CCMoveTo <NSCopying>
{
	float pixelsPerSecond;
	bool needsDurationUpdate;
    CGPoint endPosition;
}
/** the position to move to */
@property (readwrite,assign) CGPoint endPosition;
/** The rate of movement */
@property (readwrite,assign) float pixelsPerSecond;

/** Create an action, specifying pixels per second */
+ (id) actionWithPixelsPerSecond:(float) pixelsPerSecond position:(CGPoint) position;
/** Create an action, specifying duration */
+ (id) actionWithDuration:(ccTime) duration position:(CGPoint) position;

/** Initialize an action, specifying pixels per second */
- (id) initWithPixelsPerSecond:(float) pixelsPerSecond position:(CGPoint) position;
/** Initialize an action, specifying duration */
- (id) initWithDuration:(ccTime) duration position:(CGPoint) position;

@end
