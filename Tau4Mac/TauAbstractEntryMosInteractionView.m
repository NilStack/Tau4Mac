//
//  TauAbstractEntryMosInteractionView.m
//  Tau4Mac
//
//  Created by Tong G. on 3/9/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauAbstractEntryMosInteractionView.h"
#import "TauYouTubeEntryView.h"

// TauAbstractEntryMosInteractionView class
@implementation TauAbstractEntryMosInteractionView
    {
    GTLObject __strong* ytContent_;
    TauYouTubeEntryView __weak* host_;
    }

#pragma mark - Initializations

- ( instancetype ) initWithGTLObject: ( GTLObject* )_GTLObject
                                host: ( TauYouTubeEntryView* )_EntryView
    {
    if ( self = [ super initWithFrame: NSZeroRect ] )
        {
        ytContent_ = _GTLObject;
        host_ = _EntryView;

        [ self setWantsLayer: YES ];
        }

    return self;
    }

#pragma mark - Dynamic Properties

@dynamic ytContent;
@dynamic type;

- ( GTLObject* ) ytContent
    {
    return ytContent_;
    }

- ( void ) setYtContent: ( GTLObject* )_New
    {
    if ( ytContent_ != _New )
        ytContent_ = _New;
    }

- ( TauYouTubeContentViewType ) type
    {
    return host_.type;
    }

@end // TauAbstractEntryMosInteractionView class