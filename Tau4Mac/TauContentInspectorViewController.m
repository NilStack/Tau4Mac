//
//  TauContentInspectorViewController.m
//  Tau4Mac
//
//  Created by Tong G. on 3/23/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauContentInspectorViewController.h"

// Private
@interface TauContentInspectorViewController ()
@property ( weak ) IBOutlet NSTextField* noSelectionLabel_;
@property ( weak ) IBOutlet NSArrayController* ytContentModelController_;
@end // Private



// ------------------------------------------------------------------------------------------------------------ //



// TauContentInspectorViewController class
@implementation TauContentInspectorViewController

- ( void ) viewDidLoad
    {
    [ super viewDidLoad ];
    // Do view setup here.

//    [ self.noSelectionLabel_ bind: @"value" toObject: self.repObjectModelController_ withKeyPath: @"arrangedObjects" options: nil ];
    }

@synthesize ytContents = ytContents_;
+ ( NSSet <NSString*>* ) keyPathsForValuesAffectingYtContents
    {
    return [ NSSet setWithObjects: TAU_KEY_OF_SEL( @selector( representedObject ) ), nil ];
    }

+ ( BOOL ) automaticallyNotifiesObserversOfYtContents
    {
    return NO;
    }

- ( void ) setYtContents: ( NSArray <GTLObject*>* )_New
    {
    if ( ytContents_ != _New )
        {
        TAU_CHANGE_VALUE_FOR_KEY_of_SEL( @selector( ytContents ),
         ( ^{
            ytContents_ = _New;
            DDLogInfo( @"%@", ytContents_ );
            } ) );
        }
    }

- ( NSArray <GTLObject*>* ) ytContents
    {
    return ytContents_;
    }

- ( void ) dealloc
    {
    DDLogDebug( @"%@ got allocated", self );
    }

@end // TauContentInspectorViewController class



// ------------------------------------------------------------------------------------------------------------ //



// TauContentInspectorView class
@implementation TauContentInspectorView

@end // TauContentInspectorView class