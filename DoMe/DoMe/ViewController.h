//
//  ViewController.h
//  DoMe
//
//  Created by Leonardo Mendez on 12/05/15.
//  Copyright (c) 2015 Joonik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) IBOutlet UITextView *frasedetexto;
@property (strong, nonatomic) IBOutlet UIButton *botonLista;
@property (strong, nonatomic) IBOutlet UIButton *botonAgregar;
- (IBAction)Lista:(id)sender;
- (IBAction)Agregar:(id)sender;
@property (strong, nonatomic)NSMutableArray *ArrayVari;

@end

