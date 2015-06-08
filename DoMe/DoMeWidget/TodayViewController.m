//
//  TodayViewController.m
//  DoMeWidget
//
//  Created by Leonardo Mendez on 20/05/15.
//  Copyright (c) 2015 Joonik. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "TodayCell.h"
#import "DoMeTable.h"
#import "ObjectiveRecord.h"
#import "DoMeTableFav.h"

@interface TodayViewController () <NCWidgetProviding>{
    DoMeTable *nota;
}
@property (strong, nonatomic) IBOutlet UICollectionView *CollectionView;

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [CoreDataManager sharedManager].modelName = @"DoMe";
//    [CoreDataManager sharedManager].databaseName = @"_data";
//    self.arrayNotas2 = [[DoMeTableFav all] mutableCopy];
//    self.arrayNotas = [[NSMutableArray alloc]init];
//    [self cargarnota];
//    self.preferredContentSize = CGSizeMake(0, 120);
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [CoreDataManager sharedManager].modelName = @"DoMe";
    [CoreDataManager sharedManager].databaseName = @"_data";
   // self.arrayNotas2 = [[DoMeTableFav all] mutableCopy];
    self.arrayNotas = [[NSMutableArray alloc]init];
    [self cargarnota];
   self.preferredContentSize = CGSizeMake(0, 110);
   //self.preferredContentSize = _CollectionView.contentSize;
   [_CollectionView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {

    completionHandler(NCUpdateResultNewData);
}

-(void)cargarnota{
    
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.Joonik.Leo.group"];
    _arrayNotas = [defaults objectForKey:@"fraseKey"];
    
//    for (int i=0; i < _arrayNotas.count; i++) {
//        DoMeTableFav *buc =[DoMeTableFav find:@"favorito == %@",_arrayNotas[i]];
//        if (buc == NULL) {
//            DoMeTableFav *notafav = [DoMeTableFav create];
//            notafav.favorito = [NSString stringWithFormat:@"%@", _arrayNotas[i]];
//            [notafav save];
//        }
//        
//    }
    //  if(![listTemp containsObject:[_List objectAtIndex:sender.tag]]){
    
    
    
    
   NSLog(@"%@",_arrayNotas);
}

#pragma mark - CollectionView methods


-(NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.NewContact"];
    //    NSString *number = [defaults stringForKey:@"NumberKey"];
    
    //    return number == nil ? 0 : [_arrayData count];
         return [_arrayNotas count];
//   return 6;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    TodayCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    NSString *notas = [_arrayNotas objectAtIndex:indexPath.row];
    cell.labelWidget.text = notas;
//  DoMeTableFav *notas = [_arrayNotas objectAtIndex:indexPath.row];
//  cell.labelWidget.text = notas.favorito;
    cell.layer.borderColor = [UIColor whiteColor].CGColor;
    cell.layer.borderWidth = 1;
    [cell.layer setCornerRadius:25.0f];
    [cell setClipsToBounds:YES];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"dd/MM/yyyy"];
    NSString *fecha = [formatter stringFromDate:[NSDate date]];
    
    NSDateFormatter *formatter2 = [NSDateFormatter new];
    [formatter2 setDateFormat:@"hh:mm a"];
    NSString *hora = [formatter2 stringFromDate:[NSDate date]];
    
    NSString *copy = [_arrayNotas objectAtIndex:indexPath.row];
    copy = [copy stringByReplacingOccurrencesOfString:@"dd/mm/aaaa" withString:fecha];
    copy = [copy stringByReplacingOccurrencesOfString:@"hh:mi" withString:hora];
    
    UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
    [pasteBoard setString:copy];
    
}


@end
