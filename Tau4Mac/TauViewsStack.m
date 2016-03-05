/*=============================================================================┐
|             _  _  _       _                                                  |  
|            (_)(_)(_)     | |                            _                    |██
|             _  _  _ _____| | ____ ___  ____  _____    _| |_ ___              |██
|            | || || | ___ | |/ ___) _ \|    \| ___ |  (_   _) _ \             |██
|            | || || | ____| ( (__| |_| | | | | ____|    | || |_| |            |██
|             \_____/|_____)\_)____)___/|_|_|_|_____)     \__)___/             |██
|                                                                              |██
|                 _______    _             _                 _                 |██
|                (_______)  (_)           | |               | |                |██
|                    _ _ _ _ _ ____   ___ | |  _ _____  ____| |                |██
|                   | | | | | |  _ \ / _ \| |_/ ) ___ |/ ___)_|                |██
|                   | | | | | | |_| | |_| |  _ (| ____| |    _                 |██
|                   |_|\___/|_|  __/ \___/|_| \_)_____)_|   |_|                |██
|                             |_|                                              |██
|                                                                              |██
|                         Copyright (c) 2015 Tong Kuo                          |██
|                                                                              |██
|                             ALL RIGHTS RESERVED.                             |██
|                                                                              |██
└==============================================================================┘██
  ████████████████████████████████████████████████████████████████████████████████
  ██████████████████████████████████████████████████████████████████████████████*/

#import "TauViewsStack.h"
#import "TauViewController.h"

// Private Interfaces
@interface TauViewsStack ()
- ( TauViewController* ) _currentView;
@end // Private Interfaces

// TauViewsStack class
@implementation TauViewsStack

@synthesize baseViewController = _baseViewController;
@synthesize viewsStack = _viewsStack;

- ( instancetype ) init
    {
    if ( self = [ super init ] )
        self->_viewsStack = [ NSMutableArray array ];

    return self;
    }

- ( void ) pushView: ( TauViewController* )_ViewController
    {
    if ( _ViewController.view )
        [ self->_viewsStack addObject: _ViewController ];

    // TODO: Handling error: _ViewController.view must not be nil
    }

- ( void ) popView
    {
    if ( self->_viewsStack.count > 0 )
        [ self->_viewsStack removeLastObject ];
    }

- ( TauViewController* ) currentView
    {
    return [ self _currentView ];
    }

- ( TauViewController* ) viewBeforeCurrentView
    {
    TauViewController* interestingView = nil;
    TauViewController* current = [ self _currentView ];
    NSUInteger currentIndex = [ self->_viewsStack indexOfObject: current ];
    if ( currentIndex > 0 && currentIndex != NSNotFound )
        interestingView = [ self->_viewsStack objectAtIndex: currentIndex - 1 ];
    else
        interestingView = self.baseViewController;

    return interestingView;
    }

#pragma mark Private Interfaces
- ( TauViewController* ) _currentView
    {
    TauViewController* currentViewController = nil;

    if ( self->_viewsStack.count > 0 )
        currentViewController = self->_viewsStack.lastObject;
    else
        currentViewController = self.baseViewController;

    return currentViewController;
    }

@end // TauViewsStack class

/*=============================================================================┐
|                                                                              |
|                                        `-://++/:-`    ..                     |
|                    //.                :+++++++++++///+-                      |
|                    .++/-`            /++++++++++++++/:::`                    |
|                    `+++++/-`        -++++++++++++++++:.                      |
|                     -+++++++//:-.`` -+++++++++++++++/                        |
|                      ``./+++++++++++++++++++++++++++/                        |
|                   `++/++++++++++++++++++++++++++++++-                        |
|                    -++++++++++++++++++++++++++++++++`                        |
|                     `:+++++++++++++++++++++++++++++-                         |
|                      `.:/+++++++++++++++++++++++++-                          |
|                         :++++++++++++++++++++++++-                           |
|                           `.:++++++++++++++++++/.                            |
|                              ..-:++++++++++++/-                              |
|                             `../+++++++++++/.                                |
|                       `.:/+++++++++++++/:-`                                  |
|                          `--://+//::-.`                                      |
|                                                                              |
└=============================================================================*/