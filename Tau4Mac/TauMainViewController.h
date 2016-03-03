//
//  TauMainViewController.h
//  Tau4Mac
//
//  Created by Tong G. on 3/3/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

// TauMainViewController class
@interface TauMainViewController : NSViewController

#pragma mark - Outlets

@property ( weak ) IBOutlet NSSearchField* searchField;

#pragma mark - IBActions

- ( IBAction ) searchUserInputAction: ( id )_Sender;

@end // TauMainViewController class