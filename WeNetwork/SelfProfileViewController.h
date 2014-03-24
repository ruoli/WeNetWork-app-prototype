//
//  MainViewController.h
//  WeNetwork
//
//  Created by Ruoli Zhou on 05/03/2014.
//  Copyright (c) 2014 Deszie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECSlidingViewController.h"
#import "MenuViewController.h"
#import "ChatSliderViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "SelfProfileDetailsViewController.h"
#import "ServiceConnector.h"
@interface SelfProfileViewController : UIViewController

@property (strong,nonatomic)NSUserDefaults *prefs;
@property (strong,nonatomic)UIButton *menuBtn;
@property (strong,nonatomic)UIButton *chatBtn;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;


@property (weak, nonatomic) IBOutlet UISwitch *companyHistoryDisplaySwitcher;
@property (weak, nonatomic) IBOutlet UISwitch *educationHistoryDisplaySwitcher;
@property (weak, nonatomic) IBOutlet UISwitch *skillsDisplaySwitcher;
@property (weak, nonatomic) IBOutlet UISwitch *industryDisplaySwitcher;
@property (weak, nonatomic) IBOutlet UISwitch *summaryDisplaySwitcher;


@end
