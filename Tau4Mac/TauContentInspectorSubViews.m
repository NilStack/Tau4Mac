//
//  TauContentInspectorSubViews.m
//  Tau4Mac
//
//  Created by Tong G. on 3/31/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauContentInspectorSubViews.h"

// Private
@interface TauContentInspectorNoSelectionSubView ()
@property ( weak ) IBOutlet NSView* noSelectionLabelSection_;
@end // Private

// TauContentInspectorNoSelectionSubView class
@implementation TauContentInspectorNoSelectionSubView
@end // TauContentInspectorNoSelectionSubView class



// ------------------------------------------------------------------------------------------------------------ //



// PriContentTitleView_ class
@interface PriContentTitleSectionView_ : NSView
@property ( copy ) NSString* title;
@end

@implementation PriContentTitleSectionView_
    {
    NSTextFieldCell __strong* cell_;
    }

#pragma mark - Init

- ( instancetype ) initWithCoder: ( NSCoder* )_Coder
    {
    if ( self = [ super initWithCoder: _Coder ] )
        {
        cell_ = [ [ NSTextFieldCell alloc ] initTextCell: @"" ];
        [ cell_ setFont: [ NSFont fontWithName: @"PingFang SC Regular" size: 18.f ] ];
        [ cell_ setTextColor: [ NSColor colorWithSRGBRed: 51.f / 255 green: 51.f / 255 blue: 51.f / 255 alpha: 1.f ] ];
        [ cell_ setLineBreakMode: NSLineBreakByTruncatingTail ];
        [ cell_ setUsesSingleLineMode: YES ];
        [ cell_ setTruncatesLastVisibleLine: YES ];
        }

    return self;
    }

#pragma mark - Drawing

- ( void ) drawRect: ( NSRect )_DirtyRect
    {
    [ super drawRect: _DirtyRect ];
    [ cell_ drawWithFrame: NSInsetRect( _DirtyRect, 15.f, 10.f ) inView: self ];
    }

@dynamic title;
- ( void ) setTitle: ( NSString* )_New
    {
    [ cell_ setTitle: _New ];
    [ self setNeedsDisplay: YES ];
    }

- ( NSString* ) title
    {
    return cell_.title;
    }

@end // PriContentTitleView_ class

// Private
@interface TauContentInspectorSingleSelectionSubView ()

/*************** Embedding the split view controller ***************/

@property ( strong, readonly ) NSSplitViewController* splitInspectorViewController_;

// These guys will be used as fodder of the split inspector view controller above
@property ( strong, readonly ) NSSplitViewItem* singleContentTitleSectionItem_;
@property ( strong, readonly ) NSSplitViewItem* singleContentActionSectionItem_;
@property ( strong, readonly ) NSSplitViewItem* singleContentDescriptionSectionItem_;
@property ( strong, readonly ) NSSplitViewItem* singleContentInformationSectionItem_;

// These guys will be used as fodder of the split view items above
@property ( weak ) IBOutlet NSViewController* wrapperOfSingleContentTitleSectionView_;
@property ( weak ) IBOutlet NSViewController* wrapperOfSingleContentActionSectionView_;
@property ( weak ) IBOutlet NSViewController* wrapperOfSingleContentDescriptionSectionView_;
@property ( weak ) IBOutlet NSViewController* wrapperOfSingleContentInformationSectionView_;

/*************** Embedding the split view controller ***************/

@property ( weak ) IBOutlet PriContentTitleSectionView_* contentTitleSectionView_;

@end // Private

// TauContentInspectorSingleSelectionSubView class
@implementation TauContentInspectorSingleSelectionSubView

#pragma mark - Initializations

- ( void ) awakeFromNib
    {
    [ [ self configureForAutoLayout ] addSubview: self.splitInspectorViewController_.view ];
    [ [ self.splitInspectorViewController_.view configureForAutoLayout ] autoPinEdgesToSuperviewEdges ];
    }

