//
//  TauContentCollectionItemView.h
//  Tau4Mac
//
//  Created by Tong G. on 3/3/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

// TauContentCollectionItemView class

@interface TauContentCollectionItemView : NSControl

#pragma mark - Properties

@property ( strong, readwrite ) GTLObject* YouTubeContent;
@property ( assign, readonly ) TauYouTubeContentType type;

@property ( assign, readwrite, setter = setSelected: ) BOOL isSelected;
@property ( assign, readwrite ) NSCollectionViewItemHighlightState highlightState;

@end // TauContentCollectionItemView class