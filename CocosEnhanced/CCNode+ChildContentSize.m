//
//  CCNode+ChildContentSize.m
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

#import "CCNode+ChildContentSize.h"
#import "LoadableCategory.h"


MAKE_CATEGORIES_LOADABLE(CCNode_ChildContentSize)


@implementation CCNode (ChildContentSize)

- (void) setContentSizeFromChildren {
	float minX = 1000000;
	float minY = 1000000;
	float maxX = -1000000;
	float maxY = -1000000;
	
	for(CCNode* node in children_) {
		float nextMinX = node.position.x - node.contentSize.width * node.scaleX * node.anchorPoint.x;
		float nextMaxX = nextMinX + node.contentSize.width * node.scaleX;
		float nextMinY = node.position.y - node.contentSize.height * node.scaleY * node.anchorPoint.y;
		float nextMaxY = nextMinY + node.contentSize.height * node.scaleY;
		
		if(nextMinX < minX) {
			minX = nextMinX;
		}
		if(nextMaxX > maxX) {
			maxX = nextMaxX;
		}
		if(nextMinY < minY) {
			minY = nextMinY;
		}
		if(nextMaxY > maxY) {
			maxY = nextMaxY;
		}
	}
	
	self.contentSize = CGSizeMake(maxX - minX, maxY - minY);
}

- (CGSize) minimalDimensionsForChildren {
	CGSize size = CGSizeMake(0, 0);
	
	for(CCNode* node in children_) {
		if(node.contentSize.width * node.scaleX > size.width) {
			size.width = node.contentSize.width * node.scaleX;
		}
		if(node.contentSize.height * node.scaleY > size.height) {
			size.height = node.contentSize.height * node.scaleY;
		}
	}
	
	return size;
}

@end
