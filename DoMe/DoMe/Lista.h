//
//  Lista.h
//  DoMe
//
//  Created by Leonardo Mendez on 19/05/15.
//  Copyright (c) 2015 Joonik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Lista : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate>

@property (nonatomic, retain) NSMutableArray *arrayNotas;
@end
