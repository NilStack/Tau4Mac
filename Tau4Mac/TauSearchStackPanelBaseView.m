//
//  TauSearchStackPanelBaseView.m
//  Tau4Mac
//
//  Created by Tong G. on 3/3/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauSearchStackPanelBaseView.h"

// TauSearchStackPanelBaseView class
@implementation TauSearchStackPanelBaseView

#pragma mark - Initializations

- ( void ) awakeFromNib
    {
    [ self autoSetDimension: ALDimensionWidth toSize: 0.f relation: NSLayoutRelationGreaterThanOrEqual ];
    [ self autoSetDimension: ALDimensionHeight toSize: 0.f relation: NSLayoutRelationGreaterThanOrEqual ];
    }

@end // TauSearchStackPanelBaseView class