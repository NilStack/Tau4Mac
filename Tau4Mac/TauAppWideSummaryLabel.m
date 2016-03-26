//
//  TauAppWideSummaryLabel.m
//  Tau4Mac
//
//  Created by Tong G. on 3/26/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauAppWideSummaryLabel.h"

@implementation TauAppWideSummaryLabel

- ( void ) awakeFromNib
    {
    [ super awakeFromNib ];
    [ [ self configureForAutoLayout ] autoSetDimension: ALDimensionWidth toSize: 0.f relation: NSLayoutRelationGreaterThanOrEqual ];
    }

@end
