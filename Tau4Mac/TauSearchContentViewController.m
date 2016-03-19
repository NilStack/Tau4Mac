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

    TauAbstractContentSubViewController* newViewCtrl = [ [ TauAbstractContentSubViewController alloc ] init ];
    NSView* newView = [ [ NSView alloc ] initWithFrame: NSZeroRect ];
    [ newView setWantsLayer: YES ];
    [ newView.layer setBackgroundColor: [ NSColor orangeColor ].CGColor ];
    [ newViewCtrl setView: newView ];
    [ self pushContentSubView: newViewCtrl ];

    NSButton* button = [ [ NSButton alloc ] initWithFrame: NSMakeRect( 50, 50, 60, 22 ) ];
    button.target = self;
    button.action = @selector( popMeAction: );

    [ newView addSubview: button ];

    [ newViewCtrl popMe ];
    }

//- ( void ) popMeAction: ( id )_Sender
//    {
//
//    }

@end // TauSearchContentViewController class



// ------------------------------------------------------------------------------------------------------------ //



// TauSearchContentSubViewController class
@implementation TauSearchContentSubViewController
@end // TauSearchContentSubViewController class