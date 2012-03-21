//
//  CCColumn.m
//  CocosEnhanced
//
//  Created by Karl Stenerud on 09-10-08.
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

#import "CCColumn.h"
#import "CGPointExtension.h"


#define kPathContentSize @"contentSize"
#define kPathScale @"scale"
#define kPathScaleX @"scaleX"
#define kPathScaleY @"scaleY"


@interface CCColumn (Private)

- (void) alignChildren;

- (void) addObserversToChild:(CCNode*) child;

- (void) removeObserversFromChild:(CCNode*) child;

@end


@implementation CCColumn

+ (id) columnWithSpacing:(float) spacing alignment:(UIControlContentHorizontalAlignment) alignment
{
	return [[[self alloc] initWithSpacing:spacing alignment:alignment] autorelease];
}

- (id) initWithSpacing:(float) spacingIn alignment:(UIControlContentHorizontalAlignment) alignmentIn
{
	if(nil != (self = [super init]))
	{
		opacity = 255;
		spacing = spacingIn;
		alignment = alignmentIn;
        respondToChildResize = YES;
	}
	return self;
}

- (void) dealloc
{
    for(CCNode* child in self.children)
    {
        [self removeObserversFromChild:child];
    }
    [super dealloc];
}

@synthesize respondToChildResize = respondToChildResize;

- (void) addObserversToChild:(CCNode*) child
{
    [child addObserver:self
            forKeyPath:kPathContentSize
               options:NSKeyValueObservingOptionNew
               context:NULL];
    [child addObserver:self
            forKeyPath:kPathScale
               options:NSKeyValueObservingOptionNew
               context:NULL];
    [child addObserver:self
            forKeyPath:kPathScaleX
               options:NSKeyValueObservingOptionNew
               context:NULL];
    [child addObserver:self
            forKeyPath:kPathScaleY
               options:NSKeyValueObservingOptionNew
               context:NULL];
}

- (void) removeObserversFromChild:(CCNode*) child
{
    [child removeObserver:self forKeyPath:kPathContentSize];
    [child removeObserver:self forKeyPath:kPathScale];
    [child removeObserver:self forKeyPath:kPathScaleX];
    [child removeObserver:self forKeyPath:kPathScaleY];
}

- (void) addChild:(CCNode *)node z:(NSInteger)z tag:(NSInteger)tagIn
{
	[super addChild:node z:z tag:tagIn];
	[self alignChildren];
    [self addObserversToChild:node];
}

- (void) removeChild:(CCNode *)node cleanup:(BOOL)cleanup
{
    [self removeObserversFromChild:node];
	[super removeChild:node cleanup:cleanup];
	[self alignChildren];
}

- (void) removeChild:(CCNode *)node cleanup:(BOOL)cleanup realign:(BOOL)realign
{
    [self removeObserversFromChild:node];
    [super removeChild:node cleanup:cleanup];
    if (realign)
        [self alignChildren];
}

- (GLubyte) opacity
{
	return opacity;
}

- (void) setOpacity:(GLubyte) value
{
	opacity = value;
	for(CCNode* node in self.children)
	{
		if([node respondsToSelector:@selector(setOpacity:)])
		{
			// Cast to CCRGBAProtocol to get the compiler to shut up.
			// This object doesn't actually conform to CCRGBAProtocol, but CCRGBAProtocol has setOpacity.
			[((id<CCRGBAProtocol>)node) setOpacity:opacity];
		}
	}
}

static CGFloat effectiveWidth(CCNode* node)
{
    return node.contentSize.width * node.scaleX;
}

static CGFloat effectiveHeight(CCNode* node)
{
    return node.contentSize.height * node.scaleY;
}

- (void) alignChildren
{
	float maxWidth = 0;
	float totalHeight = 0;
	
	// Calculate the required containing size.
	for(CCNode* node in self.children)
	{
        CGFloat realWidth = effectiveWidth(node);
		if(realWidth > maxWidth)
		{
			maxWidth = realWidth;
		}
		totalHeight += effectiveHeight(node) + spacing;
	}
	totalHeight -= spacing;
	if(totalHeight < 0)
	{
		totalHeight = 0;
	}
	
	self.contentSize = CGSizeMake(maxWidth, totalHeight);
	
	// Align the child nodes
	float halfWidth = self.contentSize.width / 2;
	float currentY = self.contentSize.height;
	float xPosition;
	for(CCNode* node in self.children)
	{
        CGFloat realWidth = effectiveWidth(node);
        CGFloat realHeight = effectiveHeight(node);
        
		node.anchorPoint = ccp(0.5,0.5);
		switch (alignment)
        {
			case UIControlContentHorizontalAlignmentCenter:
				xPosition = halfWidth;
				break;
			case UIControlContentHorizontalAlignmentLeft:
				xPosition = realWidth/2;
				break;
			case UIControlContentHorizontalAlignmentRight:
				xPosition = self.contentSize.width - realWidth/2;
				break;
			default:
				xPosition = halfWidth;
				break;
		}
		node.position = ccp(xPosition, currentY - realHeight/2);
		currentY -= realHeight + spacing;
	}
}

- (void) observeValueForKeyPath:(NSString *)keyPath
                       ofObject:(id)object
                         change:(NSDictionary *)change
                        context:(void *)context
{
    if(respondToChildResize)
    {
        [self alignChildren];
    }
}

@end
