//
//  TauContentCollectionItemView.h
//  Tau4Mac
//
//  Created by Tong G. on 3/3/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

// TauContentCollectionItemView class

@interface TauContentCollectionItemView : NSControl

#pragma mark - Initializations

- ( instancetype ) initWithGTLObject: ( GTLObject* )_GTLObject;

#pragma mark - Properties

@property ( strong, readwrite ) GTLObject* ytContent;
@property ( assign, readonly ) TauYouTubeContentType type;

@end // TauContentCollectionItemView class