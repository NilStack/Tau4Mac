//
//  TauPanelStackViewController.h
//  Tau4Mac
//
//  Created by Tong G. on 3/5/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

@class TauStackViewItem;

// TauPanelStackViewController class
@interface TauPanelStackViewController : NSViewController

- ( void ) pushView: ( TauStackViewItem* )_NewItem;
- ( void ) popView;

@end // TauPanelStackViewController class