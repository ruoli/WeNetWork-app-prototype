//
//  ProfileDetailsViewController.h
//  WeNetwork
//
//  Created by zhour on 12/03/2014.
//  Copyright (c) 2014 Deszie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelfProfileDetailsViewController : UIViewController



@property (strong,nonatomic)NSString * email;
@property (strong,nonatomic)NSString * firstName;
@property (strong,nonatomic)NSString * lastName;
@property (strong,nonatomic)NSString * industry;
@property (strong,nonatomic)NSString * summary;

@property (strong,nonatomic)NSArray * companyList;
@property (strong,nonatomic)NSArray * educationList;
@property (strong,nonatomic)NSArray * skillList;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end
