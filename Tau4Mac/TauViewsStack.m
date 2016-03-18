#import "TauViewsStack.h"

#define priViewsStack_kvoKey @"priViewsStack_"

// Private Interfaces
@interface TauViewsStack ()

@property ( strong, readwrite ) NSMutableArray <NSViewController*>* priViewsStack_;         // KVO_Observable

@end // Private Interfaces

// TauViewsStack class
@implementation TauViewsStack

#define THROW_ARGUMENTS_MUST_NO_BE_NIL_EX \
do { \
@throw [ NSException \
    exceptionWithName: NSInvalidArgumentException \
               reason: [ NSString stringWithFormat: @"Argument of %@ must not be nil", THIS_METHOD ] \
             userInfo: @{ @"file" : THIS_FILE, @"method" : THIS_METHOD, @"line" : @( __LINE__ ) } ]; \
} while( 0 )

#pragma mark - Initializations

- ( instancetype ) init
    {
    if ( self = [ super init ] )
        self.priViewsStack_ = [ NSMutableArray array ];

    return self;
    }

#pragma mark - Stack Operations

- ( void ) pushView: ( NSViewController* )_ViewController
    {
    if ( _ViewController.view )
        {
        NSIndexSet* affectedIndexes = [ NSIndexSet indexSetWithIndex: priViewsStack_.count ];

        [ self willChange: NSKeyValueChangeInsertion valuesAtIndexes: affectedIndexes forKey: priViewsStack_kvoKey ];
        [ priViewsStack_ addObject: _ViewController ];
        [ self didChange: NSKeyValueChangeInsertion valuesAtIndexes: affectedIndexes forKey: priViewsStack_kvoKey ];
        }
    else
        THROW_ARGUMENTS_MUST_NO_BE_NIL_EX;
    }

- ( void ) popView
    {
    if ( priViewsStack_.count > 0 )
        {
        NSIndexSet* affectedIndexes = [ NSIndexSet indexSetWithIndex: [ priViewsStack_ indexOfObject: priViewsStack_.lastObject ] ];

        [ self willChange: NSKeyValueChangeRemoval valuesAtIndexes: affectedIndexes forKey: priViewsStack_kvoKey ];
        [ priViewsStack_ removeLastObject ];
        [ self didChange: NSKeyValueChangeRemoval valuesAtIndexes: affectedIndexes forKey: priViewsStack_kvoKey ];
        }
    }

- ( void ) popAll
    {
    if ( priViewsStack_.count > 0 )
        {
        NSIndexSet* affectedIndexes = [ NSIndexSet indexSetWithIndexesInRange: NSMakeRange( 0, priViewsStack_.count ) ];

        [ self willChange: NSKeyValueChangeRemoval valuesAtIndexes: affectedIndexes forKey: priViewsStack_kvoKey ];
        [ priViewsStack_ removeAllObjects ];
        [ self didChange: NSKeyValueChangeRemoval valuesAtIndexes: affectedIndexes forKey: priViewsStack_kvoKey ];
        }
    }

#pragma mark - KVO-Observable External Properties

@synthesize backgroundViewController = backgroundViewController_;
+ ( BOOL ) automaticallyNotifiesObserversOfBackgroundViewController
    {
    return NO;
    }

- ( void ) setBackgroundViewController: ( NSViewController* )_New
    {
    if ( !_New )
        THROW_ARGUMENTS_MUST_NO_BE_NIL_EX;

    if ( backgroundViewController_ != _New )
        {
        [ self willChangeValueForKey: @"backgroundViewController" ];
        backgroundViewController_ = _New;
        [ self didChangeValueForKey: @"backgroundViewController" ];
        }
    }

- ( NSViewController* ) backgroundViewController
    {
    return backgroundViewController_;
    }

@dynamic currentView;
+ ( NSSet <NSString*>* ) keyPathsForValuesAffectingCurrentView
    {
    return [ NSSet setWithObjects: priViewsStack_kvoKey, @"backgroundViewController", nil ];
    }

- ( NSViewController* ) currentView
    {
    NSViewController* currentViewController = nil;

    if ( priViewsStack_.count > 0 )
        currentViewController = priViewsStack_.lastObject;
    else
        currentViewController = backgroundViewController_;

    return currentViewController;
    }

@dynamic viewBeforeCurrentView;
+ ( NSSet <NSString*>* ) keyPathsForValuesAffectingViewBeforeCurrentView
    {
    return [ NSSet setWithObjects: currentView_kvoKey, nil ];
    }

- ( NSViewController* ) viewBeforeCurrentView
    {
    NSViewController* interestingViewController = nil;
    NSViewController* current = self.currentView;

    NSUInteger currentIndex = [ priViewsStack_ indexOfObject: current ];
    if ( ( currentIndex > 0 ) && ( currentIndex != NSNotFound ) )
        interestingViewController = [ priViewsStack_ objectAtIndex: currentIndex - 1 ];
    else
        interestingViewController = backgroundViewController_;

    return interestingViewController;
    }

#pragma mark Private Interfaces

@synthesize priViewsStack_;
+ ( BOOL ) automaticallyNotifiesObserversOfPriViewsStack_
    {
    return NO;
    }

@end // TauViewsStack class