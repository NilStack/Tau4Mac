//
//  TauExploreContentViewController.m
//  Tau4Mac
//
//  Created by Tong G. on 3/17/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauExploreContentViewController.h"
#import "TauViewsStack.h"
#import "TauAbstractContentSubViewController.h"
#import "TauToolbarController.h"
#import "TauToolbarItem.h"

// TauExploreContentSubViewController class
@interface TauExploreContentSubViewController : TauAbstractContentSubViewController
@end // TauExploreContentSubViewController class


// ------------------------------------------------------------------------------------------------------------ //



// Private
@interface TauExploreContentViewController ()
@property ( weak ) IBOutlet TauExploreContentSubViewController* initialExploreContentSubViewController_;
@end // Private



// ------------------------------------------------------------------------------------------------------------ //



// TauExploreContentViewController class
@implementation TauExploreContentViewController

- ( void ) viewDidLoad
    {
    [ super viewDidLoad ];
    [ self.viewsStack setBackgroundViewController: self.initialExploreContentSubViewController_ ];
    }

@end // TauExploreContentViewController class



// ------------------------------------------------------------------------------------------------------------ //



// TauExploreContentSubViewController class
@implementation TauExploreContentSubViewController

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

@end // TauExploreContentSubViewController class