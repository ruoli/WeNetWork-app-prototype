//
//  AppHomeViewController.m
//  WeNetwork
//
//  Created by zhour on 07/03/2014.
//  Copyright (c) 2014 Deszie. All rights reserved.
//

#import "AppHomeViewController.h"

@interface AppHomeViewController ()

@property(strong,nonatomic)NSUserDefaults *prefs;
@end

@implementation AppHomeViewController

@synthesize prefs;

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
    self.results = [[NSDictionary alloc] init];
    prefs = [NSUserDefaults standardUserDefaults];
    self.indicator.hidden = YES;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didTapConnectWithLinkedIn:(id)sender {
    
    if ([prefs stringForKey:@"emailAddress"] != NULL) {
        [self performSegueWithIdentifier:@"loginSegue" sender:self];
        
    } else {
        [self.client getAuthorizationCode:^(NSString *code) {
            [self.client getAccessToken:code success:^(NSDictionary *accessTokenData) {
                NSString *accessToken = [accessTokenData objectForKey:@"access_token"];
                [self requestMeWithToken:accessToken];
            }                   failure:^(NSError *error) {
                NSLog(@"Quering accessToken failed %@", error);
            }];
        }                      cancel:^{
            NSLog(@"Authorization was cancelled by user");
        }                     failure:^(NSError *error) {
            NSLog(@"Authorization failed %@", error);
        }];
    }
}


- (void)requestMeWithToken:(NSString *)accessToken {
    NSString * accessJsonUrl = [NSString stringWithFormat:@"https://api.linkedin.com/v1/people/~:(first-name,last-name,picture-url,email-address,industry,positions:(title,company:(name)),skills:(skill),educations:(degree))?oauth2_access_token=%@&format=json", accessToken];
    self.indicator.hidden = NO;
    [self.indicator startAnimating];
    [self.client GET:accessJsonUrl parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *result) {
            self.results = result;
            if ([self.results count] > 4) {
                [self setUserDefaultData:self.results];
                [self performSegueWithIdentifier:@"loginSegue" sender:self];
                [self.indicator stopAnimating];
                self.indicator.hidden = YES;
            }
            NSLog(@"current user %@", self.results);
        }        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"failed to fetch current user %@", error);
    }];
    
    
}

- (LIALinkedInHttpClient *)client {
    LIALinkedInApplication *application = [LIALinkedInApplication applicationWithRedirectURL:@"http://www.google.com"
                                                                                    clientId:@"77am742yc947kh"
                                                                                clientSecret:@"oO3x5Nmvexnsme2N"
                                                                                       state:@"DCEEFWF45453sdffef424"
                                                                               grantedAccess:@[@"r_emailaddress",@"r_basicprofile",@"r_fullprofile"]];
 
    return [LIALinkedInHttpClient clientForApplication:application presentingViewController:nil];
}



-(void)setUserDefaultData:(NSDictionary *)results
{
    LinkedinDataFetcher * controller = [[LinkedinDataFetcher alloc] init];
    [controller loadDataFromLinkedinToLocalDefault:results];
    [controller setMasterListToPrefs];
}

@end


