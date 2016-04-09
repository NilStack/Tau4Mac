//
//  TauAbstractCollectionContentSubViewController.m
//  Tau4Mac
//
//  Created by Tong G. on 3/25/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauAbstractCollectionContentSubViewController.h"
#import "TauToolbarItem.h"
#import "TauAbstractContentViewController.h"

// Concret sub-classes
#import "TauSearchResultsCollectionContentSubViewController.h"
#import "TauPlaylistResultsCollectionContentSubViewController.h"
#import "TauChannelResultsCollectionContentSubViewController.h"
#import "TauSubscriptionsCollectionContentSubViewController.h"

// TauSearchResultsAccessoryBarViewController class
@interface TauResultsAccessoryBarViewController : NSTitlebarAccessoryViewController
@end // TauSearchResultsAccessoryBarViewController class



// ------------------------------------------------------------------------------------------------------------ //



// Private
@interface TauAbstractCollectionContentSubViewController ()

// Writability Swizzling
@property ( assign, readwrite, setter = setPaging: ) BOOL isPaging;   // KVB compliant
//@property ( weak, readwrite ) NSArray <GTLObject*>* results;    // KVB compliant
@property ( weak, readwrite ) TauAbstractResultCollection* results;    // KVB compliant

// Internal
@property ( strong, readwrite ) NSString* prevToken_;   // KVB-compliant
@property ( strong, readwrite ) NSString* nextToken_;   // KVB-compliant

@property ( strong, readonly ) TauAPIServiceCredential* credential_;

// Feeding TauToolbarController
@property ( weak ) IBOutlet TauResultsAccessoryBarViewController* accessoryBarViewController_;
@property ( weak ) IBOutlet NSTextField* appWideSummaryViewLabel_;

// UI Elements
@property ( weak ) IBOutlet NSButton* dismissButton_;


// Notification Selector
- ( void ) shouldExposeContentCollectionItem_: ( NSNotification* )_Notif;

@end // Private



// ------------------------------------------------------------------------------------------------------------ //



// Notification Names
NSString* const TauShouldExposeContentCollectionItemNotif = @"Should.ExposeContentCollectionItem.Notif";;

// TauAbstractCollectionContentSubViewController class
@implementation TauAbstractCollectionContentSubViewController
    {
    LRNotificationObserver __strong* shouldExposeContentItemObserv_;
    }

#pragma mark - Initializations

- ( void ) viewDidLoad
    {
    [ super viewDidLoad ];
    // Do view setup here.
    }

TauDeallocBegin
TauDeallocEnd

#pragma mark - Overrides <TauContentSubViewController>

- ( NSTitlebarAccessoryViewController* ) titlebarAccessoryViewControllerWhileActive
    {
    return self.accessoryBarViewController_;
    }

- ( NSArray <TauToolbarItem*>* ) exposedToolbarItemsWhileActive
    {
    NSArray <TauToolbarItem*>* intrinsicItems =
        @[ [ TauToolbarItem switcherItem ]
         , [ TauToolbarItem adaptiveSpaceItem ]
         , [ [ TauToolbarItem alloc ] initWithIdentifier: nil label: nil view: self.appWideSummaryViewLabel_ ]
         , [ TauToolbarItem flexibleSpaceItem ]
         ];

    // Inherited items from content collection view controller.
    // We put all of them next to the intrinsicItems.
    NSArray <TauToolbarItem*>* inheritedItems = self.contentCollectionViewController.exposedToolbarItems;
    if ( inheritedItems.count > 0 )
        intrinsicItems = [ intrinsicItems arrayByAddingObjectsFromArray: inheritedItems ];

    return intrinsicItems;
    }

#pragma mark - Conforms to <TauContentCollectionViewRelayDataSource>

- ( TauAbstractResultCollection* ) contentCollectionViewRequiredData: ( TauContentCollectionViewController* )_Controller
    {
    return self.results;
    }

#pragma mark - Actions

- ( IBAction ) loadPrevPageAction: ( id )_Sender
    {
    [ self executePagingOperationWithPageToken_: self.prevToken_ ];
    }

- ( IBAction ) loadNextPageAction: ( id )_Sender
    {
    [ self executePagingOperationWithPageToken_: self.nextToken_ ];
    }

#pragma mark - Overrides

- ( void ) contentSubViewWillPop
    {
    id consumer = self;
    [ [ TauAPIService sharedService ] unregisterConsumer: consumer withCredential: priCredential_ ];

    [ self unbind: TauKVOStrictKey( results ) ];

    [ super contentSubViewWillPop ];
    }

- ( void ) viewWillAppear
    {
    shouldExposeContentItemObserv_ = [ LRNotificationObserver
        observerForName: TauShouldExposeContentCollectionItemNotif operationQueue: [ NSOperationQueue mainQueue ] target: self action: @selector( shouldExposeContentCollectionItem_: ) ];
    DDLogExpecting( @"Begin observing the {%@} notification in %@ (hold by %@).", TauShouldExposeContentCollectionItemNotif, self, shouldExposeContentItemObserv_ );
    }

