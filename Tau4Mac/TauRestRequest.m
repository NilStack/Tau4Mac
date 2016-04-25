//
//  TauRestRequest.m
//  Tau4Mac
//
//  Created by Tong G. on 4/24/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauRestRequest.h"

// TauRestRequest class
@implementation TauRestRequest

@synthesize type, fieldFilter, maxResultsPerPage, verboseLevelMask, prevPageToken, nextPageToken;
@dynamic isMine, ytQuery;

#pragma mark - Conforms to <NSCopying>
// TODO:

#pragma mark - Conforms to <NSSecureCoding>

+ ( BOOL ) supportsSecureCoding
    {
    return [ self conformsToProtocol: @protocol( NSSecureCoding ) ];
    }

// TODO:

@end // TauRestRequest class