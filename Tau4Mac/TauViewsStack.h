
#define currentView_kvoKey           @"currentView"
#define viewBeforeCurrentView_kvoKey @"viewBeforeCurrentView"

// TauViewsStack class
@interface TauViewsStack : NSObject

// Base View
@property ( weak ) NSViewController* backgroundViewController;

#pragma mark - Stack Operations

- ( void ) pushView: ( NSViewController* )_ViewController;
- ( void ) popView;
- ( void ) popAll;

#pragma mark - KVO-Observable External Properties

@property ( strong, readonly ) NSViewController* currentView;           // KVO-Observable
@property ( strong, readonly ) NSViewController* viewBeforeCurrentView; // KVO-Observable

@end // TauViewsStack class