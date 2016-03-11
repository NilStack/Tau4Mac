//
//  TauMainWindowController.h
//  Tau4Mac
//
//  Created by Tong G. on 3/3/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

@class TauMainViewController;

// TauMainWindowController class
@interface TauMainWindowController : NSWindowController
    <NSApplicationDelegate, NSToolbarDelegate>

- ( IBAction ) signOutAction: ( id )_Sender;

@property ( weak ) IBOutlet NSToolbar* toolbar;

@end // TauMainWindowController class