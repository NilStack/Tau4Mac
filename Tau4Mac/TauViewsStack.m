#import "TauViewsStack.h"

#define priViewsStack_kvoKey @"priViewsStack_"

// Private Interfaces
@interface TauViewsStack ()

@property ( strong, readwrite ) NSMutableArray <NSViewController*>* priViewsStack_;         // KVO_Observable
@property ( strong, readwrite ) NSMutableArray <NSViewController*>* proxyOfPriViewsStack_;

@end // Private Interfaces

// TauViewsStack class
@implementation TauViewsStack

@synthesize backgroundViewController = backgroundViewController_;

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
        [ self.proxyOfPriViewsStack_ addObject: _ViewController ];
    else
        @throw [ NSException exceptionWithName: NSInvalidArgumentException
                                        reason: [ NSString stringWithFormat: @"Parameter of %@ must not be nil", THIS_METHOD ]
                                      userInfo: @{ @"file" : THIS_FILE, @"method" : THIS_METHOD, @"line" : @( __LINE__ ) } ];
    }

- ( void ) popView
    {
    if ( priViewsStack_.count > 0 )
        [ self.proxyOfPriViewsStack_ removeLastObject ];
    }

- ( void ) popAll
    {
    [ self.proxyOfPriViewsStack_ removeAllObjects ];
    }

#pragma mark - KVO-Observable External Properties

@dynamic currentView;
+ ( NSSet <NSString*>* ) keyPathsForValuesAffectingCurrentView
    {
    return [ NSSet setWithObjects: priViewsStack_kvoKey, nil ];
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
- ( NSUInteger ) countOfPriViewsStack_
    {
    return priViewsStack_.count;
    }

- ( NSArray <NSViewController*>* ) priViewsStack_AtIndexes: ( NSIndexSet* )_Indexes
    {
    return [ priViewsStack_ objectsAtIndexes: _Indexes ];
    }

- ( void ) getPriViewsStack_: ( NSViewController * __unsafe_unretained* )_Buffer range: ( NSRange )_InRange
    {
    return [ priViewsStack_ getObjects: _Buffer range: _InRange ];
    }

- ( void ) insertPriViewsStack_: ( NSArray* )_Array atIndexes: ( NSIndexSet* )_Indexes
    {
    [ priViewsStack_ insertObjects: _Array atIndexes: _Indexes ];
    }

- ( void ) removePriViewsStack_AtIndexes: ( NSIndexSet* )_Indexes
    {
    [ priViewsStack_ removeObjectsAtIndexes: _Indexes ];
    }

- ( void ) replacePriViewsStack_AtIndexes: ( NSIndexSet* )_Indexes withPriViewsStack_: ( NSArray* )_Array
    {
    [ priViewsStack_ replaceObjectsAtIndexes: _Indexes withObjects: _Array ];
    }

@dynamic proxyOfPriViewsStack_;
- ( NSMutableArray <NSViewController*>* ) proxyOfPriViewsStack_
    {
    return [ self mutableArrayValueForKey: priViewsStack_kvoKey ];
    }

@end // TauViewsStack class