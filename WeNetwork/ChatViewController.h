//
//  ChatViewController.h
//  WeNetwork
//
//  Created by Ruoli Zhou on 06/03/2014.
//  Copyright (c) 2014 Deszie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceConnector.h"
#import "SelfProfileDetailsViewController.h"
#import "NSString+ConvertToArray.h"
#import "ChattingFlow.h"

@interface ChatViewController : UIViewController <ServiceConnectorDelegate, UITextFieldDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property(strong,nonatomic)NSString *passedOverEmailID;
@property(strong,nonatomic)NSString *firstName;
@property(strong,nonatomic)NSString *lastName;
@property (strong, nonatomic) IBOutlet UINavigationBar *navigationBar;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *showPplBtn;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *blockBtn;
@property (weak, nonatomic) IBOutlet UITextView *chatWin;

@property (weak, nonatomic) IBOutlet UITextField *msgField;


- (IBAction)back:(id)sender;

@end
