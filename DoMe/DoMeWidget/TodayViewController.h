//
//  TodayViewController.h
//  DoMeWidget
//
//  Created by Leonardo Mendez on 20/05/15.
//  Copyright (c) 2015 Joonik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TodayViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, retain) NSMutableArray *arrayNotas2;
@property (nonatomic, retain) NSMutableArray *arrayNotas;

@end
