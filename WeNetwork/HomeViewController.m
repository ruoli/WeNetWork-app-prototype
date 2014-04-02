//
//  SecondViewController.m
//  WeNetwork
//
//  Created by Ruoli Zhou on 05/03/2014.
//  Copyright (c) 2014 Deszie. All rights reserved.
//

#import "HomeViewController.h"
#define LATEST_COMPANY_NAME ((int) 0)

@interface HomeViewController ()
@property(strong, nonatomic)NSString * idKey;
@property(assign, nonatomic)NSInteger profilePictureIndexNo;
@end

@implementation HomeViewController

@synthesize menuBtn,chatBtn,peopleImageView,serviceConnector,dataListForHomeView,prefs;
@synthesize firstNameLabel,lastNameLabel,industryLabel,companyLabel,positionLabel;
@synthesize idKey,profilePictureIndexNo;

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
    //init instance vars
    prefs = [NSUserDefaults standardUserDefaults];
    dataListForHomeView = [[NSArray alloc] init];
    profilePictureIndexNo = arc4random_uniform([dataListForHomeView count]);
    
    //service delegation for receiving data from DB
    serviceConnector = [[ServiceConnector alloc] init];
    serviceConnector.delegate = self;
    [serviceConnector retrieveDataFromDB];
    
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
    
    
}

#pragma delegate call service connector
-(void)requestReturnedData:(NSData *)data
{
    NSError *error;
    dataListForHomeView = [[NSArray alloc] initWithArray:[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error]];
    NSLog(@"%@", dataListForHomeView);
    
    [self setupProfilePictureImage];
    [self setupHomeViewUIDetails];
    [self setupGesturesForProfileImage];
    
}

-(void)setupHomeViewUIDetails
{
    for (int i = 0; i < [dataListForHomeView count]; i++) {
        if (idKey == [[dataListForHomeView objectAtIndex:i] objectForKey:@"id"]) {
            NSArray * tempCompanyList = [[[dataListForHomeView objectAtIndex:i] objectForKey:@"company"] componentsSeparatedByString:@","];
            NSArray * tempTitleList = [[[dataListForHomeView objectAtIndex:i] objectForKey:@"position"] componentsSeparatedByString:@","];
            
            firstNameLabel.text = [[dataListForHomeView objectAtIndex:i] objectForKey:@"first_name"];
            lastNameLabel.text = [[dataListForHomeView objectAtIndex:i] objectForKey:@"last_name"];
            industryLabel.text = [[dataListForHomeView objectAtIndex:i] objectForKey:@"industry"];
            positionLabel.text = [tempTitleList objectAtIndex:LATEST_COMPANY_NAME];
            companyLabel.text = [tempCompanyList objectAtIndex:LATEST_COMPANY_NAME];
        }
    }
    
}


- (void)setupProfilePictureImage
{
    [self.peopleImageView setImageWithURL:[NSURL URLWithString:[[dataListForHomeView objectAtIndex:profilePictureIndexNo] objectForKey:@"picture_url"]]
                         placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    idKey = [[dataListForHomeView objectAtIndex:profilePictureIndexNo] objectForKey:@"id"];
    
}

-(void)setupGesturesForProfileImage
{
    [peopleImageView setUserInteractionEnabled:YES];
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    
    [peopleImageView addGestureRecognizer:swipeLeft];
    [peopleImageView addGestureRecognizer:swipeRight];
}

- (void)handleSwipe:(UISwipeGestureRecognizer *)swipe{
    if (swipe.direction==UISwipeGestureRecognizerDirectionLeft) {
        profilePictureIndexNo--;
        if(profilePictureIndexNo <0){
            profilePictureIndexNo = [dataListForHomeView count] -1;
            [self setNewUserProfileAfterSwipe];
        }
        else{
            [self setNewUserProfileAfterSwipe];
        }
    }
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
        profilePictureIndexNo++;
        if(profilePictureIndexNo >= [dataListForHomeView count]){
            profilePictureIndexNo = 0;
            [self setNewUserProfileAfterSwipe];
        }
        else{
            [self setNewUserProfileAfterSwipe];
        }
    }
}

-(void)setNewUserProfileAfterSwipe
{
    idKey = [[dataListForHomeView objectAtIndex:profilePictureIndexNo] objectForKey:@"id"];
    [self setupProfilePictureImage];
    [self setupHomeViewUIDetails];
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




-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    SelfProfileDetailsViewController * pdv = [segue destinationViewController];
    
    for (int i = 0; i < [dataListForHomeView count]; i++) {
        if (idKey == [[dataListForHomeView objectAtIndex:i] objectForKey:@"id"]) {
            
            pdv.publicCompanyList = [[[dataListForHomeView objectAtIndex:i] objectForKey:@"company"] convertToArray];
            pdv.publicPositionTitleList = [[[dataListForHomeView objectAtIndex:i] objectForKey:@"position"] convertToArray];
            pdv.publicSkillList = [[[dataListForHomeView objectAtIndex:i] objectForKey:@"skills"] convertToArray];
            pdv.industry = [[dataListForHomeView objectAtIndex:i] objectForKey:@"industry"];
            pdv.summary = [[dataListForHomeView objectAtIndex:i] objectForKey:@"summary"];
        }
    }
    
}
@end
