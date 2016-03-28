//
//  TauMeTubeTabModel.m
//  Tau4Mac
//
//  Created by Tong G. on 3/28/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauMeTubeTabModel.h"

// TauMeTubeTabModel class
@implementation TauMeTubeTabModel

@synthesize tabTitle = tabTitle_;
@synthesize repPlaylistIdentifier = repPlaylistIdentifier_;
@synthesize viewController = viewController_;

#pragma mark - Initializations

- ( instancetype ) initWithTitle: ( NSString* )_Title playlistIdentifier: ( NSString* )_PlaylistId viewController: ( NSViewController* )_ViewController
    {
    if ( self = [ super init ] )
        {
        self.tabTitle = _Title;
        self.repPlaylistIdentifier = _PlaylistId;
        self.viewController = _ViewController;
        }

    return self;
    }

@end // TauMeTubeTabModel class