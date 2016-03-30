#import "TauViewsStack.h"

// Private Interfaces
@interface TauViewsStack ()
@property ( strong, readwrite ) NSMutableArray <NSViewController*>* priViewsStack_;         // KVO_Observable
@end // Private Interfaces



// ------------------------------------------------------------------------------------------------------------ //



#define THROW_ARGUMENTS_MUST_NO_BE_NIL_EX \
do { \
@throw [ NSException \
    exceptionWithName: NSInvalidArgumentException \
               reason: [ NSString stringWithFormat: @"Argument of %@ must not be nil", THIS_METHOD ] \
             userInfo: @{ @"file" : THIS_FILE, @"method" : THIS_METHOD, @"line" : @( __LINE__ ) } ]; \
} while( 0 )

#define THROW_BG_VIEW_IS_REQUIRED_EX \
do { \
@throw [ NSException \
    exceptionWithName: NSInternalInconsistencyException \
               reason: [ NSString stringWithFormat: @"Background view is required" ] \
             userInfo: @{ @"file" : THIS_FILE, @"method" : THIS_METHOD, @"line" : @( __LINE__ ) } ]; \
} while( 0 )



// ------------------------------------------------------------------------------------------------------------ //



// TauViewsStack class
@implementation TauViewsStack

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
    if ( !self.backgroundViewController )
        THROW_BG_VIEW_IS_REQUIRED_EX;

    if ( _ViewController.view )
        {
        NSIndexSet* affectedIndexes = [ NSIndexSet indexSetWithIndex: priViewsStack_.count ];

        [ self willChange: NSKeyValueChangeInsertion valuesAtIndexes: affectedIndexes forKey: TauKVOStrictKey( priViewsStack_ ) ];
        [ priViewsStack_ addObject: _ViewController ];
        [ self didChange: NSKeyValueChangeInsertion valuesAtIndexes: affectedIndexes forKey: TauKVOStrictKey( priViewsStack_ ) ];
        }
    else
        THROW_ARGUMENTS_MUST_NO_BE_NIL_EX;
    }

- ( void ) popView
    {
    if ( !self.backgroundViewController )
        THROW_BG_VIEW_IS_REQUIRED_EX;

    if ( priViewsStack_.count > 0 )
        {
        NSIndexSet* affectedIndexes = [ NSIndexSet indexSetWithIndex: [ priViewsStack_ indexOfObject: priViewsStack_.lastObject ] ];

        [ self willChange: NSKeyValueChangeRemoval valuesAtIndexes: affectedIndexes forKey: TauKVOStrictKey( priViewsStack_ ) ];
        [ priViewsStack_ removeLastObject ];
        [ self didChange: NSKeyValueChangeRemoval valuesAtIndexes: affectedIndexes forKey: TauKVOStrictKey( priViewsStack_ ) ];
        }
    }

- ( void ) popAll
    {
    if ( !self.backgroundViewController )
        THROW_BG_VIEW_IS_REQUIRED_EX;

    if ( priViewsStack_.count > 0 )
        {
        NSIndexSet* affectedIndexes = [ NSIndexSet indexSetWithIndexesInRange: NSMakeRange( 0, priViewsStack_.count ) ];

        [ self willChange: NSKeyValueChangeRemoval valuesAtIndexes: affectedIndexes forKey: TauKVOStrictKey( priViewsStack_ ) ];
        [ priViewsStack_ removeAllObjects ];
        [ self didChange: NSKeyValueChangeRemoval valuesAtIndexes: affectedIndexes forKey: TauKVOStrictKey( priViewsStack_ ) ];
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
    return [ NSSet setWithObjects: TauKVOStrictKey( priViewsStack_ ), @"backgroundViewController", nil ];
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
    return [ NSSet setWithObjects: TauKVOStrictKey( currentView ), nil ];
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