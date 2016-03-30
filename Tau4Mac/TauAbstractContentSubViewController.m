//
//  TauAbstractContentSubViewController.m
//  Tau4Mac
//
//  Created by Tong G. on 3/19/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauAbstractContentSubViewController.h"
#import "TauToolbarController.h"
#import "TauToolbarItem.h"

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
    id candidate = self.parentViewController;

    if ( [ candidate isKindOfClass: [ TauAbstractContentViewController class ] ] )
        return ( TauAbstractContentViewController* )candidate;
    else if ( [ candidate isKindOfClass: [ TauAbstractContentSubViewController class ] ] )
        // Perform recursion
        return [ ( TauAbstractContentSubViewController* )candidate masterContentViewController ];

    return nil;
    }

@dynamic isBackground;
- ( BOOL ) isBackground
    {
    BOOL flag = ( self == self.masterContentViewController.backgroundViewController );
    return flag;
    }

#pragma mark - View Stack Operations

- ( void ) popMe
    {
    if ( !self.isBackground )
        {
        NSViewController <TauContentSubViewController>* actived = self.masterContentViewController.activedSubViewController;

        if ( actived == self )
            {
            [ self contentSubViewWillPop ];
            [ self.masterContentViewController popContentSubView ];
            [ self contentSubViewDidPop ];
            }
        else
            DDLogUnexpected( @"My master content view controller (%@)'s current actived subview controller should be me rather than this guy: {%@}"
                           , NSStringFromClass( [ TauAbstractContentViewController class ] )
                           , actived
                           );
        }
    else
        DDLogNotice( @"Attempting to pop the holly background view, you are not able to get rid of it." );
    }

#pragma mark - Expecting Overrides

- ( void ) contentSubViewWillPop
    {
    // Do nothing in implementation of superclass
    }

- ( void ) contentSubViewDidPop
    {
    // Do nothing in implementation of superclass
    }

#pragma mark - Actions

- ( IBAction ) dismissAction: ( id )_Sender
    {
    [ self popMe ];
    }

#pragma mark - Conforms to <TauContentSubViewController>

@dynamic windowAppearanceWhileActive;
// Subclasses override this method to provide Tau Toolbar Controller with custom appearance
- ( NSAppearance* ) windowAppearanceWhileActive
    {
    // Simply returns the appearance of the hosting window
    return self.view.window.appearance;
    }

@dynamic exposedToolbarItemsWhileActive;
// Subclasses override this method to provide Tau Toolbar Controller with toolbar item
- ( NSArray <TauToolbarItem*>* ) exposedToolbarItemsWhileActive
    {
    return @[ [ TauToolbarItem switcherItem ]
            , [ TauToolbarItem flexibleSpaceItem ]
            ];
    }

@dynamic titlebarAccessoryViewControllerWhileActive;
// Subclasses override this method to provide Tau Toolbar Controller with titlebar accessory view controller
- ( NSTitlebarAccessoryViewController* ) titlebarAccessoryViewControllerWhileActive
    {
    return nil;
    }

@end // TauAbstractContentSubViewController class