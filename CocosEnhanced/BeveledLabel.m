//
//  BeveledLabel.m
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

#import "BeveledLabel.h"
#import "CocosEnhanced.h"

@interface BeveledLabel (Private)

- (id) initWithFgLabel:(CCLabelTTF*) fgLabel bgLabel:(CCLabelTTF*) bgLabel spacing:(float) spacing;

@end

@implementation BeveledLabel


+ (id) labelWithString:(NSString*)string
			dimensions:(CGSize)dimensions
			 alignment:(UITextAlignment)alignment
			  fontName:(NSString*)name
			  fontSize:(CGFloat)size
			   fgColor:(ccColor3B)fgColor
			   bgColor:(ccColor3B)bgColor
			   spacing:(float)spacing
{
	return [[[self alloc] initWithString:string
							  dimensions:dimensions
							   alignment:alignment
								fontName:name
								fontSize:size
								 fgColor:fgColor
								 bgColor:bgColor
								 spacing:spacing] autorelease];
}

+ (id) labelWithString:(NSString*)string
			  fontName:(NSString*)name
			  fontSize:(CGFloat)size
			   fgColor:(ccColor3B)fgColor
			   bgColor:(ccColor3B)bgColor
			   spacing:(float)spacing
{
	return [[[self alloc] initWithString:string
								fontName:name
								fontSize:size
								 fgColor:fgColor
								 bgColor:bgColor
								 spacing:spacing] autorelease];
}

- (id) initWithString:(NSString*)string
			 fontName:(NSString*)name
			 fontSize:(CGFloat)size
			  fgColor:(ccColor3B)fgColor
			  bgColor:(ccColor3B)bgColor
			  spacing:(float)spacingIn
{
	CCLabelTTF* bg = [CCLabelTTF labelWithString:string fontName:name fontSize:size];
	bg.color = bgColor;
	CCLabelTTF* fg = [CCLabelTTF labelWithString:string fontName:name fontSize:size];
	fg.color = fgColor;
	
	return [self initWithFgLabel:fg bgLabel:bg spacing:spacingIn];
}

- (id) initWithString:(NSString*)string
		   dimensions:(CGSize)dimensions
			alignment:(UITextAlignment)alignment
			 fontName:(NSString*)name
			 fontSize:(CGFloat)size
			  fgColor:(ccColor3B)fgColor
			  bgColor:(ccColor3B)bgColor
			  spacing:(float)spacingIn
{
	CCLabelTTF* bg = [CCLabelTTF labelWithString:string dimensions:dimensions alignment:alignment fontName:name fontSize:size];
	bg.color = bgColor;
	CCLabelTTF* fg = [CCLabelTTF labelWithString:string dimensions:dimensions alignment:alignment fontName:name fontSize:size];
	fg.color = fgColor;
	
	return [self initWithFgLabel:fg bgLabel:bg spacing:spacingIn];
}

+ (id) adjustedLabelWithString:(NSString*)string
					dimensions:(CGSize)dimensions
					 alignment:(UITextAlignment)alignment
					  fontName:(NSString*)name
					  fontSize:(CGFloat)size
					   fgColor:(ccColor3B)fgColor
					   bgColor:(ccColor3B)bgColor
					   spacing:(float)spacing
{
	return [[[self alloc] initAdjustedWithString:string
									  dimensions:dimensions
									   alignment:alignment
										fontName:name
										fontSize:size
										 fgColor:fgColor
										 bgColor:bgColor
										 spacing:spacing] autorelease];
}

+ (id) adjustedLabelWithString:(NSString*)string
					  fontName:(NSString*)name
					  fontSize:(CGFloat)size
					   fgColor:(ccColor3B)fgColor
					   bgColor:(ccColor3B)bgColor
					   spacing:(float)spacing
{
	return [[[self alloc] initAdjustedWithString:string
										fontName:name
										fontSize:size
										 fgColor:fgColor
										 bgColor:bgColor
										 spacing:spacing] autorelease];
}

- (id) initAdjustedWithString:(NSString*)string
					 fontName:(NSString*)name
					 fontSize:(CGFloat)size
					  fgColor:(ccColor3B)fgColor
					  bgColor:(ccColor3B)bgColor
					  spacing:(float)spacingIn
{
	CCLabelTTF* bg = [CCLabelTTF labelWithString:string fontName:name fontSize:size];
	bg.color = bgColor;
	CCLabelTTF* fg = [CCLabelTTF labelWithString:string fontName:name fontSize:size];
	fg.color = fgColor;
	
	return [self initWithFgLabel:fg bgLabel:bg spacing:spacingIn];
}

- (id) initAdjustedWithString:(NSString*)string
				   dimensions:(CGSize)dimensions
					alignment:(UITextAlignment)alignment
					 fontName:(NSString*)name
					 fontSize:(CGFloat)size
					  fgColor:(ccColor3B)fgColor
					  bgColor:(ccColor3B)bgColor
					  spacing:(float)spacingIn
{
	CCLabelTTF* bg = [CCLabelTTF labelWithString:string dimensions:dimensions alignment:alignment fontName:name fontSize:size];
	bg.color = bgColor;
	CCLabelTTF* fg = [CCLabelTTF labelWithString:string dimensions:dimensions alignment:alignment fontName:name fontSize:size];
	fg.color = fgColor;
	
	return [self initWithFgLabel:fg bgLabel:bg spacing:spacingIn];
}

- (id) initWithFgLabel:(CCLabelTTF*) fgLabelIn bgLabel:(CCLabelTTF*) bgLabelIn spacing:(float)spacingIn
{
	if(nil != (self = [super init]))
	{
		bgLabel = bgLabelIn;
		fgLabel = fgLabelIn;
		spacing = spacingIn;
		
		fgLabel.anchorPoint = ccp(0.5,0.5);
		bgLabel.anchorPoint = ccp(0.5,0.5);
		
		fgLabel.position = ccp(fgLabel.contentSize.width/2,
							   fgLabel.contentSize.height/2 + spacing);
		bgLabel.position = ccp(bgLabel.contentSize.width/2, bgLabel.contentSize.height/2);
		
		[self addChild:fgLabel z:10];
		[self addChild:bgLabel z:5];
		
		self.anchorPoint = ccp(0.5, 0.5);
		
		[self setContentSizeFromChildren];
	}
	return self;
}

- (GLubyte) opacity
{
	return fgLabel.opacity;
}

- (void) setOpacity:(GLubyte) value
{
	fgLabel.opacity = value;
	bgLabel.opacity = value;
}

- (void) setString:(NSString*)string
{
	[bgLabel setString:string];
	[fgLabel setString:string];

	fgLabel.position = ccp(fgLabel.contentSize.width/2,
						   fgLabel.contentSize.height/2 + spacing);
	bgLabel.position = ccp(bgLabel.contentSize.width/2, bgLabel.contentSize.height/2);
	
	[self setContentSizeFromChildren];
}

- (ccColor3B) fgColor
{
    return fgLabel.color;
}

- (void) setFgColor:(ccColor3B)color
{
    fgLabel.color = color;
}

- (ccColor3B) bgColor
{
    return bgLabel.color;
}

- (void) setBgColor:(ccColor3B)color
{
    bgLabel.color = color;
}

@end
