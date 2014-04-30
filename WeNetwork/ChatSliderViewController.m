//
//  ChatSliderViewController.m
//  WeNetwork
//
//  Created by Ruoli Zhou on 05/03/2014.
//  Copyright (c) 2014 Deszie. All rights reserved.
//

#import "ChatSliderViewController.h"
#define POST_CONNECTED_USERS @"http://localhost:8888/retrieve_already_connected_users.php"
@interface ChatSliderViewController ()
@property (nonatomic,strong)NSArray * chatPeople;
@property(strong,nonatomic)ServiceConnector * serviceConnector;
@property(strong,nonatomic)NSUserDefaults *prefs;
@end

@implementation ChatSliderViewController
@synthesize serviceConnector;
@synthesize prefs;
@synthesize chatPeople;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    prefs = [NSUserDefaults standardUserDefaults];
    serviceConnector = [[ServiceConnector alloc] init];
    serviceConnector.delegate = self;
    NSMutableDictionary *temp = [[NSMutableDictionary alloc] init];
    [temp setValue:[prefs objectForKey:@"emailAddress"] forKey:@"id"];
    [serviceConnector postDataToWebService:temp webServiceURL:POST_CONNECTED_USERS];
    
    [self.slidingViewController setAnchorLeftPeekAmount:100.0f];
    self.slidingViewController.underLeftWidthLayout = ECFullWidth;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

-(void)requestReturnedData:(NSData *)data
{
    NSError *error;
    chatPeople = [[NSArray alloc] initWithArray:[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error]];
    NSLog(@"chat ppl %@", chatPeople);
    [self.tableView reloadData];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.chatPeople count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"chatCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    NSString *fn = [[self.chatPeople objectAtIndex:indexPath.row] objectForKey:@"first_name"];
    NSString *ln = [[self.chatPeople objectAtIndex:indexPath.row] objectForKey:@"last_name"];
    
    cell.textLabel.text =[NSString stringWithFormat:@"%@ %@", fn, ln];
    cell.textLabel.textAlignment = UITextAlignmentRight;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"pushToChatSegue" sender:self];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"prepareforsegue: %@", segue.identifier);
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    
    ChatViewController *chatvc = [segue destinationViewController];
    chatvc.firstName = [[self.chatPeople objectAtIndex:indexPath.row] objectForKey:@"first_name"];
    chatvc.lastName = [[self.chatPeople objectAtIndex:indexPath.row] objectForKey:@"last_name"];
    chatvc.passedOverEmailID = [[self.chatPeople objectAtIndex:indexPath.row] objectForKey:@"id"];
    
}


- (IBAction)backBtn:(id)sender {
}
@end