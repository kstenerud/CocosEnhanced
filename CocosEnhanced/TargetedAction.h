//
//  TargetedAction.h
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

#import "cocos2d.h"

/** Overrides the target of an action so that it always runs on the target
 * specified at action creation rather than the one specified by runAction.
 */
@interface TargetedAction : CCActionInterval <NSCopying>
{
	id forcedTarget;
	CCFiniteTimeAction* action;
}
/** This is the target that the action will be forced to run with */
@property(readwrite,retain) id forcedTarget;

/** Create an action with the specified action and forced target */
+ (id) actionWithTarget:(id) target action:(CCFiniteTimeAction*) action;

/** Init an action with the specified action and forced target */
- (id) initWithTarget:(id) target action:(CCFiniteTimeAction*) action;

@end
