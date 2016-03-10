//
//  TauEntryMosEnteredInteractionView.h
//  Tau4Mac
//
//  Created by Tong G. on 3/9/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauAbstractEntryMosInteractionView.h"

@class TauMosEnteredInteractionButton;

// TauEntryMosEnteredInteractionView class
@interface TauEntryMosEnteredInteractionView : TauAbstractEntryMosInteractionView

@property ( strong, readonly ) TauMosEnteredInteractionButton* interactionButton;

@end // TauEntryMosEnteredInteractionView class