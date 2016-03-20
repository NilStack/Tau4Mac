//
//  TauSearchResultsCollectionContentSubViewController.m
//  Tau4Mac
//
//  Created by Tong G. on 3/20/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauSearchResultsCollectionContentSubViewController.h"
#import "TauToolbarItem.h"

// Private
@interface TauSearchResultsCollectionContentSubViewController ()
@property ( strong, readwrite ) NSArray <GTLYouTubeSearchResult*>* searchResults;   // KVB-compliant
@end // Private

// TauSearchResultsCollectionContentSubViewController class
@implementation TauSearchResultsCollectionContentSubViewController

- ( void ) viewDidLoad
    {
    [ super viewDidLoad ];
    // Do view setup here.
    }

@synthesize searchResults;
@synthesize originalOperationsCombination = originalOperationsCombination_;
@synthesize credential = credential_;

- ( void ) setCredential: ( TauYTDataServiceCredential* )_New
    {
    if ( credential_ != _New )
        {
        credential_ = _New;

        [ [ TauYTDataService sharedService ] executeConsumerOperations: originalOperationsCombination_
                                                        withCredential: credential_
                                                               success:
        ^( NSString* _PrevPageToken, NSString* _NextPageToken )
            {
            DDLogInfo( @"%@ vs. %@", _PrevPageToken, _NextPageToken );
            } failure: ^( NSError* _Error )
                {
                DDLogFatal( @"%@", _Error );
                } ];
        }
    }

- ( TauYTDataServiceCredential* ) credential
    {
    return credential_;
    }

#pragma mark - Overrides

- ( NSArray <TauToolbarItem*>* ) exposedToolbarItemsWhileActive
    {
    NSButton* button = [ [ NSButton alloc ] initWithFrame: NSMakeRect( 0, 0, 30, 22 ) ];
    [ button setBezelStyle: NSTexturedRoundedBezelStyle ];
    [ button setAction: @selector( goBackAction: ) ];
    [ button setTarget: self ];
    [ button setImage: [ NSImage imageNamed: @"NSGoLeftTemplate" ] ];
    [ button setToolTip: @"fuckingtest" ];

    TauToolbarItem* goBackToolbarItem = [ [ TauToolbarItem alloc ] initWithIdentifier: nil label: nil view: button ];
    return @[ goBackToolbarItem, [ TauToolbarItem switcherItem ] ];
    }

- ( void ) goBackAction: ( id )_Sender
    {
    [ [ TauYTDataService sharedService ] unregisterConsumer: self withCredential: credential_ ];
    [ self popMe ];
    }

@end // TauSearchResultsCollectionContentSubViewController class