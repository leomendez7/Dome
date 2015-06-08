//
//  ViewController.m
//  DoMe
//
//  Created by Leonardo Mendez on 12/05/15.
//  Copyright (c) 2015 Joonik. All rights reserved.
//

#import "ViewController.h"
#import "ObjectiveRecord.h"
#import "DoMeTable.h"
#import "SWRevealTableViewCell.h"
#import "SCLAlertView.h"
#import "VariablesCell.h"
#import "SZTextView.h"

@interface ViewController ()

//@property (strong, nonatomic) IBOutlet UITableView *TableView;
@property (strong, nonatomic) IBOutlet UIPickerView *PickerView;
@end

@implementation ViewController

- (void)viewDidLoad {
   
   
    
    [super viewDidLoad];


}
-(void)viewWillAppear:(BOOL)animated{
    
    _frasedetexto.layer.cornerRadius  = 6;
    _frasedetexto.layer.borderColor   = [UIColor grayColor].CGColor;
    _frasedetexto.layer.borderWidth   = 1;
    _frasedetexto.text = @"";
    
//    _botonLista.layer.cornerRadius = 6;
//    _botonLista.layer.borderColor  = [UIColor blackColor].CGColor;
//    _botonLista.layer.borderWidth  = 1;
//    
//    _botonAgregar.layer.cornerRadius = 6;
//    _botonAgregar.layer.borderColor  = [UIColor blackColor].CGColor;
//    _botonAgregar.layer.borderWidth  = 1;
    
    [super viewWillAppear:animated];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                       initWithTarget:self
                                       action:@selector(dismissKeyboard)];
        [self.view addGestureRecognizer:tap];
   
    _ArrayVari = [[NSMutableArray alloc]init];
    
    [self cargararray];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)Lista:(id)sender {
    [self performSegueWithIdentifier:@"Lista" sender:nil];
}

- (IBAction)Agregar:(id)sender {
    [self dismissKeyboard];
    
    if ([_frasedetexto.text isEqualToString:@""]) {
        SCLAlertView *alert = [[SCLAlertView alloc] init];
        alert.backgroundViewColor = [UIColor whiteColor];
        alert.iconTintColor = [UIColor whiteColor];
        alert.customViewColor = [UIColor colorWithRed:(255/255.0) green:(49/255.0) blue:(37/255.0) alpha:1.0];
        [alert showCustom:self image:[UIImage imageNamed:@"error"] color:nil title:@"¡Error!" subTitle:@"!No hay nota escrita por favor agregar un texto en el campo para guardar su nota¡" closeButtonTitle:@"Cerrar" duration:0.0f];
    }else{
        DoMeTable *buc =[DoMeTable find:@"descripciondefrase == %@",_frasedetexto.text];
        if (buc != NULL) {
            SCLAlertView *alert = [[SCLAlertView alloc] init];
            alert.backgroundViewColor = [UIColor whiteColor];
            alert.iconTintColor = [UIColor whiteColor];
            alert.customViewColor = [UIColor colorWithRed:(255/255.0) green:(200/255.0) blue:(0/255.0) alpha:1.0];
            [alert addButton:@"Si" actionBlock:^(void) {
                    DoMeTable *nota = [DoMeTable create];
                    nota.descripciondefrase = _frasedetexto.text;
                    [nota save];
                        SCLAlertView *alert = [[SCLAlertView alloc] init];
                        alert.backgroundViewColor = [UIColor whiteColor];
                        alert.iconTintColor = [UIColor whiteColor];
                        alert.customViewColor = [UIColor colorWithRed:(55/255.0) green:(149/255.0) blue:(68/255.0) alpha:1.0];
                        [alert showCustom:self image:[UIImage imageNamed:@"Palomita"] color:nil title:@"¡Hey!" subTitle:@"!Tu nota Fue guardada¡" closeButtonTitle:@"Cerrar" duration:0.0f];
            }];
            [alert showCustom:self image:[UIImage imageNamed:@"Exclamacion"] color:nil title:@"¡Atención!" subTitle:@"!Ya la nota esta agregada a la lista, ¿Desea agregarla como una nueva?¡" closeButtonTitle:@"No" duration:0.0f];
        }else{
            DoMeTable *nota = [DoMeTable create];
            nota.descripciondefrase = _frasedetexto.text;
            [nota save];
            SCLAlertView *alert = [[SCLAlertView alloc] init];
            alert.backgroundViewColor = [UIColor whiteColor];
            alert.iconTintColor = [UIColor whiteColor];
            alert.customViewColor = [UIColor colorWithRed:(55/255.0) green:(149/255.0) blue:(68/255.0) alpha:1.0];
            [alert showCustom:self image:[UIImage imageNamed:@"Palomita"] color:nil title:@"¡Hey!" subTitle:@"!Tu nota Fue guardada¡" closeButtonTitle:@"Cerrar" duration:0.0f];
        }
    }
}
-(void)cargararray{
    _ArrayVari = [NSMutableArray arrayWithObjects: @"dd/mm/aaaa", @"hh:mi", @"Temperatura", nil];
}

-(void)dismissKeyboard {
    [_frasedetexto resignFirstResponder];
}

#pragma PickerView

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [_ArrayVari count];
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    return _ArrayVari[row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSString *tem;
    
    tem = _ArrayVari[row];
    _frasedetexto.text = [NSString stringWithFormat:@"%@ %@", _frasedetexto.text, tem];
}

#pragma TableView
//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//
//    return [_ArrayVari count];
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    VariablesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
//    cell.LabelVariable.text = [_ArrayVari objectAtIndex:indexPath.row];
//
//    return cell;
//}
//
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSString *tem;
//    tem = [_ArrayVari objectAtIndex:indexPath.row];
//    _frasedetexto.text = [NSString stringWithFormat:@"%@ %@", _frasedetexto.text, tem];
//    NSString *copy = tem;
//    UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
//    [pasteBoard setString:copy];
//}

@end
