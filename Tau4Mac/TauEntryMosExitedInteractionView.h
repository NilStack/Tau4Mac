//
//  TauEntryMosExitedInteractionView.h
//  Tau4Mac
//
//  Created by Tong G. on 3/9/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauAbstractEntryMosInteractionView.h"

// TauEntryMosExitedInteractionView class
@interface TauEntryMosExitedInteractionView : TauAbstractEntryMosInteractionView

#pragma mark - Initializations

- ( instancetype ) initWithGTLObject: ( GTLObject* )_GTLObject host: ( TauYouTubeEntryView* )_EntryView thumbnail: ( NSImage* )_Thumbnail;

@end // TauEntryMosExitedInteractionView class