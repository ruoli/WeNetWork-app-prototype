//
//  SecondViewController.m
//  WeNetwork
//
//  Created by Ruoli Zhou on 05/03/2014.
//  Copyright (c) 2014 Deszie. All rights reserved.
//

#import "HomeViewController.h"
#define LATEST_COMPANY_NAME ((int) 0)
#define POST_ID_TO_WS_URL @"http://localhost:8888/retrieve_others_profile.php"
#define POST_REQUEST_ADD_CONNECTION @"http://localhost:8888/connection_profile.php"

@interface HomeViewController ()
@property(strong, nonatomic)NSString * idKey;
@property(assign, nonatomic)NSInteger profilePictureIndexNo;

@property(strong,nonatomic)NSString *target_user_email_id;
@property(strong,nonatomic)NSString *company_display;
@property(strong,nonatomic)NSString *education_display;
@property(strong,nonatomic)NSString *skill_display;
@property(strong,nonatomic)NSString *industry_display;
@property(strong,nonatomic)NSString *summary_display;
@end

@implementation HomeViewController

@synthesize menuBtn;
@synthesize chatBtn;
@synthesize peopleImageView;
@synthesize serviceConnector;
@synthesize dataListForHomeView;
@synthesize prefs;
@synthesize firstNameLabel;
@synthesize lastNameLabel;
@synthesize industryLabel;
@synthesize companyLabel;
@synthesize positionLabel;
@synthesize idKey;
@synthesize profilePictureIndexNo;

@synthesize target_user_email_id;
@synthesize company_display;
@synthesize education_display;
@synthesize skill_display;
@synthesize industry_display;
@synthesize summary_display;

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
    
    NSMutableDictionary *identifierID = [[NSMutableDictionary alloc] init];
    serviceConnector.delegate = self;
    [identifierID setValue:[prefs objectForKey:@"emailAddress"] forKey:@"id"];
    [serviceConnector postDataToWebService:identifierID webServiceURL:POST_ID_TO_WS_URL];
    
    [self setupSlidingView];
}


-(void)setupSlidingView
{
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
            
            //display on the UI
            firstNameLabel.text = [[dataListForHomeView objectAtIndex:i] objectForKey:@"first_name"];
            lastNameLabel.text = [[dataListForHomeView objectAtIndex:i] objectForKey:@"last_name"];
            industryLabel.text = [[dataListForHomeView objectAtIndex:i] objectForKey:@"industry"];
            positionLabel.text = [tempTitleList objectAtIndex:LATEST_COMPANY_NAME];
            companyLabel.text = [tempCompanyList objectAtIndex:LATEST_COMPANY_NAME];
            
            //control what to display
            target_user_email_id = [[dataListForHomeView objectAtIndex:i] objectForKey:@"id"];
            company_display = [[dataListForHomeView objectAtIndex:i] objectForKey:@"company_display"];
            education_display = [[dataListForHomeView objectAtIndex:i] objectForKey:@"education_display"];
            skill_display = [[dataListForHomeView objectAtIndex:i] objectForKey:@"skill_display"];
            industry_display = [[dataListForHomeView objectAtIndex:i] objectForKey:@"industry_display"];
            summary_display = [[dataListForHomeView objectAtIndex:i] objectForKey:@"summary_display"];
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
        [self actionForNotInterestedInCurrentPerson];
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


-(void)actionForNotInterestedInCurrentPerson
{
    profilePictureIndexNo--;
    if(profilePictureIndexNo <0){
        profilePictureIndexNo = [dataListForHomeView count] -1;
        [self setNewUserProfileAfterSwipe];
    }
    else{
        [self setNewUserProfileAfterSwipe];
    }
}

- (IBAction)passTheUser:(id)sender {
    [self actionForNotInterestedInCurrentPerson];
}


- (IBAction)requestAddToContact:(id)sender {
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue:[prefs objectForKey:@"emailAddress"] forKeyPath:@"connection_requestor"];
    [dictionary setValue:target_user_email_id forKeyPath:@"connection_target"];
    [dictionary setValue:@"Y" forKeyPath:@"request"];
    PostRequestAdaptor * adaptor = [[PostRequestAdaptor alloc] init];
    [adaptor postContactRequest:dictionary :POST_REQUEST_ADD_CONNECTION];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Add to contact" message:@"Request sent!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
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
            if ([company_display  isEqual: @"Y"]) {
                pdv.publicCompanyList = [[[dataListForHomeView objectAtIndex:i] objectForKey:@"company"] convertToArray];
                pdv.publicPositionTitleList = [[[dataListForHomeView objectAtIndex:i] objectForKey:@"position"] convertToArray];
            }
            
            if ([skill_display isEqual:@"Y"]) {
                pdv.publicSkillList = [[[dataListForHomeView objectAtIndex:i] objectForKey:@"skills"] convertToArray];
            }
            
            if ([industry_display isEqual:@"Y"]) {
                pdv.industry = [[dataListForHomeView objectAtIndex:i] objectForKey:@"industry"];
            }
           
            if ([summary_display isEqual:@"Y"]) {
                pdv.summary = [[dataListForHomeView objectAtIndex:i] objectForKey:@"summary"];
            }
            
            if ([education_display isEqual:@"Y"]) {
                pdv.publicSchoolNames = [[[dataListForHomeView objectAtIndex:i] objectForKey:@"school_name"] convertToArray];
                pdv.publicFieldOfStudy = [[[dataListForHomeView objectAtIndex:i] objectForKey:@"field_of_study"] convertToArray];
            }
            
        }
    }
}
@end
