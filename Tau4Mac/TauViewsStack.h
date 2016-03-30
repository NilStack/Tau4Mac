// TauViewsStack class
@interface TauViewsStack : NSObject

#pragma mark - Stack Operations

- ( void ) pushView: ( NSViewController* )_ViewController;
- ( void ) popView;
- ( void ) popAll;

#pragma mark - KVO-Observable External Properties

// Background View
@property ( weak ) NSViewController* backgroundViewController;          // KVO-Observable

@property ( strong, readonly ) NSViewController* currentView;           // KVO-Observable
@property ( strong, readonly ) NSViewController* viewBeforeCurrentView; // KVO-Observable

@end // TauViewsStack class