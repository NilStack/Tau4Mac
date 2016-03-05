//
//  TauSearchPanelView.m
//  Tau4Mac
//
//  Created by Tong G. on 3/3/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauSearchPanelView.h"

// TauSearchPanelView class
@implementation TauSearchPanelView

#pragma mark - Initializations

- ( void ) awakeFromNib
    {
    [ self configureForAutoLayout ];
    [ self autoSetDimension: ALDimensionWidth toSize: 0.f relation: NSLayoutRelationGreaterThanOrEqual ];
    [ self autoSetDimension: ALDimensionHeight toSize: 0.f relation: NSLayoutRelationGreaterThanOrEqual ];

    self.material = NSVisualEffectMaterialDark;
    self.state = NSVisualEffectStateActive;
    }

@end // TauSearchPanelView class