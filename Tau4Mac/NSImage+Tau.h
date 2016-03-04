//
//  NSImage+Tau.h
//  Tau4Mac
//
//  Created by Tong G. on 3/4/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

// NSImage + Tau
@interface NSImage ( Tau )

// Gaussian Blur
- ( NSImage* ) gaussianBluredOfRadius: ( CGFloat )_Radius;

@end // NSImage + Tau