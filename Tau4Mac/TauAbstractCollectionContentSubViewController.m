//
//  TauAbstractCollectionContentSubViewController.m
//  Tau4Mac
//
//  Created by Tong G. on 3/25/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauAbstractCollectionContentSubViewController.h"
#import "TauToolbarItem.h"

#import "_PriTauAbstractCollectionContentSubViewController.h"

// TauSearchResultsAccessoryBarViewController class
@interface TauResultsAccessoryBarViewController : NSTitlebarAccessoryViewController
@end // TauSearchResultsAccessoryBarViewController class



// ------------------------------------------------------------------------------------------------------------ //



// Private
@interface TauAbstractCollectionContentSubViewController ()

@property ( strong, readwrite ) NSString* prevToken_;   // KVB-compliant
@property ( strong, readwrite ) NSString* nextToken_;   // KVB-compliant
@property ( assign, readwrite, setter = setPaging: ) BOOL isPaging;   // KVB compliant

// Internal
@property ( strong, readonly ) TauYTDataServiceCredential* credential_;

// Feeding TauToolbarController
@property ( weak ) IBOutlet TauResultsAccessoryBarViewController* accessoryBarViewController_;
@property ( weak ) IBOutlet NSTextField* appWideSummaryViewLabel_;

@end // Private

// TauAbstractCollectionContentSubViewController class
@implementation TauAbstractCollectionContentSubViewController

#pragma mark - Initializations

- ( void ) viewDidLoad
    {
    [ super viewDidLoad ];
    // Do view setup here.
    }

#pragma mark - Overrides

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

- ( NSArray <GTLObject*>* ) contentCollectionViewRequiredData: ( TauContentCollectionViewController* )_Controller
    {
    return self.results;
    }

#pragma mark - Actions

- ( IBAction ) loadPrevPageAction: ( id )_Sender
    {
    [ self executeSearchWithPageToken_: self.prevToken_ ];
    }

- ( IBAction ) loadNextPageAction: ( id )_Sender
    {
    [ self executeSearchWithPageToken_: self.nextToken_ ];
    }

- ( IBAction ) cancelAction: ( id )_Sender
    {
    id consumer = self;
    [ [ TauYTDataService sharedService ] unregisterConsumer: consumer withCredential: priCredential_ ];

    [ self popMe ];
    }

#pragma mark - External KVB Compliant

@dynamic hasPrev;
+ ( NSSet <NSString*>* ) keyPathsForValuesAffectingHasPrev
    {
    return [ NSSet setWithObjects: TAU_KEY_OF_SEL( @selector( prevToken_ ) ), nil ];
    }

- ( BOOL ) hasPrev
    {
    return ( self.prevToken_ != nil );
    }

@dynamic hasNext;
+ ( NSSet <NSString*>* ) keyPathsForValuesAffectingHasNext
    {
    return [ NSSet setWithObjects: TAU_KEY_OF_SEL( @selector( nextToken_ ) ), nil ];
    }

- ( BOOL ) hasNext
    {
    return ( self.nextToken_ != nil );
    }

+ ( NSSet <NSString*>* ) keyPathsForValuesAffectingResultsSummaryText
    {
    return [ NSSet setWithObjects: TAU_KEY_OF_SEL( @selector( results ) ), nil ];
    }

@synthesize results = results_;
- ( void ) setResults: ( NSArray <GTLObject*>* )_New
    {
    if ( results_ != _New )
        {
        TAU_CHANGE_VALUE_FOR_KEY_of_SEL( @selector( results ),
         ( ^{
            results_ = _New;
            [ self.contentCollectionViewController reloadData ];
            } ) );
        }
    }

- ( NSArray <GTLObject*>* ) results
    {
    return results_;
    }

@synthesize isPaging = isPaging_;
+ ( BOOL ) automaticallyNotifiesObserversOfIsPaging
    {
    return NO;
    }

- ( void ) setPaging: ( BOOL )_Flag
    {
    if ( isPaging_ != _Flag )
        TAU_CHANGE_VALUE_FOR_KEY_of_SEL( @selector( isPaging ), ^{ isPaging_ = _Flag; } );
    }

- ( BOOL ) isPaging
    {
    return isPaging_;
    }

@dynamic resultsSummaryText;

@synthesize prevToken_;
@synthesize nextToken_;

#pragma mark - Private

@synthesize accessoryBarViewController_;

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
        }

    return priContentCollectionViewController_;
    }

@synthesize credential_ = priCredential_;
- ( TauYTDataServiceCredential* ) credential_
    {
    if ( !priCredential_ )
        {
        id consumer = self;
        priCredential_ =
            [ [ TauYTDataService sharedService ] registerConsumer: consumer
                                              withMethodSignature: [ self methodSignatureForSelector: _cmd ]
                                                  consumptionType: TauYTDataServiceConsumptionSearchResultsType ];
        }

    return priCredential_;
    }

- ( void ) executeSearchWithPageToken_: ( NSString* )_PageToken
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
            DDLogRecoverable( @"Failed to execute the searching due to {%@}.", _Error );
            self.isPaging = NO;
            } ];
    }

@end // TauAbstractCollectionContentSubViewController class



// ------------------------------------------------------------------------------------------------------------ //



// TauSearchResultsAccessoryBarViewController class
@implementation TauResultsAccessoryBarViewController
@end // TauSearchResultsAccessoryBarViewController class