- ( void ) viewWillDisappear
    {
    shouldExposeContentItemObserv_ = nil;
    DDLogExpecting( @"Stop observing the {%@} notification in %@.", TauShouldExposeContentCollectionItemNotif, self );
    }

#pragma mark - UI

@synthesize contentCollectionViewController = priContentCollectionViewController_;
- ( TauContentCollectionViewController* ) contentCollectionViewController
    {
    if ( !priContentCollectionViewController_ )
        {
        priContentCollectionViewController_ = [ [ TauContentCollectionViewController alloc ] initWithNibName: nil bundle: nil ];

        // self provides the required collection model data by conforming the <TauContentCollectionViewRelayDataSource> protocol
        // and then the priContentCollectionViewController_ relays them to its internal collection view
        [ priContentCollectionViewController_ setRelayDataSource: self ];

        [ self addChildViewController: priContentCollectionViewController_ ];
        [ self.view addSubview: priContentCollectionViewController_.view ];
        [ priContentCollectionViewController_.view autoPinEdgesToSuperviewEdges ];
        }

    return priContentCollectionViewController_;
    }

#pragma mark - External KVB Compliant Properties

@dynamic hasPrev;
+ ( NSSet <NSString*>* ) keyPathsForValuesAffectingHasPrev
    {
    return [ NSSet setWithObjects: TauKVOStrictKey( prevToken_ ), nil ];
    }

- ( BOOL ) hasPrev
    {
    return ( self.prevToken_ != nil );
    }

@dynamic hasNext;
+ ( NSSet <NSString*>* ) keyPathsForValuesAffectingHasNext
    {
    return [ NSSet setWithObjects: TauKVOStrictKey( nextToken_ ), nil ];
    }

- ( BOOL ) hasNext
    {
    return ( self.nextToken_ != nil );
    }

@synthesize isPaging = isPaging_;
+ ( BOOL ) automaticallyNotifiesObserversOfIsPaging
    {
    return NO;
    }

- ( void ) setPaging: ( BOOL )_Flag
    {
    if ( isPaging_ != _Flag )
        TauChangeValueForKVOStrictKey( isPaging, ^{ isPaging_ = _Flag; } );
    }

- ( BOOL ) isPaging
    {
    return isPaging_;
    }

#pragma mark - Prefer to be Overrided by Concrete Classes

@dynamic resultsSummaryText;
+ ( NSSet <NSString*>* ) keyPathsForValuesAffectingResultsSummaryText
    {
    return [ NSSet setWithObjects: TauKVOStrictKey( results ), nil ];
    }

- ( NSString* ) resultsSummaryText
    {
    NSUInteger resultsCount = results_.count;
    return [ NSString stringWithFormat: NSLocalizedString( @"%lu Result%@", nil ), resultsCount, ( resultsCount > 1 ) ? @"s" : @"" ];
    }

@dynamic appWideSummaryText;
- ( NSString* ) appWideSummaryText
    {
    return NSLocalizedString( @"Results Collection", @"Default value of appWideSummaryText property" );
    }

#pragma mark - TDS Related

@synthesize results = results_;
+ ( BOOL ) automaticallyNotifiesObserversOfResults
    {
    return NO;
    }

- ( void ) setResults: ( TauAbstractResultCollection* )_New
    {
    if ( results_ != _New )
        {
        TauChangeValueForKVOStrictKey( results,
         ( ^{
            results_ = _New;
            [ self.contentCollectionViewController reloadData ];
            } ) );
        }
    }

- ( TauAbstractResultCollection* ) results
    {
    return results_;
    }

- ( NSUInteger ) countOfResults
    {
    return results_.count;
    }

@synthesize originalOperationsCombination = originalOperationsCombination_;
- ( void ) setOriginalOperationsCombination: ( id )_New
    {
    if ( originalOperationsCombination_ != _New )
        {
        originalOperationsCombination_ = _New;

        NSString* pageToken = nil;
        if ( [ originalOperationsCombination_ isKindOfClass: [ NSDictionary class ] ] )
            pageToken = [ ( NSDictionary* )originalOperationsCombination_ objectForKey: TauTDSOperationPageToken ];
        else if ( [ originalOperationsCombination_ isKindOfClass: [ GTLQueryYouTube class ] ] )
            pageToken = [ ( GTLQueryYouTube* )originalOperationsCombination_ pageToken ];

        [ self executePagingOperationWithPageToken_: pageToken ];
        }
    }

- ( NSDictionary* ) originalOperationsCombination
    {
    return originalOperationsCombination_;
    }

#pragma mark - Private

// Internal

@synthesize prevToken_;
@synthesize nextToken_;

@synthesize credential_ = priCredential_;

