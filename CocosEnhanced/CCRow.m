//
//  CCRow.m
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

#import "CCRow.h"
#import "CGPointExtension.h"


#define kPathContentSize @"contentSize"
#define kPathScale @"scale"
#define kPathScaleX @"scaleX"
#define kPathScaleY @"scaleY"


@interface CCRow (Private)

- (void) alignChildren;

- (void) addObserversToChild:(CCNode*) child;

- (void) removeObserversFromChild:(CCNode*) child;

@end


@implementation CCRow

+ (id) rowWithSpacing:(float) spacing alignment:(UIControlContentVerticalAlignment) alignment
{
	return [[[self alloc] initWithSpacing:spacing alignment:alignment] autorelease];
}

- (id) initWithSpacing:(float) spacingIn alignment:(UIControlContentVerticalAlignment) alignmentIn
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

- (void) child:(CCNode *)child resizedFrom:(CGSize)size
{
    if(respondToChildResize)
    {
        [self alignChildren];
    }
}

- (void) child:(CCNode *)child changedScaleFromX:(CGFloat)scaleX y:(CGFloat)y
{
    if(respondToChildResize)
    {
        [self alignChildren];
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
	float maxHeight = 0;
	float totalWidth = 0;
	
	// Calculate the required containing size.
	for(CCNode* node in self.children)
	{
        CGFloat realWidth = effectiveWidth(node);
        CGFloat realHeight = effectiveHeight(node);
		if(realHeight > maxHeight)
		{
			maxHeight = realHeight;
		}
		totalWidth += realWidth + spacing;
	}
	totalWidth -= spacing;
	if(totalWidth < 0)
	{
		totalWidth = 0;
	}
	
	
	self.contentSize = CGSizeMake(totalWidth, maxHeight);
	
	// Align the child nodes
	float halfHeight = self.contentSize.height / 2;
	float currentX = 0;
	float yPosition;
	for(CCNode* node in self.children)
	{
        CGFloat realWidth = effectiveWidth(node);
        CGFloat realHeight = effectiveHeight(node);
        
		node.anchorPoint = ccp(0.5,0.5);
		switch (alignment)
		{
			case UIControlContentVerticalAlignmentTop:
				yPosition = realHeight/2;
				break;
			case UIControlContentVerticalAlignmentBottom:
				yPosition = self.contentSize.height - realHeight/2;
				break;
			case UIControlContentVerticalAlignmentCenter:
			default:
				yPosition = halfHeight;
				break;
		}
		node.position = ccp(currentX+(realWidth/2), yPosition);
		currentX += realWidth + spacing;
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
