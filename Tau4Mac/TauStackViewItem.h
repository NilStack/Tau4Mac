//
//  TauStackViewItem.h
//  Tau4Mac
//
//  Created by Tong G. on 3/5/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class TauAbstractStackPanelController;

@interface TauStackViewItem : NSViewController

@property ( weak, readwrite ) TauAbstractStackPanelController* hostStack;

@end
