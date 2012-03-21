//
//  Slider.h
//  CocosEnhanced
//
//  Created by Karl Stenerud on 10-05-30.
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

@class Slider;

/**
 * A slider control.  Contains a "knob" object, which slides along a "track" object.
 * Both the track and the knob are supplied at object creation time, and the slider
 * adjusts its contentSize according to the knob and track's size as well as their scale factor. <br>
 * This means that you can prescale the knob and/or track and still have a functioning slider.
 */
@interface Slider : TouchableNode <CCRGBAProtocol>
{
	CCNode* track;
	CCNode* knob;

	float lineLockock;
	float maxTravel;
	float minTravel;

	id target;
	SEL moveSelector;
	SEL dropSelector;
    
    void(^onMove)(Slider* slider);
    void(^onDrop)(Slider* slider);
	
	CCScaleTo* scaleUpAction;
	CCScaleTo* scaleDownAction;
}
/** The position (value) of the slider in the track, as a proportion from 0.0 to 1.0 */
@property(readwrite,assign) float value;

/** Create a slider.
 * @param track The node to use as a track.
 * @param knob The node to use as a knob.
 * @param target the target to notify of events.
 * @param moveSelector the selector to call when the knob is moved (nil = ignore).
 * @param dropSelector The selector to call when the knob is dropped (nil = ignore).
 * @return a new slider.
 */
+ (id) sliderWithTrack:(CCNode*) track knob:(CCNode*) knob target:(id) target moveSelector:(SEL) moveSelector dropSelector:(SEL) dropSelector;

/** Initialize a slider.
 * @param track The node to use as a track.
 * @param knob The node to use as a knob.
 * @param target the target to notify of events.
 * @param moveSelector the selector to call when the knob is moved (nil = ignore).
 * @param dropSelector The selector to call when the knob is dropped (nil = ignore).
 * @return The initialized slider.
 */
- (id) initWithTrack:(CCNode*) track knob:(CCNode*) knob target:(id) target moveSelector:(SEL) moveSelector dropSelector:(SEL) dropSelector;


+ (Slider*) sliderWithTrack:(CCNode*) track
                       knob:(CCNode*) knob
                     onMove:(void(^)(Slider* slider)) moveBlock
                     onDrop:(void(^)(Slider* slider)) dropBlock;

- (id) initWithTrack:(CCNode*) track
                knob:(CCNode*) knob
              onMove:(void(^)(Slider* slider)) moveBlock
              onDrop:(void(^)(Slider* slider)) dropBlock;

@end

/**
 * A slider that operates in the vertical direction.
 */
@interface VerticalSlider: Slider
{
	float horizontalLock;
	float verticalMax;
	float verticalMin;
}

@end


/**
 * A slider that operates in the horizontal direction.
 */
@interface HorizontalSlider: Slider
{
	float verticalLock;
	float horizontalMax;
	float horizontalMin;
}

@end
