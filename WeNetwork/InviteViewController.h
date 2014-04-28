//
//  InviteViewController.h
//  WeNetwork
//
//  Created by Ruoli Zhou on 05/03/2014.
//  Copyright (c) 2014 Deszie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECSlidingViewController.h"
#import "MenuViewController.h"
#import "ChatSliderViewController.h"
#import "ServiceConnector.h"
@interface InviteViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate,ServiceConnectorDelegate>

@property (strong,nonatomic)UIButton *menuBtn;
@property (strong,nonatomic)UIButton *chatBtn;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
