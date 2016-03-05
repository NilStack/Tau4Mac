//
//  TauSearchPanelViewController.h
//  Tau4Mac
//
//  Created by Tong G. on 3/5/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface TauSearchPanelViewController : NSViewController

#pragma mark - Outlets

@property ( weak ) IBOutlet NSSearchField* searchField;

#pragma mark - IBActions

- ( IBAction ) searchUserInputAction: ( id )_Sender;

@end