@synthesize YouTubeContent = YouTubeContent_;
- ( void ) setYouTubeContent: ( GTLObject* )_New
    {
    YouTubeContent_ = _New;
    [ self.contentTitleSectionView_ setTitle: YouTubeContent_.JSON[ @"snippet" ][ @"title" ] ];
    }

- ( GTLObject* ) YouTubeContent
    {
    return YouTubeContent_;
    }

#pragma mark - Private

@synthesize splitInspectorViewController_ = priSplitInspectorViewController_;
- ( NSSplitViewController* ) splitInspectorViewController_
    {
    if ( !priSplitInspectorViewController_ )
        {
        priSplitInspectorViewController_ = [ [ NSSplitViewController alloc ] initWithNibName: nil bundle: nil ];
        priSplitInspectorViewController_.splitView.vertical = NO;
        priSplitInspectorViewController_.splitView.dividerStyle = NSSplitViewDividerStyleThin;

        [ priSplitInspectorViewController_ addSplitViewItem: self.singleContentTitleSectionItem_ ];
        [ priSplitInspectorViewController_ addSplitViewItem: self.singleContentActionSectionItem_ ];
        [ priSplitInspectorViewController_ addSplitViewItem: self.singleContentDescriptionSectionItem_ ];
        [ priSplitInspectorViewController_ addSplitViewItem: self.singleContentInformationSectionItem_ ];
        }

    return priSplitInspectorViewController_;
    }

    // These guys used for feeding the split inspector view controller above
@synthesize singleContentTitleSectionItem_ = priSingleContentTitleSectionItem_;
- ( NSSplitViewItem* ) singleContentTitleSectionItem_
    {
    if ( !priSingleContentTitleSectionItem_ )
        {
        priSingleContentTitleSectionItem_ = [ NSSplitViewItem splitViewItemWithViewController: self.wrapperOfSingleContentTitleSectionView_ ];
        priSingleContentTitleSectionItem_.canCollapse = NO;
        priSingleContentTitleSectionItem_.minimumThickness = 40.f;
        priSingleContentTitleSectionItem_.maximumThickness = 40.f;
        }

    return priSingleContentTitleSectionItem_;
    }

@synthesize singleContentActionSectionItem_ = priSingleContentActionSectionItem_;
- ( NSSplitViewItem* ) singleContentActionSectionItem_
    {
    if ( !priSingleContentActionSectionItem_ )
        priSingleContentActionSectionItem_ = [ NSSplitViewItem splitViewItemWithViewController: self.wrapperOfSingleContentActionSectionView_ ];
    return priSingleContentActionSectionItem_;
    }

@synthesize singleContentDescriptionSectionItem_ = priSingleContentDescriptionSectionItem_;
- ( NSSplitViewItem* ) singleContentDescriptionSectionItem_
    {
    if ( !priSingleContentDescriptionSectionItem_ )
        priSingleContentDescriptionSectionItem_ = [ NSSplitViewItem splitViewItemWithViewController: self.wrapperOfSingleContentDescriptionSectionView_ ];
    return priSingleContentDescriptionSectionItem_;
    }

@synthesize singleContentInformationSectionItem_ = priSingleContentInformationSectionItem_;
- ( NSSplitViewItem* ) singleContentInformationSectionItem_
    {
    if ( !priSingleContentInformationSectionItem_ )
        priSingleContentInformationSectionItem_ = [ NSSplitViewItem splitViewItemWithViewController: self.wrapperOfSingleContentInformationSectionView_ ];
    return priSingleContentInformationSectionItem_;
    }

@end // TauContentInspectorSingleSelectionSubView class



// ------------------------------------------------------------------------------------------------------------ //



// TauContentInspectorMultipleSelectionsSubView class
@implementation TauContentInspectorMultipleSelectionsSubView
@end // TauContentInspectorMultipleSelectionsSubView class