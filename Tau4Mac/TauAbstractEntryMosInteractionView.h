//
//  TauAbstractEntryMosInteractionView.h
//  Tau4Mac
//
//  Created by Tong G. on 3/9/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

@class TauYouTubeEntryView;

// TauAbstractEntryMosInteractionView class
@interface TauAbstractEntryMosInteractionView : NSView

#pragma mark - Initializations

- ( instancetype ) initWithGTLObject: ( GTLObject* )_GTLObject host: ( TauYouTubeEntryView* )_EntryView;

#pragma mark - Properties

@property ( strong, readwrite ) GTLObject* ytContent;
@property ( assign, readonly ) TauYouTubeContentViewType type;

@end // TauAbstractEntryMosInteractionView class