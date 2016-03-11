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

// Private Interfaces
@interface TauViewsStack ()
- ( NSViewController* ) _currentView;
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

- ( void ) pushView: ( NSViewController* )_ViewController
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

- ( void ) popAll
    {
    [ self->_viewsStack removeAllObjects ];
    }

- ( NSViewController* ) currentView
    {
    return [ self _currentView ];
    }

- ( NSViewController* ) viewBeforeCurrentView
    {
    NSViewController* interestingView = nil;
    NSViewController* current = [ self _currentView ];
    NSUInteger currentIndex = [ self->_viewsStack indexOfObject: current ];
    if ( currentIndex > 0 && currentIndex != NSNotFound )
        interestingView = [ self->_viewsStack objectAtIndex: currentIndex - 1 ];
    else
        interestingView = self.baseViewController;

    return interestingView;
    }

#pragma mark Private Interfaces
- ( NSViewController* ) _currentView
    {
    NSViewController* currentViewController = nil;

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