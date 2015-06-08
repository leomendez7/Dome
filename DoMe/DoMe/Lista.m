//
//  Lista.m
//  DoMe
//
//  Created by Leonardo Mendez on 19/05/15.
//  Copyright (c) 2015 Joonik. All rights reserved.
//

#import "Lista.h"
#import "ListaCell.h"
#import "ObjectiveRecord.h"
#import "DoMeTable.h"
#import "SWRevealTableViewCell.h"
#import "SCLAlertView.h"
#import "DoMeTableFav.h"


@interface Lista ()<SWRevealTableViewCellDelegate,SWRevealTableViewCellDataSource,UIActionSheetDelegate>
{
    DoMeTable *selectednota;
    NSIndexPath *_revealingCellIndexPath;
    NSMutableArray *tempo;
}

@property (strong, nonatomic) IBOutlet UITableView *TableView;
@property (strong, nonatomic) NSArray *searchResultd;

@end

@implementation Lista

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _arrayNotas = [[DoMeTable all] mutableCopy];
    tempo = [[NSMutableArray alloc]init];
    [self CargarpasaraWidget];
    [_TableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ([_searchResultd count] > 0) {
        
        return _searchResultd.count;
    }
    else{
        return _arrayNotas.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ListaCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if ([_searchResultd count] > 0) {
       
        DoMeTable *notas = [_searchResultd objectAtIndex:indexPath.row];
        cell.DesList.text = [NSString stringWithFormat:@"%ld. %@",(long)indexPath.row+1, notas.descripciondefrase];
        cell.delegate = self;
        cell.dataSource = self;
        cell.cellRevealMode = SWCellRevealModeNormal;
        cell.nota = notas;
    }else{
        
        DoMeTable *notas = [_arrayNotas objectAtIndex:indexPath.row];
        cell.DesList.text = [NSString stringWithFormat:@"%ld. %@",(long)indexPath.row+1, notas.descripciondefrase];
        cell.delegate = self;
        cell.dataSource = self;
        cell.cellRevealMode = SWCellRevealModeNormal;
        cell.nota = notas;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
}

#pragma mark - SWRevealTableViewCell delegate

- (void)revealTableViewCell:(SWRevealTableViewCell *)revealTableViewCell willMoveToPosition:(SWCellRevealPosition)position
{
    if ( position == SWCellRevealPositionCenter )
        return;
    
    for ( SWRevealTableViewCell *cell in [self.TableView visibleCells] )
    {
        if ( cell == revealTableViewCell )
            continue;
        
        [cell setRevealPosition:SWCellRevealPositionCenter animated:YES];
    }
}

- (void)revealTableViewCell:(SWRevealTableViewCell *)revealTableViewCell didMoveToPosition:(SWCellRevealPosition)position
{
}

- (NSArray*)rightButtonItemsInRevealTableViewCell:(SWRevealTableViewCell *)revealTableViewCell{
    
    SWCellButtonItem *item1 = [SWCellButtonItem itemWithTitle:@"" handler:^(SWCellButtonItem *item, SWRevealTableViewCell *cell)
                               {
                                   //Borrar
                                   _revealingCellIndexPath = [self.TableView indexPathForCell:cell];
                                   DoMeTable *nota = [(ListaCell *)cell nota];
                                   selectednota = nota;
                                   [self presentDeleteActionSheetForItem:item];
                                   return NO;
                               }];
    
    item1.backgroundColor = [UIColor redColor];
    item1.image = [UIImage imageNamed:@"icon_deletecell"];
    item1.tintColor = [UIColor whiteColor];
    item1.width = 75;
    
    SWCellButtonItem *item2 = [SWCellButtonItem itemWithTitle:@"" handler:^(SWCellButtonItem *item, SWRevealTableViewCell *cell)
                               {
                                   //Agregar
                                   _revealingCellIndexPath = [self.TableView indexPathForCell:cell];
                                   DoMeTable *nota = [(ListaCell *)cell nota];
                                   selectednota = nota;
                                   
                                   [self presentAgregarSheetForItem:item];
                                   return NO;
                               }];
    
    item2.backgroundColor = [UIColor colorWithRed:(55/255.0) green:(149/255.0) blue:(68/255.0) alpha:1.0];
    item2.image = [UIImage imageNamed:@"add"];
    item2.tintColor = [UIColor whiteColor];
    item2.width = 68;
    
    NSLog( @"Se desplazo a la derecha");
    return @[item1,item2];
}
#pragma mark - UIActionSheet

- (void)presentDeleteActionSheetForItem:(SWCellButtonItem*)cellItem{
    
//    UIActionSheet *actSheet = [[UIActionSheet alloc] initWithTitle:@"¿Desea borrar esta nota?"
//                                                          delegate:self
//                                                 cancelButtonTitle:@"Cancelar"
//                                            destructiveButtonTitle:@"Borrar ahora"
//                                                 otherButtonTitles:nil ];
//    
//    [actSheet setTag:0];
//    [actSheet showFromCellButtonItem:cellItem animated:YES];
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    alert.backgroundViewColor = [UIColor whiteColor];
    alert.iconTintColor = [UIColor whiteColor];
    alert.customViewColor = [UIColor colorWithRed:(255/255.0) green:(49/255.0) blue:(37/255.0) alpha:1.0];
    [alert addButton:@"Eliminar Nota" actionBlock:^(void) {
        
        DoMeTableFav *buc = [DoMeTableFav find:@"favorito == %@",selectednota.descripciondefrase];
        if (buc != NULL) {
            [buc delete];
            [[CoreDataManager sharedManager] saveContext];
        }
        
        DoMeTable *nota = selectednota;
        [nota delete];
        [[CoreDataManager sharedManager] saveContext];
        
        [_arrayNotas removeObjectAtIndex:_revealingCellIndexPath.row];
        [self.TableView deleteRowsAtIndexPaths:@[_revealingCellIndexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self CargarpasaraWidget];
        [_TableView reloadData];
    }];
    [alert addButton:@"Eliminar solo del Widget" actionBlock:^(void) {
        
        DoMeTableFav *buc =[DoMeTableFav find:@"favorito == %@",selectednota.descripciondefrase];
        if (buc != NULL) {
            [buc delete];
            [[CoreDataManager sharedManager] saveContext];
        }
        [self CargarpasaraWidget];
        [_TableView reloadData];
    }];
    [alert showCustom:self image:[UIImage imageNamed:@"icon_deletecell"] color:nil title:@"¡Hey!" subTitle:@"¿Que desea Eliminar?" closeButtonTitle:@"Cerrar" duration:0.0f];
    
}

- (void)_performDeleteAction{
    
//    SCLAlertView *alert = [[SCLAlertView alloc] init];
//    alert.backgroundViewColor = [UIColor whiteColor];
//    alert.iconTintColor = [UIColor whiteColor];
//    alert.customViewColor = [UIColor colorWithRed:(255/255.0) green:(49/255.0) blue:(37/255.0) alpha:1.0];
//    [alert addButton:@"Eliminar Nota" actionBlock:^(void) {
//    
//        DoMeTable *nota = selectednota;
//        [nota delete];
//        [[CoreDataManager sharedManager] saveContext];
//    
//        DoMeTableFav *buc =[DoMeTableFav find:@"favorito == %@",selectednota.descripciondefrase];
//        if (buc != NULL) {
//            [buc delete];
//            [[CoreDataManager sharedManager] saveContext];
//        }
//    }];
//    [alert addButton:@"Eliminar solo del Widget" actionBlock:^(void) {
//        
//        DoMeTableFav *buc =[DoMeTableFav find:@"favorito == %@",selectednota.descripciondefrase];
//        if (buc != NULL) {
//            [buc delete];
//            [[CoreDataManager sharedManager] saveContext];
//        }
//    }];
//    [alert showCustom:self image:[UIImage imageNamed:@"Palomita"] color:nil title:@"¡Hey!" subTitle:@"¿Que desea Eliminar?" closeButtonTitle:@"Cerrar" duration:0.0f];
//    
//    [_arrayNotas removeObjectAtIndex:_revealingCellIndexPath.row];
//    [self.TableView deleteRowsAtIndexPaths:@[_revealingCellIndexPath] withRowAnimation:UITableViewRowAnimationFade];
//    
//  [self CargarpasaraWidget];
}

- (void)deleteRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation{
    
}

-(void)presentAgregarSheetForItem:(SWCellButtonItem*)cellItem{
    
    DoMeTableFav *buc =[DoMeTableFav find:@"favorito == %@",selectednota.descripciondefrase];
    if (buc != NULL) {
        SCLAlertView *alert = [[SCLAlertView alloc] init];
        alert.backgroundViewColor = [UIColor whiteColor];
        alert.iconTintColor = [UIColor whiteColor];
        alert.customViewColor = [UIColor colorWithRed:(255/255.0) green:(200/255.0) blue:(0/255.0) alpha:1.0];
        [alert showCustom:self image:[UIImage imageNamed:@"Exclamacion"] color:nil title:@"¡Atención!" subTitle:@"!Ya la nota esta agregada al Widget¡" closeButtonTitle:@"Cerrar" duration:0.0f];
         [_TableView reloadData];
    }else{
//        [tempo addObject:selectednota.descripciondefrase];
//         for (int i=0; i < tempo.count; i++) {
//             DoMeTableFav *notafav = [DoMeTableFav create];
//             notafav.favorito = [NSString stringWithFormat:@"%@", tempo[i]];
//             [notafav save];
//         }
        DoMeTableFav *notafav = [DoMeTableFav create];
        notafav.favorito = selectednota.descripciondefrase;
        [notafav save];
        
        SCLAlertView *alert = [[SCLAlertView alloc] init];
        alert.backgroundViewColor = [UIColor whiteColor];
        alert.iconTintColor = [UIColor whiteColor];
        alert.customViewColor = [UIColor colorWithRed:(55/255.0) green:(149/255.0) blue:(68/255.0) alpha:1.0];
        [alert showCustom:self image:[UIImage imageNamed:@"Palomita"] color:nil title:@"¡Hey!" subTitle:@"!Tu nota Fue agregada al Widget¡" closeButtonTitle:@"Cerrar" duration:0.0f];
        [_TableView reloadData];
    }
    [self CargarpasaraWidget];

}

- (void)_performAgregarAction{
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //NSLog( @"clickedButtonAtIndex: %d", buttonIndex );
    
    if ( buttonIndex == [actionSheet cancelButtonIndex] )
    {
        NSLog( @"Cancel");
    }
    else
    {
        // NSInteger index = buttonIndex - actionSheet.firstOtherButtonIndex;
        
        switch ( actionSheet.tag )
        {
            case 0:
                [self _performDeleteAction];
                break;
            case 1:
                [self _performAgregarAction];
                break;
                
            default:
                break;
        }
    }
    SWRevealTableViewCell *cell = (id)[self.TableView cellForRowAtIndexPath:_revealingCellIndexPath];
    [cell setRevealPosition:SWCellRevealPositionCenter animated:YES];
}
- (IBAction)Atras:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma Search Methods

-(void)filtercontenForSeachTex:(NSString *)seachText scoper:(NSString *)scope
{
    self.searchResultd = [self.arrayNotas filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"descripciondefrase contains[c] %@", seachText]];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self filtercontenForSeachTex:searchText scoper:NULL];
    [self.TableView reloadData];
}
-(void)CargarpasaraWidget{
    NSMutableArray *temp2 = [[DoMeTableFav all] mutableCopy];
    NSMutableArray *temp3 = [[NSMutableArray alloc]init];
    DoMeTableFav *nota;
    for (int i=0; i < temp2.count; i++) {
        nota  = (DoMeTableFav*)temp2[i];
        [temp3 addObject:nota.favorito];
    }
    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.Joonik.Leo.group"];
    [sharedDefaults setObject:temp3 forKey: @"fraseKey"];
}

@end
