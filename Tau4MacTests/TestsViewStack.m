//
//  TestsViewStack.m
//  Tau4Mac
//
//  Created by Tong G. on 3/18/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauTestCase.h"
#import "TauViewsStack.h"

#import "BgViewController.h"
#import "ViewStackItem.h"

// TestsViewStack class
@interface TestsViewStack : TauTestCase

@property ( strong, readonly ) NSBundle* sampleViewContorllerBundle_;

- ( NSBundle* ) sampleViewContorllerBundle_;

- ( void ) observeKeyPathOfViewStack_: ( NSString* )_KeyPath;
- ( void ) cancelObserveKeyPathOfViewStack_: ( NSString* )_KeyPath;

- ( void ) filledUpViewStack_;
- ( void ) popViewStackOneByOne_;
- ( void ) popViewStackAtOnce_;

@end // TestsViewStack class

int static const kCurrentViewKVOCtx;
int static const kViewBeforeCurrentViewKVOCtx;

int static const kPriViewStackKVOCtx;

#define PUSH_ONE_BY_ONE_CUTTING printf( "\n\n\n======== Push One by One =========\n\n\n" )
#define POP_ONE_BY_ONE_CUTTING  printf( "\n\n\n======== Pop One by One =========\n\n\n" )
#define POP_ALL_CUTTING         printf( "\n\n\n======== Pop All =========\n\n\n" )

// TestsViewStack class
@implementation TestsViewStack
    {
    NSViewController __strong* bgViewContorller_;
    TauViewsStack __strong* viewStack_;

    NSBundle __strong* priSampleViewContorllerBundle_;
    }

- ( void ) setUp
    {
    bgViewContorller_ = [ [ BgViewController alloc ] initWithNibName: nil bundle: nil ];
    viewStack_ = [ [ TauViewsStack alloc ] initWithBackgroundViewController: bgViewContorller_ ];
    XCTAssertNotNil( viewStack_ );

    viewStack_ = [ [ TauViewsStack alloc ] init ];
    viewStack_.backgroundViewController = bgViewContorller_;
    XCTAssertNotNil( viewStack_ );
    }

- ( void ) observeValueForKeyPath: ( NSString* )_KeyPath ofObject: ( id )_Object change: ( NSDictionary <NSString*, id>* )_Change context: ( void* )_Context
    {
    DDLogInfo( @"Change of \"%@\"'s value %@", _KeyPath, _Change );
    }

#pragma mark - Positive Tests

// KVO compatibility of priViewsStack_

- ( void ) testOperation2PriViewStack_pos0
    {
    [ self observeKeyPathOfViewStack_: @"priViewsStack_" ];
        {
        [ self filledUpViewStack_ ];
        [ self popViewStackOneByOne_ ];
        }
    [ self cancelObserveKeyPathOfViewStack_: @"priViewsStack_" ];
    }

- ( void ) testOperation2PriViewStack_pos1
    {
    [ self observeKeyPathOfViewStack_: @"priViewsStack_" ];
        {
        [ self filledUpViewStack_ ];
        [ self popViewStackAtOnce_ ];
        }
    [ self cancelObserveKeyPathOfViewStack_: @"priViewsStack_" ];
    }

// KVO compatibility of external properties

- ( void ) testMixedStackOperations_pos0
    {
    [ self observeKeyPathOfViewStack_: @"currentView" ];
    [ self observeKeyPathOfViewStack_: @"viewBeforeCurrentView" ];
        {
        [ self filledUpViewStack_ ];
        [ self popViewStackOneByOne_ ];
        }
    [ self cancelObserveKeyPathOfViewStack_: @"viewBeforeCurrentView" ];
    [ self cancelObserveKeyPathOfViewStack_: @"currentView" ];
    }

- ( void ) testMixedStackOperations_pos1
    {
    [ self observeKeyPathOfViewStack_: @"currentView" ];
    [ self observeKeyPathOfViewStack_: @"viewBeforeCurrentView" ];
        {
        [ self filledUpViewStack_ ];
        [ self popViewStackAtOnce_ ];
        }
    [ self cancelObserveKeyPathOfViewStack_: @"viewBeforeCurrentView" ];
    [ self cancelObserveKeyPathOfViewStack_: @"currentView" ];
    }

#pragma mark - Negative Tests

- ( void ) testPushStackOperation_neg0
    {
    XCTAssertThrowsSpecificNamed( [ viewStack_ pushView: nil ], NSException, NSInvalidArgumentException
                                , @"Expecting a thrown exception instance of <%@> with NSInvalidArgumentException (\"%@\") description.", [ NSException class ], NSInvalidArgumentException
                                );
    }

#pragma mark - Private

- ( NSBundle* ) sampleViewContorllerBundle_
    {
    if ( !priSampleViewContorllerBundle_ )
        priSampleViewContorllerBundle_ = [ NSBundle bundleForClass: [ ViewStackItem class ] ];
    return priSampleViewContorllerBundle_;
    }

- ( void ) observeKeyPathOfViewStack_: ( NSString* )_KeyPath
    {
    void* ctx = nil;

    if ( [ _KeyPath isEqualToString: @"priViewsStack_" ] )
        ctx = ( void* )&kPriViewStackKVOCtx;
    else if ( [ _KeyPath isEqualToString: @"currentView" ] )
        ctx = ( void* )&kCurrentViewKVOCtx;
    else if ( [ _KeyPath isEqualToString: @"viewBeforeCurrentView" ] )
        ctx = ( void* )&kViewBeforeCurrentViewKVOCtx;

    [ viewStack_ addObserver: self forKeyPath: _KeyPath options: NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld | NSKeyValueObservingOptionInitial context: ctx ];
    }

- ( void ) cancelObserveKeyPathOfViewStack_: ( NSString* )_KeyPath
    {
    [ viewStack_ removeObserver: self forKeyPath: _KeyPath ];
    }

- ( void ) filledUpViewStack_
    {
    PUSH_ONE_BY_ONE_CUTTING;
    for ( int _Index = 0; _Index < TAU_UNITTEST_SAMPLES_COUNT; _Index++ )
        {
        ViewStackItem* stackItem = [ [ ViewStackItem alloc ] initWithNibName: nil bundle: self.sampleViewContorllerBundle_ ];
        [ stackItem setIdentifier: [ NSString stringWithFormat: @"pos0-rolling-out-%@", @( _Index ) ] ];

        XCTAssertNoThrow( [ viewStack_ pushView: stackItem ] );
        }
    }

- ( void ) popViewStackOneByOne_
    {
    POP_ONE_BY_ONE_CUTTING;
    for ( int _Index = 0; _Index < TAU_UNITTEST_SAMPLES_COUNT; _Index++ )
        [ viewStack_ popView ];
    }

- ( void ) popViewStackAtOnce_
    {
    POP_ALL_CUTTING;
    [ viewStack_ popAll ];
    }

@end // TestsViewStack class