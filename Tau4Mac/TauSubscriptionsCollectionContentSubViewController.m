//
//  TauSubscriptionsCollectionContentSubViewController.m
//  Tau4Mac
//
//  Created by Tong G. on 3/29/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauSubscriptionsCollectionContentSubViewController.h"

// Private
@interface TauSubscriptionsCollectionContentSubViewController ()

// Model: Feed me, if you dare.
@property ( weak, readwrite ) TauYouTubeSubscriptionsCollection* subscriptions;   // KVB-compliant

@end // Private

// TauSubscriptionsCollectionContentSubViewController class
@implementation TauSubscriptionsCollectionContentSubViewController

#pragma mark - Initializations

- ( instancetype ) initWithNibName: ( NSString* )_NibNameOrNil bundle: ( NSBundle* )_NibBundleOrNil
    {
    Class superClass = [ TauAbstractCollectionContentSubViewController class ];
    if ( self = [ super initWithNibName: NSStringFromClass( superClass ) bundle: [ NSBundle bundleForClass: superClass ] ] )
        {
        // Dangerous self-binding.
        // Unbinding in overrides of cancelAction:
        [ self bind: TauKVOKey( results ) toObject: self withKeyPath: TauKVOKey( subscriptions ) options: nil ];
        }

    return self;
    }

TauDeallocBegin
TauDeallocEnd

#pragma mark - External KVB Compliant

@synthesize isMine = isMine_;
+ ( BOOL ) automaticallyNotifiesObserversOfSearchText
    {
    return NO;
    }

- ( void ) setMine: ( BOOL )_Flag
    {
    if ( isMine_ != _Flag )
        {
        TAU_CHANGE_VALUE_FOR_KEY( isMine,
         ( ^{
            isMine_ = _Flag;

            self.originalOperationsCombination =
               @{ TauTDSOperationMaxResultsPerPage : @50
                , TauTDSOperationRequirements : @{ TauTDSOperationRequirementMine : _Flag ? @"true" : @"" }
                , TauTDSOperationPartFilter : @"snippet,contentDetails"
                };
            } ) );
        }
    }

- ( BOOL ) isMine
    {
    return isMine_;
    }

#pragma mark - Overrides

- ( IBAction ) cancelAction: ( id )_Sender
    {
    // Get rid of self-binding
    [ self unbind: TauKeyOfSel( @selector( results ) ) ];
    [ super cancelAction: _Sender ];
    }

- ( NSString* ) resultsSummaryText
    {
    return NSLocalizedString( @"No Results Yet", nil );
    }

- ( NSString* ) appWideSummaryText
    {
    return NSLocalizedString( @"Subscriptions", @"App wide summary text of subscriptions collection" );
    }

#pragma mark - Internal KVB Compliant

@synthesize subscriptions = subscriptions_;
+ ( BOOL ) automaticallyNotifiesObserversOfSubscriptions
    {
    return NO;
    }

// Directly invoked by TDS.
// We should never invoke this method explicitly.
- ( void ) setSubscriptions: ( TauYouTubeSubscriptionsCollection* )_New
    {
    if ( subscriptions_ != _New )
        TAU_CHANGE_VALUE_FOR_KEY( subscriptions, ^{ subscriptions_ = _New; } );
    }

- ( TauYouTubeSubscriptionsCollection* ) subscriptions
    {
    return subscriptions_;
    }

@end // TauSubscriptionsCollectionContentSubViewController class