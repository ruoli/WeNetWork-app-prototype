//
//  ProfileDetailsViewController.m
//  WeNetwork
//
//  Created by zhour on 12/03/2014.
//  Copyright (c) 2014 Deszie. All rights reserved.
//

#import "SelfProfileDetailsViewController.h"

@interface SelfProfileDetailsViewController ()

@end

@implementation SelfProfileDetailsViewController
@synthesize industry,summary,textView,companyList,educationList,skillList,publicCompanyList,publicPositionTitleList,publicEducationList,publicSkillList;

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
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    if (industry != NULL) {
        textView.text = [textView.text stringByAppendingString:[NSString stringWithFormat:@"Industry:\n%@\n\n\n",industry]];
    }
    if (companyList != NULL) {
        textView.text = [textView.text stringByAppendingString:@"Career History:\n"];
        for (int i=0; i<[companyList count]; i++) {
            NSString *companyName = [[[companyList objectAtIndex:i] objectForKey:@"company"] objectForKey:@"name"];
            NSString *jobTitle = [[companyList objectAtIndex:i] objectForKey:@"title"];
            
            textView.text = [textView.text stringByAppendingString:[NSString stringWithFormat:@"%d.\nCompany:  %@\nJob Title:    %@\n",i+1, companyName, jobTitle]];
        }
        textView.text = [textView.text stringByAppendingString:@"\n\n"];
    }
    if (publicPositionTitleList != NULL && publicCompanyList != NULL) {
        for (int i = 0; i < [publicCompanyList count]; i++) {
            textView.text = [textView.text stringByAppendingString:[NSString stringWithFormat:@"%d.\nCompany:  %@\nJob Title:    %@\n",i+1, [publicCompanyList objectAtIndex:i], [publicPositionTitleList objectAtIndex:i]]];
        }
        textView.text = [textView.text stringByAppendingString:@"\n\n"];
    }
    if (educationList != NULL) {
        textView.text = [textView.text stringByAppendingString:@"Education History:\n"];
        for (int i=0; i<[educationList count]; i++) {
            NSString *schoolName = [[educationList objectAtIndex:i] objectForKey:@"schoolName"];
            NSString *fieldOfStudy = [[educationList objectAtIndex:i] objectForKey:@"fieldOfStudy"];
            
            textView.text = [textView.text stringByAppendingString:[NSString stringWithFormat:@"%d.\nSchool Name:  %@\nField Of Study: %@\n",i+1, schoolName, fieldOfStudy]];
        }
        textView.text = [textView.text stringByAppendingString:@"\n\n"];
    }
    if (skillList != NULL) {
        textView.text = [textView.text stringByAppendingString:@"Skills:\n"];
        for (int i = 0; i<[skillList count]; i++) {
            NSString *skillName = [[[skillList objectAtIndex:i] objectForKey:@"skill"] objectForKey:@"name"];
            textView.text = [textView.text stringByAppendingString:[NSString stringWithFormat:@"%@   ",skillName]];
        }
        textView.text = [textView.text stringByAppendingString:@"\n\n\n"];
    }
    if (publicSkillList != NULL) {
        for (int i = 0; i<[publicSkillList count]; i++) {
            textView.text = [textView.text stringByAppendingString:[NSString stringWithFormat:@"%@   ", [publicSkillList objectAtIndex:i]]];
        }
        textView.text = [textView.text stringByAppendingString:@"\n\n\n"];
    }
    if (summary != NULL) {
        textView.text = [textView.text stringByAppendingString:[NSString stringWithFormat:@"SUMMARY:\n%@", summary]];
    }
    
    
    NSLog(@"company: %@", [[[[prefs objectForKey:@"masterList"] objectAtIndex:1] objectAtIndex:0] objectForKey:@"title"]);
    NSLog(@"skill: %@", [[[prefs objectForKey:@"masterList"]  objectAtIndex:2] objectAtIndex:0]);
    
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
