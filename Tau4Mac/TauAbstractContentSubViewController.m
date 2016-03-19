//
//  TauAbstractContentSubViewController.m
//  Tau4Mac
//
//  Created by Tong G. on 3/19/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauAbstractContentSubViewController.h"

// Private
@interface TauAbstractContentSubViewController ()

@end // Private

// TauAbstractContentSubViewController class
@implementation TauAbstractContentSubViewController

- ( void ) viewDidLoad
    {
    [ super viewDidLoad ];
    // Do view setup here.
    }

@dynamic masterContentViewController;

- ( TauAbstractContentViewController* ) masterContentViewController
    {
    return ( TauAbstractContentViewController* )( self.parentViewController );
    }

#pragma mark - View Stack Operations

- ( void ) popMe
    {
    NSViewController <TauContentSubViewController>* actived = self.masterContentViewController.activedSubViewController;

    if ( actived == self )
        {
        if ( self != self.masterContentViewController.backgroundViewController )
            [ self.masterContentViewController popContentSubView ];
        else
            DDLogNotice( @"Attempting to pop the holly background view, you are not able to get rid of it." );
        }
    else
        DDLogUnexpected( @"My master content view controller (%@)'s current actived subview controller should be me rather than this guy: {%@}"
                       , NSStringFromClass( [ TauAbstractContentViewController class ] )
                       , actived
                       );
    }

@end // TauAbstractContentSubViewController class