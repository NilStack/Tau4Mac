//
//  TauValueTransformers.m
//  Tau4Mac
//
//  Created by Tong G. on 4/1/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauValueTransformers.h"

// TauTextViewAttributedStringTransformer class
@implementation TauTextViewAttributedStringTransformer

+ ( Class ) transformedValueClass
    {
    return [ NSAttributedString class ];
    }

- ( id ) transformedValue: ( NSString* )_Value
    {
    NSString* text = ( _Value.length > 0 ) ? _Value : NSLocalizedString( @"No Description", nil );

    NSMutableParagraphStyle* ps = [ [ NSMutableParagraphStyle defaultParagraphStyle ] mutableCopy ];
    [ ps setLineSpacing: 4.f ];

    return [ [ NSAttributedString alloc ] initWithString: text attributes:
        @{ NSFontAttributeName : [ NSFont fontWithName: @"Helvetica Neue Light" size: 13.f ]
         , NSForegroundColorAttributeName : [ [ NSColor blackColor ] colorWithAlphaComponent: .5f ]
         , NSParagraphStyleAttributeName : ps
         } ];
    }
@end // TauTextViewAttributedStringTransformer class