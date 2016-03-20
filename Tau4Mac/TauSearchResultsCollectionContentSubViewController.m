//
//  TauSearchResultsCollectionContentSubViewController.m
//  Tau4Mac
//
//  Created by Tong G. on 3/20/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauSearchResultsCollectionContentSubViewController.h"
#import "TauToolbarItem.h"

// TauSearchResultsAccessoryBarViewController class
@interface TauSearchResultsAccessoryBarViewController : NSTitlebarAccessoryViewController
@end // TauSearchResultsAccessoryBarViewController class



// ------------------------------------------------------------------------------------------------------------ //



// Private
@interface TauSearchResultsCollectionContentSubViewController ()

@property ( strong, readonly ) TauYTDataServiceCredential* credential_;

// Model
@property ( strong, readwrite ) NSArray <GTLYouTubeSearchResult*>* searchResults;   // KVB-compliant

@property ( weak ) IBOutlet TauSearchResultsAccessoryBarViewController* accessoryBarViewController_;

@end // Private



// ------------------------------------------------------------------------------------------------------------ //



// TauSearchResultsCollectionContentSubViewController class
@implementation TauSearchResultsCollectionContentSubViewController
    {
    TauYTDataServiceCredential __strong* priCredential_;
    NSDictionary __strong* priOriginalOperationsCombination_;
    }

@synthesize searchContent = searchContent_;
- ( void ) setSearchContent: ( NSString* )_New
    {
    if ( searchContent_ != _New )
        {
        searchContent_ = _New;
        priOriginalOperationsCombination_ =
            @{ TauTDSOperationMaxResultsPerPage : @10, TauTDSOperationRequirements : @{ TauTDSOperationRequirementQ : searchContent_ }, TauTDSOperationPartFilter : @"snippet" };

        [ [ TauYTDataService sharedService ] executeConsumerOperations: priOriginalOperationsCombination_
                                                        withCredential: self.credential_
                                                               success:
        ^( NSString* _PrevPageToken, NSString* _NextPageToken )
            {
            DDLogInfo( @"%@ vs. %@", _PrevPageToken, _NextPageToken );
            DDLogInfo( @"%@", self.searchResults );
            } failure: ^( NSError* _Error )
                {
                DDLogFatal( @"%@", _Error );
                } ];
        }
    }

- ( NSString* ) searchContent
    {
    return searchContent_;
    }

@dynamic credential_;
- ( TauYTDataServiceCredential* ) credential_
    {
    if ( !priCredential_ )
        {
        priCredential_ =
            [ [ TauYTDataService sharedService ] registerConsumer: self
                                              withMethodSignature: [ self methodSignatureForSelector: _cmd ]
                                                  consumptionType: TauYTDataServiceConsumptionSearchResultsType ];
        }

    return priCredential_;
    }

#pragma mark - Overrides

- ( NSTitlebarAccessoryViewController* ) titlebarAccessoryViewControllerWhileActive
    {
    return self.accessoryBarViewController_;
    }

- ( IBAction ) cancelAction: ( id )_Sender
    {
    [ [ TauYTDataService sharedService ] unregisterConsumer: self withCredential: priCredential_ ];
    [ self popMe ];
    }

@end // TauSearchResultsCollectionContentSubViewController class



// ------------------------------------------------------------------------------------------------------------ //



// TauSearchResultsAccessoryBarViewController class
@implementation TauSearchResultsAccessoryBarViewController
@end // TauSearchResultsAccessoryBarViewController class