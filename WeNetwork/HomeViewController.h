//
//  SecondViewController.h
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
#import "JSONDictionaryExtensions.h"
#import "PeopleProfileViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface HomeViewController : UIViewController <ServiceConnectorDelegate>
@property (strong,nonatomic)UIButton *menuBtn;
@property (strong,nonatomic)UIButton *chatBtn;
@property (weak, nonatomic) IBOutlet UIImageView *peopleImageView;
- (IBAction)getOtherUserProfile:(id)sender;


@property (strong,nonatomic)ServiceConnector *serviceConnector;
@property (strong,nonatomic)NSArray *dataListForHomeView;
@property (strong,nonatomic)NSUserDefaults *prefs;


@property (strong, nonatomic) IBOutlet UILabel *firstNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *lastNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *industryLabel;
@property (strong, nonatomic) IBOutlet UILabel *companyLabel;
@property (strong, nonatomic) IBOutlet UILabel *positionLabel;

@end
