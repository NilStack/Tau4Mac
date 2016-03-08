//
//  TauPlayerStackPanelBaseViewController.m
//  Tau4Mac
//
//  Created by Tong G. on 3/8/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauPlayerStackPanelBaseViewController.h"
#import "TauPlayerStackPanelBaseView.h"

// Private Interfaces
@interface TauPlayerStackPanelBaseViewController ()
@property ( strong, readonly ) TauPlayerStackPanelBaseView* playerView_;
@end // Private Interfaces

// TauPlayerStackPanelBaseViewController class
@implementation TauPlayerStackPanelBaseViewController

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

- ( TauPlayerStackPanelBaseView* ) playerView_
    {
    return ( TauPlayerStackPanelBaseView* )( self.view );
    }

@end // TauPlayerStackPanelBaseViewController class