// Self-generating the required credential
- ( TauAPIServiceCredential* ) credential_
    {
    if ( [ self class ] == [ TauAbstractCollectionContentSubViewController class ] )
        {
        @try {
        [ self doesNotRecognizeSelector: _cmd ];
        } @catch ( NSException* _Ex )
            {
            DDLogFatal( @"Invoking `%@` from the abstract superclass: {%@}.", THIS_METHOD, _Ex );
            }

        return nil;
        }

    if ( !priCredential_ )
        {
        id consumer = self;

        TauAPIServiceConsumptionType consumptionType = TauAPIServiceConsumptionUnknownType;

        /*************** Get the correct consumption type ***************/

        if ( [ self isKindOfClass: [ TauSearchResultsCollectionContentSubViewController class ] ] )
            consumptionType = TauAPIServiceConsumptionSearchResultsType;

        else if ( [ self isKindOfClass: [ TauPlaylistResultsCollectionContentSubViewController class ] ] )
            consumptionType = TauAPIServiceConsumptionPlaylistItemsType;

        else if ( [ self isKindOfClass: [ TauSubscriptionsCollectionContentSubViewController class ] ] )
            consumptionType = TauAPIServiceConsumptionSubscriptionsType; // TODO: Expecting other consumption types

        /*************** Get the correct consumption type ***************/

        if ( consumptionType == TauAPIServiceConsumptionUnknownType )
            DDLogUnexpected( @"TDS consumption is unkown." );
        else
            priCredential_ = [ [ TauAPIService sharedService ]
                registerConsumer: consumer withMethodSignature: [ self methodSignatureForSelector: _cmd ] consumptionType: consumptionType ];
        }

    return priCredential_;
    }

// Feeding TauToolbarController

@synthesize accessoryBarViewController_;

// Paging Operation

- ( void ) executePagingOperationWithPageToken_: ( NSString* )_PageToken
    {
    id query = nil;
    if ( _PageToken && ( _PageToken.length > 0 ) )
        {
        if ( [ originalOperationsCombination_ isKindOfClass: [ NSDictionary class ] ] )
            {
            NSMutableDictionary* modified = [ NSMutableDictionary dictionaryWithDictionary: originalOperationsCombination_ ];
            [ modified setObject: _PageToken forKey: TauTDSOperationPageToken ];
            query = modified;
            }
        else if ( [ originalOperationsCombination_ isKindOfClass: [ GTLQueryYouTube class ] ] )
            {
            GTLQueryYouTube* copy = [ originalOperationsCombination_ copy ];
            [ copy setPageToken: _PageToken ];
            }
        }
    else
        query = originalOperationsCombination_;

    self.isPaging = ( _PageToken != nil );
    [ [ TauAPIService sharedService ] executeConsumerOperations: query
                                                 withCredential: self.credential_
                                                        success:
    ^( NSString* _PrevPageToken, NSString* _NextPageToken )
        {
        DDLogDebug( @"%@", self.results );

        self.prevToken_ = _PrevPageToken;
        self.nextToken_ = _NextPageToken;
        self.isPaging = NO;

        } failure: ^( NSError* _Error )
            {
            DDLogRecoverable( @"Failed to execute the consumer operation with error: {%@}.", _Error );
            self.isPaging = NO;
            } ];
    }

// Notification Selector

- ( void ) shouldExposeContentCollectionItem_: ( NSNotification* )_Notif
    {
    TauAbstractCollectionContentSubViewController* c = nil;

    switch ( _Notif.contentType )
        {
        case TauYouTubeVideo:
            {
            NSString* videoIdentifier = _Notif.videoIdentifier;
            [ [ TauPlayerController defaultPlayerController ] playYouTubeVideoWithVideoIdentifier: videoIdentifier switchToPlayer: YES ];
            } break;

        case TauYouTubePlayList:
            {
            c = [ [ TauPlaylistResultsCollectionContentSubViewController alloc ] initWithNibName: nil bundle: nil ];
            [ c setValue: _Notif.playlistIdentifier forKey: TauKVOStrictKey( playlistIdentifier ) ];
            [ c setValue: _Notif.playlistName forKey: TauKVOStrictKey( playlistName ) ];
            } break;

        case TauYouTubeChannel:
            {
            c = [ [ TauChannelResultsCollectionContentSubViewController alloc ] initWithNibName: nil bundle: nil ];
            [ c setValue: _Notif.channelIdentifier forKey: TauKVOStrictKey( channelIdentifier ) ];
            [ c setValue: _Notif.channelName forKey: TauKVOStrictKey( channelName ) ];
            } break;

        case TauYouTubeUnknownContent:
            {
            DDLogUnexpected( @"Content type is unknown." );
            } break;
        }

    if ( c )
        [ self.masterContentViewController pushContentSubView: c ];
    }

@end // TauAbstractCollectionContentSubViewController class



// ------------------------------------------------------------------------------------------------------------ //



// TauSearchResultsAccessoryBarViewController class
@implementation TauResultsAccessoryBarViewController
@end // TauSearchResultsAccessoryBarViewController class