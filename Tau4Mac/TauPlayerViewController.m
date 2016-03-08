//
//  TauPlayerViewController.m
//  Tau4Mac
//
//  Created by Tong G. on 3/8/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauPlayerViewController.h"
#import "TauPlayerView.h"

// Private Interfaces
@interface TauPlayerViewController ()
@property ( strong, readonly ) TauPlayerView* playerView_;
@end // Private Interfaces

// TauPlayerViewController class
@implementation TauPlayerViewController

#pragma mark - Dynamic Properties

@dynamic ytContent;

- ( void ) setYtContent: ( GTLObject* )_New
    {
    self.playerView_.ytContent = _New;
    }

- ( GTLObject* ) ytContent
    {
    return self.playerView_.ytContent;
    }

#pragma mark - Private Interfaces

- ( TauPlayerView* ) playerView_
    {
    return ( TauPlayerView* )( self.view );
    }

@end // TauPlayerViewController class