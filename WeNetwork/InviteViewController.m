//
//  InviteViewController.m
//  WeNetwork
//
//  Created by Ruoli Zhou on 05/03/2014.
//  Copyright (c) 2014 Deszie. All rights reserved.
//

#import "InviteViewController.h"
#define POST_CONNECTION_REQUEST @"http://localhost:8888/retrieve_connection_request.php"

@interface InviteViewController ()
@property(strong,nonatomic)ServiceConnector * serviceConnector;
@property(strong, nonatomic)NSMutableDictionary * targetConnector;
@property(strong, nonatomic)NSArray * requesters;
@property(strong,nonatomic)NSUserDefaults *prefs;
@property(assign,nonatomic)NSInteger indexPathForAccept;
@end

@implementation InviteViewController

@synthesize prefs;
@synthesize menuBtn;
@synthesize chatBtn;
@synthesize targetConnector;
@synthesize requesters;
@synthesize indexPathForAccept;
@synthesize serviceConnector;

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
    [self setupSlidingView];
    [self loadRequestorsData];
}

-(void)loadRequestorsData
{
    prefs = [NSUserDefaults standardUserDefaults];
    serviceConnector = [[ServiceConnector alloc] init];
    serviceConnector.delegate = self;
    targetConnector = [[NSMutableDictionary alloc] init];
    [targetConnector setValue:[prefs objectForKey:@"emailAddress"] forKey:@"id"];
    [serviceConnector postDataToWebService:targetConnector webServiceURL:POST_CONNECTION_REQUEST];

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


#pragma delegate call
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [requesters count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"inviteCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    NSString * s =[[requesters objectAtIndex:indexPath.row] objectForKey:@"connection_requestor"];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", s];

    return cell;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete){
        NSMutableDictionary * tempDic = [[NSMutableDictionary alloc] init];
        [tempDic setValue:[prefs objectForKey:@"emailAddress"] forKey:@"target_id_reject"];
        [tempDic setValue:[[requesters objectAtIndex:indexPath.row] objectForKey:@"connection_requestor"] forKey:@"requester_id_reject"];
        [serviceConnector postDataToWebService:tempDic webServiceURL:POST_CONNECTION_REQUEST];
        [self loadRequestorsData];
        [self.tableView reloadData];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                    message:@"Accept this user's connection request? Or swipe the cell to delete this user's request."
                                                   delegate:self
                                          cancelButtonTitle:@"Later"
                                          otherButtonTitles:@"OK", nil];
    [alert show];
    indexPathForAccept = indexPath.row;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != [alertView cancelButtonIndex]) {
        NSMutableDictionary * tempDic = [[NSMutableDictionary alloc] init];
        [tempDic setValue:[prefs objectForKey:@"emailAddress"] forKey:@"target_id_accepted"];
        [tempDic setValue:[[requesters objectAtIndex:indexPathForAccept] objectForKey:@"connection_requestor"] forKey:@"requester_id_accepted"];
        [serviceConnector postDataToWebService:tempDic webServiceURL:POST_CONNECTION_REQUEST];
        [self loadRequestorsData];
        [self.tableView reloadData];
    }
}


-(void)requestReturnedData:(NSData *)data
{
    NSError *error;
    requesters = [[NSArray alloc] initWithArray:[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error]];
    NSLog(@"requesters: %@", requesters);
    [self.tableView reloadData];
}

@end