//
//  TouchableNode.h
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

#import "cocos2d.h"

/**
 * A node that can respond to touches.
 * This code was extracted from CCLayer.
 */
@interface TouchableNode : CCNode <CCStandardTouchDelegate, CCTargetedTouchDelegate>
{
	BOOL isTouchEnabled;
	int touchPriority;
	BOOL targetedTouches;
	BOOL swallowTouches;
	BOOL registeredWithDispatcher;
}
/** Priority position in which this node will be handled (lower = sooner) */
@property(nonatomic,readwrite,assign) int touchPriority;

@property(nonatomic,readwrite,assign) BOOL targetedTouches;
@property(nonatomic,readwrite,assign) BOOL swallowTouches;

/** whether or not it will receive Touch events.
 You can enable / disable touch events with this property.
 Only the touches of this node will be affected. This "method" is not propagated to it's children.
 @since v0.8.1
 */
@property(nonatomic,assign) BOOL isTouchEnabled;

- (BOOL) touchHitsSelf:(UITouch*) touch;
- (BOOL) touch:(UITouch*) touch hitsNode:(CCNode*) node;

@end
