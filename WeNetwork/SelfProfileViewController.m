//
//  MainViewController.m
//  WeNetwork
//
//  Created by Ruoli Zhou on 05/03/2014.
//  Copyright (c) 2014 Deszie. All rights reserved.
//

#import "SelfProfileViewController.h"

@interface SelfProfileViewController ()
@property(strong,nonatomic)ServiceConnector *serviceConnector;
@end

@implementation SelfProfileViewController

@synthesize menuBtn;
@synthesize chatBtn;
@synthesize prefs;
@synthesize serviceConnector;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    prefs = [NSUserDefaults standardUserDefaults];
    
	self.view.layer.shadowOpacity = 0.75f;
    self.view.layer.shadowRadius = 10.0f;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[MenuViewController class]]) {
        self.slidingViewController.underLeftViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    }
    
    if (![self.slidingViewController.underRightViewController isKindOfClass:[ChatSliderViewController class]]) {
        self.slidingViewController.underRightViewController = [self.storyboard
                                                               instantiateViewControllerWithIdentifier:@"Chat"];
    }
    
//    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
    
    self.menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    menuBtn.frame = CGRectMake(8, 10, 34, 24);
    [menuBtn setBackgroundImage:[UIImage imageNamed:@"reveal-icon.png"] forState:UIControlStateNormal];
    [menuBtn addTarget:self action:@selector(revealMenu:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.menuBtn];
    
    self.chatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    chatBtn.frame = CGRectMake(280, 10, 34, 24);
    [chatBtn setBackgroundImage:[UIImage imageNamed:@"reveal-icon.png" ] forState:UIControlStateNormal];
    [chatBtn addTarget:self action:@selector(revealChat:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.chatBtn];
    
    
    [self.profileImage setImageWithURL:[NSURL URLWithString:[prefs stringForKey:@"pictureUrl"]]
                   placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    //add tap gesture to profile image
    UITapGestureRecognizer *tap =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.profileImage addGestureRecognizer:tap];
}

-(void)tapAction
{
    [self performSegueWithIdentifier:@"toProfileDetails" sender:self];
}


-(IBAction)revealMenu:(id)sender
{
    [self.slidingViewController anchorTopViewTo:ECRight];
}

-(IBAction)revealChat:(id)sender
{
    [self.slidingViewController anchorTopViewTo:ECLeft];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString *companyHistoryShouldDisplay;
    NSString *educationHistoryShouldDisplay;
    NSString *skillsShouldDisplay;
    NSString *summaryShouldDisplay;
    NSString *industryShouldDisplay;
    
    NSMutableDictionary *switcherDictionary = [[NSMutableDictionary alloc] init];
    
    
    SelfProfileDetailsViewController * pdv = [segue destinationViewController];
    if (self.companyHistoryDisplaySwitcher.on) {
        pdv.companyList = [[prefs objectForKey:@"masterList"] objectAtIndex:1];
        companyHistoryShouldDisplay = @"Y";
        [switcherDictionary setValue:companyHistoryShouldDisplay forKey:@"company_display"];
    }
    else{
        companyHistoryShouldDisplay = @"N";
        [switcherDictionary setValue:companyHistoryShouldDisplay forKey:@"company_display"];
    }
    
    if (self.educationHistoryDisplaySwitcher.on) {
        pdv.educationList = [[prefs objectForKey:@"masterList"] objectAtIndex:0];
        educationHistoryShouldDisplay = @"Y";
        [switcherDictionary setValue:educationHistoryShouldDisplay forKey:@"education_display"];
    }
    else{
        educationHistoryShouldDisplay = @"N";
        [switcherDictionary setValue:educationHistoryShouldDisplay forKey:@"education_display"];
    }
    
    if (self.skillsDisplaySwitcher.on) {
        pdv.skillList = [[prefs objectForKey:@"masterList"] objectAtIndex:2];
        skillsShouldDisplay = @"Y";
        [switcherDictionary setValue:skillsShouldDisplay forKey:@"skill_display"];
    }
    else{
        skillsShouldDisplay = @"N";
        [switcherDictionary setValue:skillsShouldDisplay forKey:@"skill_display"];
    }
    
    if (self.industryDisplaySwitcher.on) {
        pdv.industry = [prefs stringForKey:@"industry"];
        industryShouldDisplay = @"Y";
        [switcherDictionary setValue:industryShouldDisplay forKey:@"industry_display"];
    }
    else{
        industryShouldDisplay = @"N";
        [switcherDictionary setValue:industryShouldDisplay forKey:@"industry_display"];
    }
    
    if (self.summaryDisplaySwitcher.on) {
        pdv.summary = [prefs stringForKey:@"summary"];
        summaryShouldDisplay = @"Y";
        [switcherDictionary setValue:summaryShouldDisplay forKey:@"summary_display"];
    }else{
        summaryShouldDisplay = @"N";
        [switcherDictionary setValue:industryShouldDisplay forKey:@"summary_display"];
    }
    
    [serviceConnector postDataControllerSigns:switcherDictionary];
}
@end