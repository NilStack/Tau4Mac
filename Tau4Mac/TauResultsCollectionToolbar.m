//
//  TauResultsCollectionToolbar.m
//  Tau4Mac
//
//  Created by Tong G. on 3/5/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauResultsCollectionToolbar.h"
#import "TauResultsCollectionSummaryView.h"

// Private Interfaces
@interface TauResultsCollectionToolbar ()
@end // Private Interfaces

@implementation TauResultsCollectionToolbar
    {
    NSUInteger pageNumber_;
    GTLCollectionObject __strong* ytCollectionObject_;

    NSArray <NSLayoutConstraint*>* layoutConstraintsCache_;
    }

#pragma mark - Dynamic Properties

@dynamic ytCollectionObject;

- ( void ) setYtCollectionObject: ( GTLCollectionObject* )_NewCollectionObject
    {
    if ( ytCollectionObject_ != _NewCollectionObject )
        {
        ytCollectionObject_ = _NewCollectionObject;
        self.titleView.ytCollectionObject = ytCollectionObject_;

        [ self.segPager setHidden: !( ytCollectionObject_.items.count > 0 ) ];
        [ self.segPager setEnabled: ( [ ytCollectionObject_ performSelector: @selector( prevPageToken ) ] != nil ) forSegment: 0 ];
        [ self.segPager setEnabled: ( [ ytCollectionObject_ performSelector: @selector( nextPageToken ) ] != nil ) forSegment: 1 ];

        self.dismissButton.hidden = ![ ytCollectionObject_ isKindOfClass: [ GTLYouTubeSearchListResponse class ] ];
        }
    }

- ( GTLCollectionObject* ) ytCollectionObject
    {
    return ytCollectionObject_;
    }

@end
