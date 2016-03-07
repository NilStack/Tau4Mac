
// TauViewsStack class
@interface TauViewsStack : NSObject
    {
@private
    NSMutableArray <NSViewController*> __strong* _viewsStack;
    }

// Base View
@property ( weak ) NSViewController* baseViewController;

// Views Stack
@property ( strong, readonly ) NSMutableArray* viewsStack;

- ( void ) pushView: ( NSViewController* )_ViewController;
- ( void ) popView;

- ( NSViewController* ) currentView;
- ( NSViewController* ) viewBeforeCurrentView;

@end // TauViewsStack class