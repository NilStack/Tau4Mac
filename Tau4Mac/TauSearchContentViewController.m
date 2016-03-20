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
    {
//    TauYTDataServiceCredential __strong* credential_;
    }

- ( void ) viewDidLoad
    {
    [ super viewDidLoad ];
    [ self.viewsStack setBackgroundViewController: self.initialSearchContentSubViewController_ ];
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
    NSDictionary* originalOperationCombinations =
        @{ TauTDSOperationMaxResultsPerPage : @10, TauTDSOperationRequirements : @{ TauTDSOperationRequirementQ : userInput }, TauTDSOperationPartFilter : @"snippet" };

    TauSearchResultsCollectionContentSubViewController* searchResultsCollectionContentSubView = [ [ TauSearchResultsCollectionContentSubViewController alloc ] initWithNibName: nil bundle: nil ];

    TauYTDataServiceCredential* credential = [ [ TauYTDataService sharedService ] registerConsumer: searchResultsCollectionContentSubView withMethodSignature: [ self methodSignatureForSelector: _cmd ] consumptionType: TauYTDataServiceConsumptionSearchResultsType ];
    [ searchResultsCollectionContentSubView setOriginalOperationsCombination: originalOperationCombinations ];
    [ searchResultsCollectionContentSubView setCredential: credential ];

    [ self pushContentSubView: searchResultsCollectionContentSubView ];
    }

@end // TauSearchContentViewController class



// ------------------------------------------------------------------------------------------------------------ //



// TauSearchContentSubViewController class
@implementation TauSearchContentSubViewController

@end // TauSearchContentSubViewController class