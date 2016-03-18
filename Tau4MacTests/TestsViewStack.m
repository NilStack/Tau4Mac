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

@end // TestsViewStack class

int static const kCurrentViewKVOCtx;

#define PUSH_ONE_BY_ONE_CUTTING printf( "\n\n\n======== Push One by One =========\n\n\n" )
#define POP_ONE_BY_ONE_CUTTING  printf( "\n\n\n======== Pop One by One =========\n\n\n" )
#define POP_ALL_CUTTING         printf( "\n\n\n======== Pop All =========\n\n\n" )

// TestsViewStack class
@implementation TestsViewStack
    {
    NSViewController* bgViewContorller_;
    TauViewsStack __strong* viewStack_;

    NSBundle __strong* priSampleViewContorllerBundle_;
    }

- ( void ) setUp
    {
    viewStack_ = [ [ TauViewsStack alloc ] init ];
    bgViewContorller_ = [ [ BgViewController alloc ] initWithNibName: nil bundle: nil ];

    viewStack_.backgroundViewController = bgViewContorller_;

    [ viewStack_ addObserver: self forKeyPath: @"currentView" options: NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld | NSKeyValueObservingOptionInitial context: ( void* )&kCurrentViewKVOCtx ];
    }

- ( void ) observeValueForKeyPath: ( NSString* )_KeyPath ofObject: ( id )_Object change: ( NSDictionary <NSString*, id>* )_Change context: ( void* )_Context
    {
    if ( _Context == &kCurrentViewKVOCtx )
        DDLogInfo( @"Change of \"%@\"'s value %@", _KeyPath, _Change );
    }

- ( void ) testMixedStackOperations_pos0
    {
    PUSH_ONE_BY_ONE_CUTTING;
    for ( int _Index = 0; _Index < TAU_UNITTEST_SAMPLES_COUNT; _Index++ )
        {
        ViewStackItem* stackItem = [ [ ViewStackItem alloc ] initWithNibName: nil bundle: self.sampleViewContorllerBundle_ ];
        [ stackItem setIdentifier: [ NSString stringWithFormat: @"pop0-rolling-out-%@", @( _Index ) ] ];
        [ viewStack_ pushView: stackItem ];
        }

    POP_ONE_BY_ONE_CUTTING;
    for ( int _Index = 0; _Index < TAU_UNITTEST_SAMPLES_COUNT; _Index++ )
        [ viewStack_ popView ];
    }

- ( void ) testMixedStackOperations_pos1
    {
    PUSH_ONE_BY_ONE_CUTTING;
    for ( int _Index = 0; _Index < TAU_UNITTEST_SAMPLES_COUNT; _Index++ )
        {
        ViewStackItem* stackItem = [ [ ViewStackItem alloc ] initWithNibName: nil bundle: self.sampleViewContorllerBundle_ ];
        [ stackItem setIdentifier: [ NSString stringWithFormat: @"pos1-rolling-out-%@", @( _Index ) ] ];
        [ viewStack_ pushView: stackItem ];
        }

    POP_ALL_CUTTING;
    [ viewStack_ popAll ];
    }

#pragma mark - Private

- ( NSBundle* ) sampleViewContorllerBundle_
    {
    if ( !priSampleViewContorllerBundle_ )
        priSampleViewContorllerBundle_ = [ NSBundle bundleForClass: [ ViewStackItem class ] ];
    return priSampleViewContorllerBundle_;
    }

@end // TestsViewStack class