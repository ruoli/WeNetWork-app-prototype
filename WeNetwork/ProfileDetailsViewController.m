//
//  ProfileDetailsViewController.m
//  WeNetwork
//
//  Created by zhour on 12/03/2014.
//  Copyright (c) 2014 Deszie. All rights reserved.
//

#import "ProfileDetailsViewController.h"

@interface ProfileDetailsViewController ()

@end

@implementation ProfileDetailsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.email != NULL) {
        self.emailText.text = [NSString stringWithFormat:@"%@", self.email];
    }
    if (self.firstName != NULL) {
        self.firstNameText.text = [NSString stringWithFormat:@"%@", self.firstName];
    }
    if (self.lastName != NULL) {
        self.lastNameText.text = [NSString stringWithFormat:@"%@", self.lastName];
    }
    if (self.industry != NULL) {
        self.industryText.text = [NSString stringWithFormat:@"%@", self.industry];
    }
    if (self.summary != NULL) {
        self.summaryText.text = [NSString stringWithFormat:@"%@", self.summary];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)backBtn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
