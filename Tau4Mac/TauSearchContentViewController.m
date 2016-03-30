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

// TauSearchContentSubViewController class
@interface TauSearchContentSubViewController : TauAbstractContentSubViewController
@end // TauSearchContentSubViewController class



// ------------------------------------------------------------------------------------------------------------ //



// Private
@interface TauSearchContentViewController ()

@property ( weak ) IBOutlet TauSearchContentSubViewController* initialSearchContentSubViewController_;
//@property ( strong, readwrite ) NSArray <GTLYouTubeSearchResult*>* searchResults;

@end // Private



// ------------------------------------------------------------------------------------------------------------ //



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



// TauSearchContentSubViewController class
@implementation TauSearchContentSubViewController

@end // TauSearchContentSubViewController class