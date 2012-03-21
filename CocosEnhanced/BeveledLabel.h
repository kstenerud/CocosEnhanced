//
//  BeveledLabel.h
//  CocosEnhanced
//
//  Created by Karl Stenerud on 10-03-19.
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

/** 2-color label, with one color of text offset 1 pixel to the bottom.
 */
@interface BeveledLabel : CCNode
{
	CCLabelTTF* bgLabel;
	CCLabelTTF* fgLabel;
	float spacing;
}
@property (nonatomic,readwrite) GLubyte opacity;
@property(nonatomic,readwrite) ccColor3B fgColor;
@property(nonatomic,readwrite) ccColor3B bgColor;

/** creates a label from a fontname, alignment, dimension and font size */
+ (id) labelWithString:(NSString*)string
			dimensions:(CGSize)dimensions
			 alignment:(UITextAlignment)alignment
			  fontName:(NSString*)name
			  fontSize:(CGFloat)size
			   fgColor:(ccColor3B)fgColor
			   bgColor:(ccColor3B)bgColor
			   spacing:(float)spacing;

/** creates a label from a fontname and font size */
+ (id) labelWithString:(NSString*)string
			  fontName:(NSString*)name
			  fontSize:(CGFloat)size
			   fgColor:(ccColor3B)fgColor
			   bgColor:(ccColor3B)bgColor
			   spacing:(float)spacing;

/** initializes the label with a font name, alignment, dimension and font size */
- (id) initWithString:(NSString*)string
		   dimensions:(CGSize)dimensions
			alignment:(UITextAlignment)alignment
			 fontName:(NSString*)name
			 fontSize:(CGFloat)size
			  fgColor:(ccColor3B)fgColor
			  bgColor:(ccColor3B)bgColor
			  spacing:(float)spacing;

/** initializes the label with a font name and font size */
- (id) initWithString:(NSString*)string
			 fontName:(NSString*)name
			 fontSize:(CGFloat)size
			  fgColor:(ccColor3B)fgColor
			  bgColor:(ccColor3B)bgColor
			  spacing:(float)spacing;

/** creates an adjusted label from a fontname, alignment, dimension and font size */
+ (id) adjustedLabelWithString:(NSString*)string
					dimensions:(CGSize)dimensions
					 alignment:(UITextAlignment)alignment
					  fontName:(NSString*)name
					  fontSize:(CGFloat)size
					   fgColor:(ccColor3B)fgColor
					   bgColor:(ccColor3B)bgColor
					   spacing:(float)spacing;

/** creates an adjusted label from a fontname and font size */
+ (id) adjustedLabelWithString:(NSString*)string
					  fontName:(NSString*)name
					  fontSize:(CGFloat)size
					   fgColor:(ccColor3B)fgColor
					   bgColor:(ccColor3B)bgColor
					   spacing:(float)spacing;

/** initializes the adjusted label with a font name, alignment, dimension and font size */
- (id) initAdjustedWithString:(NSString*)string
				   dimensions:(CGSize)dimensions
					alignment:(UITextAlignment)alignment
					 fontName:(NSString*)name
					 fontSize:(CGFloat)size
					  fgColor:(ccColor3B)fgColor
					  bgColor:(ccColor3B)bgColor
					  spacing:(float)spacing;

/** initializes the adjusted label with a font name and font size */
- (id) initAdjustedWithString:(NSString*)string
					 fontName:(NSString*)name
					 fontSize:(CGFloat)size
					  fgColor:(ccColor3B)fgColor
					  bgColor:(ccColor3B)bgColor
					  spacing:(float)spacing;


/** changes the string to render
 * @warning Changing the string is as expensive as creating a new Label. To obtain better performance use LabelAtlas
 */
- (void) setString:(NSString*)string;

@end
