//
//  ProfileDetailsViewController.h
//  WeNetwork
//
//  Created by zhour on 12/03/2014.
//  Copyright (c) 2014 Deszie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileDetailsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *emailText;
@property (weak, nonatomic) IBOutlet UILabel *firstNameText;
@property (weak, nonatomic) IBOutlet UILabel *lastNameText;
@property (weak, nonatomic) IBOutlet UILabel *industryText;
@property (weak, nonatomic) IBOutlet UILabel *summaryText;

@property (strong,nonatomic)NSString * email;
@property (strong,nonatomic)NSString * firstName;
@property (strong,nonatomic)NSString * lastName;
@property (strong,nonatomic)NSString * industry;
@property (strong,nonatomic)NSString * summary;

@end
