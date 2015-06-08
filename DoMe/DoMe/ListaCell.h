//
//  ListaCell.h
//  DoMe
//
//  Created by Leonardo Mendez on 19/05/15.
//  Copyright (c) 2015 Joonik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealTableViewCell.h"
#import "DoMeTable.h"

@interface ListaCell : SWRevealTableViewCell

@property (strong, nonatomic) IBOutlet UILabel *DesList;
@property (strong, nonatomic) IBOutlet UILabel *numero;
@property (nonatomic,retain)DoMeTable *nota;
@end
