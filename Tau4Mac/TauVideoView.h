//
//  TauVideoView.h
//  Tau4Mac
//
//  Created by Tong G. on 3/3/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

// TauVideoView class
@interface TauVideoView : NSView
    {
@protected
    GTLObject __strong* ytVideo_;
    }

#pragma mark - Initializations

- ( instancetype ) initWithGTLObject: ( GTLObject* )_GTLObject;

#pragma mark - Properties

@property ( strong, readwrite ) GTLObject* ytVideo;

@end // TauVideoView class