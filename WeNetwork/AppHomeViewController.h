//
//  AppHomeViewController.h
//  WeNetwork
//
//  Created by zhour on 07/03/2014.
//  Copyright (c) 2014 Deszie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFHTTPRequestOperation.h"
#import "LIALinkedInHttpClient.h"
#import "LIALinkedInApplication.h"
#import "InitViewController.h"
#import "LinkedinDataFetcher.h"

@interface AppHomeViewController : UIViewController
@property (strong,nonatomic) NSDictionary *results;
@end
