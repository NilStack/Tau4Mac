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

@property ( strong, readonly ) TauYTDataServiceCredential* credential_;

// Feeding TauToolbarController
@property ( weak ) IBOutlet TauResultsAccessoryBarViewController* accessoryBarViewController_;
@property ( weak ) IBOutlet NSTextField* appWideSummaryViewLabel_;

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

#pragma mark - Overrides <TauContentSubViewController>

- ( NSTitlebarAccessoryViewController* ) titlebarAccessoryViewControllerWhileActive
    {
    return self.accessoryBarViewController_;
    }

- ( NSArray <TauToolbarItem*>* ) exposedToolbarItemsWhileActive
    {
    return @[ [ TauToolbarItem switcherItem ]
            , [ TauToolbarItem adaptiveSpaceItem ]
            , [ [ TauToolbarItem alloc ] initWithIdentifier: nil label: nil view: self.appWideSummaryViewLabel_ ]
            , [ TauToolbarItem flexibleSpaceItem ]
            ];
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

- ( IBAction ) cancelAction: ( id )_Sender
    {
    shouldExposeContentItemObserv_ = nil;

    id consumer = self;
    [ [ TauYTDataService sharedService ] unregisterConsumer: consumer withCredential: priCredential_ ];

    [ self popMe ];
    }

#pragma mark - UI

@synthesize contentCollectionViewController = priContentCollectionViewController_;
- ( TauContentCollectionViewController* ) contentCollectionViewController
    {
    if ( !priContentCollectionViewController_ )
        {
        priContentCollectionViewController_ = [ [ TauContentCollectionViewController alloc ] initWithNibName: nil bundle: nil ];
        [ priContentCollectionViewController_ setRelayDataSource: self ];
        [ self addChildViewController: priContentCollectionViewController_ ];
        [ self.view addSubview: priContentCollectionViewController_.view ];
        [ priContentCollectionViewController_.view autoPinEdgesToSuperviewEdges ];

        shouldExposeContentItemObserv_ =
TAU_SUPPRESS_UNDECLARED_SELECTOR_WARNING_BEGIN
        [ LRNotificationObserver observerForName: TauShouldExposeContentCollectionItemNotif
                                          object: [ priContentCollectionViewController_ valueForKey: TauKeyOfSel( @selector( contentCollectionView_ ) ) ]
                                           block:
TAU_SUPPRESS_UNDECLARED_SELECTOR_WARNING_COMMIT
        ^( NSNotification /* TauShouldExposeCollectionItemNotif*/ * _Notif )
            {
            TauAbstractCollectionContentSubViewController* c = nil;

            switch ( _Notif.contentType )
                {
                case TauYouTubeVideo:
                    {
                    NSLog( @"%@", _Notif );
                    } break;

                case TauYouTubePlayList:
                    {
                    c = [ [ TauPlaylistResultsCollectionContentSubViewController alloc ] initWithNibName: nil bundle: nil ];
                    [ c setValue: _Notif.playlistIdentifier forKey: TauKeyOfSel( @selector( playlistIdentifier ) ) ];
                    [ c setValue: _Notif.playlistName forKey: TauKeyOfSel( @selector( playlistName ) ) ];
                    } break;

                case TauYouTubeChannel:
                    {
                    c = [ [ TauChannelResultsCollectionContentSubViewController alloc ] initWithNibName: nil bundle: nil ];
                    [ c setValue: _Notif.channelIdentifier forKey: TauKeyOfSel( @selector( channelIdentifier ) ) ];
                    [ c setValue: _Notif.channelName forKey: TauKeyOfSel( @selector( channelName ) ) ];
                    } break;

                case TauYouTubeUnknownContent:
                    {
                    DDLogUnexpected( @"Content type is unknown." );
                    } break;
                }

            if ( c )
                [ self.masterContentViewController pushContentSubView: c ];
            } ];
        }

    return priContentCollectionViewController_;
    }

#pragma mark - External KVB Compliant Properties

@dynamic hasPrev;
+ ( NSSet <NSString*>* ) keyPathsForValuesAffectingHasPrev
    {
    return [ NSSet setWithObjects: TauKeyOfSel( @selector( prevToken_ ) ), nil ];
    }

- ( BOOL ) hasPrev
    {
    return ( self.prevToken_ != nil );
    }

@dynamic hasNext;
+ ( NSSet <NSString*>* ) keyPathsForValuesAffectingHasNext
    {
    return [ NSSet setWithObjects: TauKeyOfSel( @selector( nextToken_ ) ), nil ];
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
        TAU_CHANGE_VALUE_FOR_KEY( isPaging, ^{ isPaging_ = _Flag; } );
    }

- ( BOOL ) isPaging
    {
    return isPaging_;
    }

#pragma mark - Prefer to be Overrided by Concrete Classes

@dynamic resultsSummaryText;
+ ( NSSet <NSString*>* ) keyPathsForValuesAffectingResultsSummaryText
    {
    return [ NSSet setWithObjects: TauKeyOfSel( @selector( results ) ), nil ];
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
        TAU_CHANGE_VALUE_FOR_KEY( results,
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
- ( void ) setOriginalOperationsCombination: ( NSDictionary* )_New
    {
    if ( originalOperationsCombination_ != _New )
        {
        originalOperationsCombination_ = _New;
        [ self executePagingOperationWithPageToken_: originalOperationsCombination_[ TauTDSOperationPageToken ] ];
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
- ( TauYTDataServiceCredential* ) credential_
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

        TauYTDataServiceConsumptionType consumptionType = TauYTDataServiceConsumptionUnknownType;

        /*************** Get the correct consumption type ***************/

        if ( [ self isKindOfClass: [ TauSearchResultsCollectionContentSubViewController class ] ] )
            consumptionType = TauYTDataServiceConsumptionSearchResultsType;

        else if ( [ self isKindOfClass: [ TauPlaylistResultsCollectionContentSubViewController class ] ] )
            consumptionType = TauYTDataServiceConsumptionPlaylistItemsType;

        else if ( [ self isKindOfClass: [ TauSubscriptionsCollectionContentSubViewController class ] ] )
            consumptionType = TauYTDataServiceConsumptionSubscriptionsType; // TODO: Expecting other consumption types

        /*************** Get the correct consumption type ***************/

        if ( consumptionType == TauYTDataServiceConsumptionUnknownType )
            DDLogUnexpected( @"TDS consumption is unkown." );
        else
            priCredential_ = [ [ TauYTDataService sharedService ]
                registerConsumer: consumer withMethodSignature: [ self methodSignatureForSelector: _cmd ] consumptionType: consumptionType ];
        }

    return priCredential_;
    }

// Feeding TauToolbarController

@synthesize accessoryBarViewController_;

// Paging Operation

- ( void ) executePagingOperationWithPageToken_: ( NSString* )_PageToken
    {
    NSDictionary* operationsCombination = nil;
    if ( _PageToken && ( _PageToken.length > 0 ) )
        {
        NSMutableDictionary* modified = [ NSMutableDictionary dictionaryWithDictionary: originalOperationsCombination_ ];
        [ modified setObject: _PageToken forKey: TauTDSOperationPageToken ];
        operationsCombination = modified;
        }
    else
        operationsCombination = originalOperationsCombination_;

    self.isPaging = ( _PageToken != nil );
    [ [ TauYTDataService sharedService ] executeConsumerOperations: operationsCombination
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
            DDLogRecoverable( @"Failed to execute the consumer operation due to {%@}.", _Error );
            self.isPaging = NO;
            } ];
    }

@end // TauAbstractCollectionContentSubViewController class



// ------------------------------------------------------------------------------------------------------------ //



// TauSearchResultsAccessoryBarViewController class
@implementation TauResultsAccessoryBarViewController
@end // TauSearchResultsAccessoryBarViewController class