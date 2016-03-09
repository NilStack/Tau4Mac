//
//  TauEntryMosEnteredInteractionView.m
//  Tau4Mac
//
//  Created by Tong G. on 3/9/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauEntryMosEnteredInteractionView.h"

// TauEntryMosEnteredInteractionView class
@implementation TauEntryMosEnteredInteractionView

#pragma mark - Initializations

- ( instancetype ) initWithGTLObject: ( GTLObject* )_GTLObject host: ( TauYouTubeEntryView* )_EntryView
    {
    if ( self = [ super initWithGTLObject: _GTLObject host: _EntryView ] )
        self.layer.backgroundColor = [ [ NSColor blackColor ] colorWithAlphaComponent: .8f ].CGColor;

    return self;
    }

@end // TauEntryMosEnteredInteractionView class