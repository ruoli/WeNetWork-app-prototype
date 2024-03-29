//
//  SettingsViewController.h
//  WeNetwork
//
//  Created by Ruoli Zhou on 05/03/2014.
//  Copyright (c) 2014 Deszie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECSlidingViewController.h"
#import "MenuViewController.h"
#import "ChatSliderViewController.h"
#import "ServiceConnector.h"
@interface SettingsViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>
@property (strong,nonatomic)UIButton *menuBtn;
@property (strong,nonatomic)UIButton *chatBtn;
@property (weak, nonatomic) IBOutlet UIPickerView *countryPicker;
@property (weak, nonatomic) IBOutlet UILabel *textField;


@property(strong,nonatomic)NSArray * listOfCountries;
@property(strong,nonatomic)NSString * numberOfCol;
@end
