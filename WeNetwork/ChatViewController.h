//
//  ChatViewController.h
//  WeNetwork
//
//  Created by Ruoli Zhou on 06/03/2014.
//  Copyright (c) 2014 Deszie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property(strong,nonatomic)NSString *passedOverEmailID;
@property(strong,nonatomic)NSString *firstName;
@property(strong,nonatomic)NSString *lastName;
@property (strong, nonatomic) IBOutlet UINavigationBar *navigationBar;

- (IBAction)back:(id)sender;

@end
