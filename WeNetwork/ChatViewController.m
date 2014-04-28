//
//  ChatViewController.m
//  WeNetwork
//
//  Created by Ruoli Zhou on 06/03/2014.
//  Copyright (c) 2014 Deszie. All rights reserved.
//

#import "ChatViewController.h"

@interface ChatViewController ()

@end

@implementation ChatViewController

@synthesize passedOverEmailID;
@synthesize firstName;
@synthesize lastName;
@synthesize navigationBar;

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
    NSLog(@"%@ %@", firstName,lastName);
    navigationBar.topItem.title = [NSString stringWithFormat:@"Chatting with %@ %@", firstName, lastName];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
