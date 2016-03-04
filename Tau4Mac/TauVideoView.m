//
//  TauVideoView.m
//  Tau4Mac
//
//  Created by Tong G. on 3/4/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauVideoView.h"

// TauVideoView class
@implementation TauVideoView

#pragma mark - Overrides

- ( void ) setYtContent: ( GTLObject* )_ytContent
    {
    DDAssert( ( !( _ytContent ) )
                || [ _ytContent isKindOfClass: [ GTLYouTubeVideo class ] ]
                || ( [ _ytContent isKindOfClass: [ GTLYouTubeSearchResult class ] ]
                        && [ [ ( GTLYouTubeSearchResult* )_ytContent identifier ].kind isEqualToString: @"youtube#video" ] )
            , @"[%@] isn't a YouTube video, YouTube search result that is kind of youtube#video or nil."
            , _ytContent
            );

    [ super setYtContent: _ytContent ];
    }

@end // TauVideoView class