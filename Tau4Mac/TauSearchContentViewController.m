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
#import "TauSearchResultsCollectionContentSubViewController.h"
#import "TauSearchDashboardController.h"

// TauSearchContentSubViewController class
@interface TauSearchContentSubViewController : TauAbstractContentSubViewController

@property ( weak ) IBOutlet NSClipView* clipView;
@property ( weak ) IBOutlet TauSearchDashboardController* searchDashboardController;

@end // TauSearchContentSubViewController class



// ------------------------------------------------------------------------------------------------------------ //



// Private
@interface TauSearchContentViewController ()
@property ( weak ) IBOutlet TauSearchContentSubViewController* initialSearchContentSubViewController_;
@end // Private

// TauSearchContentViewController class
@implementation TauSearchContentViewController

- ( void ) viewDidLoad
    {
    [ super viewDidLoad ];
    [ self setBackgroundViewController: self.initialSearchContentSubViewController_ ];
    }

#pragma mark - Conforms to <NSTextFieldDelegate>

- ( void ) controlTextDidChange: ( NSNotification* )_Notif
    {
    NSText* fieldEditor = _Notif.userInfo[ @"NSFieldEditor" ];
    self.searchButton.enabled = ( fieldEditor.string.length > 0 );
    }

#pragma mark - Actions

- ( IBAction ) searchAction: ( id )_Sender
    {
    NSString* userInput = self.searchField.stringValue;

    TauSearchResultsCollectionContentSubViewController* searchResultsCollectionContentSubView = [ [ TauSearchResultsCollectionContentSubViewController alloc ] initWithNibName: nil bundle: nil ];
    [ self pushContentSubView: searchResultsCollectionContentSubView ];
    [ searchResultsCollectionContentSubView setSearchText: userInput ];
    }

@end // TauSearchContentViewController class



// ------------------------------------------------------------------------------------------------------------ //

// PriCenterClipView_ class
@interface PriCenterClipView_ : NSClipView
@end

@implementation PriCenterClipView_

#pragma mark - Overrides

- ( NSRect ) constrainBoundsRect: ( NSRect )_ProposedClipViewBoundsRect
    {
    NSRect proposedRect = [ super constrainBoundsRect: _ProposedClipViewBoundsRect ];
    NSView* docView = self.documentView;

    if ( docView )
        {
        if ( NSWidth( proposedRect ) > NSWidth( docView.frame ) )
            proposedRect.origin.x = ( NSWidth( docView.frame ) - NSWidth( proposedRect ) ) / 2.f;

//        if ( NSHeight( proposedRect ) > NSHeight( docView.frame ) )
//            proposedRect.origin.y = NSMinY( proposedRect );
        }

    return proposedRect;
    }

- ( BOOL ) isFlipped
    {
    return YES;
    }

@end // PriCenterClipView_ class

// TauSearchContentSubViewController class
@implementation TauSearchContentSubViewController

- ( void ) viewDidLoad
    {
    [ self.clipView setDocumentView: self.searchDashboardController.view ];
    }

@end // TauSearchContentSubViewController class