//
//  TauContentPanelViewController.m
//  Tau4Mac
//
//  Created by Tong G. on 3/3/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauContentPanelViewController.h"

#import "TauCollectionObject.h"
#import "TauVideoView.h"

// Private Interfaces
@interface TauContentPanelViewController ()
@end // Private Interfaces

// TauContentPanelViewController class
@implementation TauContentPanelViewController
    {
@protected
    GTLCollectionObject __strong* repContents_;
    }

#pragma mark - Initializations

- ( void ) setRepresentedObject: ( GTLCollectionObject* )_RepresentedObject
    {
    [ super setRepresentedObject: _RepresentedObject ];

    TauVideoView* videoView = nil;
    for ( GTLYouTubeSearchResult* _SearchResult in _RepresentedObject )
        {
        DDLogDebug( @"%@", _SearchResult );

        if ( [ _SearchResult.identifier.kind isEqualToString: @"youtube#video" ] )
            {
            videoView = [ [ TauVideoView alloc ] initWithGTLObject: _SearchResult ];
            break;
            }
        }

    NSLog( @"%@", videoView );

//    DDLogDebug( @"Current Signed-In Username: %@", [ TauDataService sharedService ].signedInUsername );
    }

// #pragma mark - Private Interfaces

@end // TauContentPanelViewController class