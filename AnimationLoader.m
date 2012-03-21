//
//  AnimationLoader.m
//  CocosEnhanced
//
//  Created by Karl Stenerud on 10-07-09.
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

#import "AnimationLoader.h"
#import "FileTools.h"

@implementation AnimationLoader

+ (AnimationLoader *)sharedInstance
{
    static dispatch_once_t once;
    static AnimationLoader *instance;
    dispatch_once(&once, ^ { instance = [[AnimationLoader alloc] init]; });
    return instance;
}

- (CCAnimation*) loadAnimation:(NSString*) frameBaseName fps:(float) framesPerSecond
{
    NSArray* filenames = [self imageFilenamesForAnimation:frameBaseName];
    if([filenames count] == 0)
    {
        NSLog(@"Animation not found: %@", frameBaseName);
        return nil;
    }
    
    NSMutableArray* frames = [NSMutableArray arrayWithCapacity:[filenames count]];
    for(NSString* filename in filenames)
    {
        CCSpriteFrame* frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:filename];
        if(nil == frame)
        {
            CCTexture2D *texture = [[CCTextureCache sharedTextureCache] addImage:filename];
            
            if(nil == texture)
            {
                NSLog(@"Could not load animation frame %@", filename);
                return nil;
            }
            
            frame = [CCSpriteFrame frameWithTexture:texture rect:CGRectMake(0, 0, texture.contentSize.width, texture.contentSize.height)];
        }
        [frames addObject:frame];
    }
    return [CCAnimation animationWithFrames:frames delay:1.0f/framesPerSecond];
}

- (CCSprite*) firstAnimationFrame:(NSString*) frameBaseName
{
    NSArray* filenames = [self imageFilenamesForAnimation:frameBaseName];
    if([filenames count] == 0)
    {
        NSLog(@"Animation not found: %@", frameBaseName);
        return nil;
    }
    return [CCSprite spriteWithSpriteFrameName:[filenames objectAtIndex:0]];
}

- (NSString*) filenameFormatForBaseName:(NSString*) frameBaseName
{
	static NSString* formats[] = {@"png", @"jpg"};
	NSString* fmt = nil;

	for(int format = 0; format < 2; format++)
	{
		for(int zeroes = 1; zeroes < 6; zeroes++)
		{
			fmt = [NSString stringWithFormat:@"%@%%0%dd.%@", frameBaseName, zeroes, formats[format]];
			NSString* filename = [NSString stringWithFormat:fmt, 0];
			if(nil != [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:filename] || [FileTools fileExists:filename])
			{
				return fmt;
			}
		}
	}
	return nil;
}

- (NSArray*) imageFilenamesForAnimation:(NSString*) frameBaseName
{
	NSMutableArray* filenames = [NSMutableArray arrayWithCapacity:20];

	NSString* fmt = [self filenameFormatForBaseName:frameBaseName];
	
	if(nil != fmt)
	{
		for(int i = 0;;i++)
		{
			NSString* filename = [NSString stringWithFormat:fmt, i];
			if(nil == [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:filename] && ![FileTools fileExists:filename])
			{
				break;
			}
			[filenames addObject:filename];
		}
	}
	return filenames;
}

@end
