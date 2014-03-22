//
//  SecondViewController.m
//  WeNetwork
//
//  Created by Ruoli Zhou on 05/03/2014.
//  Copyright (c) 2014 Deszie. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

@synthesize menuBtn,chatBtn,peopleImageView,serviceConnector,dataListForHomeView;
@synthesize firstNameLabel,lastNameLabel,industryLabel,companyLabel,positionLabel;

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
    dataListForHomeView = [[NSArray alloc] init];
    
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
    
    //Image in action
    UIImage *image = [UIImage imageNamed:@"squirl.png"];
    [self.peopleImageView setImage:image];
    [peopleImageView setUserInteractionEnabled:YES];
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    
    [peopleImageView addGestureRecognizer:swipeLeft];
    [peopleImageView addGestureRecognizer:swipeRight];
    
    
    //test data received or not
    serviceConnector = [[ServiceConnector alloc] init];
    serviceConnector.delegate = self;
    [serviceConnector retrieveDataFromDB];
}

- (void)handleSwipe:(UISwipeGestureRecognizer *)swipe{
    if (swipe.direction==UISwipeGestureRecognizerDirectionLeft) {
        UIImage *image = [UIImage imageNamed:@"amazonUFO.png"];
        [peopleImageView setImage:image];
    }
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
        UIImage *image = [UIImage imageNamed:@"squirl.png"];
        [peopleImageView setImage:image];
    }
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

- (IBAction)testprefs:(id)sender {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSLog(@"new win: %@", [prefs objectForKey:@"name"]);
}

-(void)requestReturnedData:(NSData *)data
{
    
    NSError *error;
    dataListForHomeView = [[NSArray alloc] initWithArray:[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error]];
    NSLog(@"%@", dataListForHomeView);
    firstNameLabel.text = [[dataListForHomeView objectAtIndex:0] objectForKey:@"first_name"];
    lastNameLabel.text = [[dataListForHomeView objectAtIndex:0] objectForKey:@"last_name"];
    industryLabel.text = [[dataListForHomeView objectAtIndex:0] objectForKey:@"industry"];
    positionLabel.text = [[dataListForHomeView objectAtIndex:0] objectForKey:@"position"];
    companyLabel.text = [[dataListForHomeView objectAtIndex:0] objectForKey:@"company"];
}

@end
