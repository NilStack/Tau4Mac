//
//  TauContentCollectionViewController.h
//  Tau4Mac
//
//  Created by Tong G. on 3/22/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface TauContentCollectionViewController : NSViewController
    <NSCollectionViewDataSource, NSCollectionViewDelegate, NSCollectionViewDelegateFlowLayout>

- ( void ) reloadData;

@end
