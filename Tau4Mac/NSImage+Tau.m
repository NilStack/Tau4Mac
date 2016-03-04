//
//  NSImage+Tau.m
//  Tau4Mac
//
//  Created by Tong G. on 3/4/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "NSImage+Tau.h"

@implementation NSImage ( Tau )

// Gaussian Blur
- ( NSImage* ) gaussianBluredOfRadius: ( CGFloat )_Radius
    {
    NSImage* bluredImage = nil;

    CIImage* beginImage = [ [ CIImage alloc ] initWithData: [ self TIFFRepresentation ] ];
    CIFilter* filter = [ CIFilter filterWithName: @"CIGaussianBlur" keysAndValues: kCIInputImageKey, beginImage, @"inputRadius", @( _Radius ), nil ];
    CIImage* output = [ filter valueForKey: @"outputImage" ];

    NSRect bluredImageRect = NSMakeRect( 0, 0, self.size.width, self.size.height );
    bluredImage = [ [ NSImage alloc ] initWithSize: bluredImageRect.size ];

    [ bluredImage lockFocus ];
        [ output drawAtPoint: NSZeroPoint fromRect: bluredImageRect operation: NSCompositeCopy fraction: 1.0 ];
    [ bluredImage unlockFocus ];
    
    return bluredImage;
    }

@end
