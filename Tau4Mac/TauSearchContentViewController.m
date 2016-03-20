//
//  TauSearchContentViewController.m
//  Tau4Mac
//
//  Created by Tong G. on 3/17/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauSearchContentViewController.h"
#import "TauViewsStack.h"
#import "TauToolbarController.h"
#import "TauAbstractContentSubViewController.h"
#import "AccessoryBarViewController.h"
#import "TauToolbarItem.h"

// TauSearchContentSubViewController class
@interface TauSearchContentSubViewController : TauAbstractContentSubViewController
@end // TauSearchContentSubViewController class



// ------------------------------------------------------------------------------------------------------------ //



// Private
@interface TauSearchContentViewController ()

@property ( weak ) IBOutlet TauSearchContentSubViewController* initialSearchContentSubViewController_;

@end // Private



// ------------------------------------------------------------------------------------------------------------ //



// TauSearchContentViewController class
@implementation TauSearchContentViewController

- ( void ) viewDidLoad
    {
    [ super viewDidLoad ];
    [ self.viewsStack setBackgroundViewController: self.initialSearchContentSubViewController_ ];

//    [ ( TauSearchContentSubViewController* )( self.activedSubViewController ) popMe ];
//
//    TauAbstractContentSubViewController* newViewCtrl = [ [ TauAbstractContentSubViewController alloc ] init ];
//    NSView* newView = [ [ NSView alloc ] initWithFrame: NSZeroRect ];
//    [ newView setWantsLayer: YES ];
//    [ newView.layer setBackgroundColor: [ NSColor orangeColor ].CGColor ];
//    [ newViewCtrl setView: newView ];
//    [ self pushContentSubView: newViewCtrl ];
//
//    NSButton* button = [ [ NSButton alloc ] initWithFrame: NSMakeRect( 50, 50, 60, 22 ) ];
//    button.target = self;
//    button.action = @selector( popMeAction: );
//
//    [ newView addSubview: button ];

//    [ newViewCtrl popMe ];
    }

//- ( void ) popMeAction: ( id )_Sender
//    {
//    [ self popContentSubView ];
//    }

@end // TauSearchContentViewController class



// ------------------------------------------------------------------------------------------------------------ //



// TauSearchContentSubViewController class
@implementation TauSearchContentSubViewController

- ( NSTitlebarAccessoryViewController* ) titlebarAccessoryViewControllerWhileActive
    {
    return [ [ AccessoryBarViewController alloc ] initWithNibName: nil bundle: nil ];
    }

- ( NSArray <TauToolbarItem*>* ) exposedToolbarItemsWhileActive
    {
    NSButton* button = [ [ NSButton alloc ] initWithFrame: NSMakeRect( 0, 0, 30, 22 ) ];
    [ button setBezelStyle: NSTexturedRoundedBezelStyle ];
    [ button setAction: @selector( testAction: ) ];
    [ button setTarget: self ];
    [ button setImage: [ NSImage imageNamed: @"NSGoLeftTemplate" ] ];
    [ button setToolTip: @"fuckingtest" ];

    TauToolbarItem* toolbarItem = [ [ TauToolbarItem alloc ] initWithIdentifier: nil label: nil view: button ];
//    NSInvocation* inv = [ NSInvocation invocationWithMethodSignature: [ self methodSignatureForSelector: @selector( testAction: ) ] ];
//    [ inv setTarget: self ];
//    [ inv setSelector: @selector( testAction: ) ];

//    TauToolbarItem* toolbarItem = [ [ TauToolbarItem alloc ] initWithIdentifier: nil label: nil image: nil toolTip: nil invocation: nil ];
    return @[ toolbarItem, [ TauToolbarItem switcherItem ] ];
    }

- ( void ) testAction: ( id )_Sender
    {
    NSLog( @"%@", _Sender );
    [ self popMe ];
    }

@end // TauSearchContentSubViewController class