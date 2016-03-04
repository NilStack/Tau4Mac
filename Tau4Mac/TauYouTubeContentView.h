//
//  TauYouTubeContentView.h
//  Tau4Mac
//
//  Created by Tong G. on 3/3/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

// TauYouTubeContentView class
@interface TauYouTubeContentView : NSView
    {
@protected
    GTLObject __strong* ytContent_;
    }

#pragma mark - Initializations

- ( instancetype ) initWithGTLObject: ( GTLObject* )_GTLObject;

#pragma mark - Properties

@property ( strong, readwrite ) GTLObject* ytContent;

@end // TauYouTubeContentView class