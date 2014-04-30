//
//  ChatViewController.m
//  WeNetwork
//
//  Created by Ruoli Zhou on 06/03/2014.
//  Copyright (c) 2014 Deszie. All rights reserved.
//

#import "ChatViewController.h"
#define POST_ID_TO_WS_URL @"http://localhost:8888/retrieve_others_profile.php"
#define POST_TO_CHAT_HANDLE @"http://localhost:8888/chatting_msg.php"
#define POST_TO_BLOCK_CONTACT @"http://localhost:8888/block_contact.php"
@interface ChatViewController ()
@property (strong,nonatomic)ServiceConnector *serviceConnector;
@property (strong,nonatomic)NSArray * chattingTargetUser;
@property (strong,nonatomic)ChattingFlow * chattingFlow;
@property (strong,nonatomic)NSUserDefaults * prefs;
@property (strong,nonatomic)NSArray * chattingDetails;

@property(strong,nonatomic)NSString *target_user_email_id;
@property(strong,nonatomic)NSString *company_display;
@property(strong,nonatomic)NSString *education_display;
@property(strong,nonatomic)NSString *skill_display;
@property(strong,nonatomic)NSString *industry_display;
@property(strong,nonatomic)NSString *summary_display;
@end

@implementation ChatViewController
@synthesize msgField;
@synthesize chatWin;

@synthesize passedOverEmailID;
@synthesize firstName;
@synthesize lastName;
@synthesize chattingFlow;
@synthesize chattingDetails;

@synthesize navigationBar;
@synthesize serviceConnector;
@synthesize chattingTargetUser;
@synthesize prefs;

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
    navigationBar.topItem.title = [NSString stringWithFormat:@"Chatting with %@ %@", firstName, lastName];
    
    serviceConnector = [[ServiceConnector alloc] init];
    NSMutableDictionary *identifierID = [[NSMutableDictionary alloc] init];
    serviceConnector.delegate = self;
    [identifierID setValue:passedOverEmailID forKey:@"passedOverEmailID"];
    [serviceConnector postDataToWebService:identifierID webServiceURL:POST_ID_TO_WS_URL];
    
    prefs = [NSUserDefaults standardUserDefaults];
    chattingFlow = [[ChattingFlow alloc] init];
    [chattingFlow getChattingFolksSender:passedOverEmailID Receiver:[prefs objectForKey:@"emailAddress"] Message:NULL URL:POST_TO_CHAT_HANDLE];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)sendMsg:(id)sender {
    chatWin.text = @"";
    [chattingFlow getChattingFolksSender:[prefs objectForKey:@"emailAddress"] Receiver:passedOverEmailID Message:msgField.text URL:POST_TO_CHAT_HANDLE];
    chattingDetails = [chattingFlow getChatMessage];
    if (chattingDetails != NULL) {
        for (int i =0; i < [chattingDetails count]; i++) {
            if ([[[chattingDetails objectAtIndex:i] objectForKey:@"sender"] isEqualToString:[prefs objectForKey:@"emailAddress"]] ) {
                NSString * temp = [chatWin.text stringByAppendingString:[NSString stringWithFormat:@"Me:\n%@\n\n", [[chattingDetails objectAtIndex:i] objectForKey:@"message"]]];
                chatWin.text = temp;
            } else {
                chatWin.text = [chatWin.text stringByAppendingString:[NSString stringWithFormat:@"%@ %@:\n%@\n\n", firstName, lastName, [[chattingDetails objectAtIndex:i] objectForKey:@"message"]]];
            }
        }
        if (![msgField.text isEqual:NULL] || ![msgField isEqual:@""]) {
            chatWin.text = [chatWin.text stringByAppendingString:[NSString stringWithFormat:@"Me:\n%@\n\n", msgField.text]];
        }
        
        [chatWin scrollRangeToVisible:NSMakeRange([chatWin.text length], 0)];
        
    }
   
    if ([msgField isFirstResponder]) {
        [msgField resignFirstResponder];
    }
}

- (IBAction)blockContact:(id)sender {
    [chattingFlow getChattingFolksSender:[prefs objectForKey:@"emailAddress"] Receiver:passedOverEmailID Message:@"DEl" URL:POST_TO_BLOCK_CONTACT];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                    message:@"This person will be removed from your contact, are you sure?"
                                                   delegate:self
                                          cancelButtonTitle:@"Later"
                                          otherButtonTitles:@"OK", nil];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != [alertView cancelButtonIndex]) {
        [chattingFlow getChattingFolksSender:[prefs objectForKey:@"emailAddress"] Receiver:passedOverEmailID Message:@"DEl" URL:POST_TO_BLOCK_CONTACT];
        [self back:self];
    }
}


#pragma delegate call
-(void)requestReturnedData:(NSData *)data
{
    NSError *error;
    chattingTargetUser = [[NSArray alloc] initWithArray:[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error]];
    [self setDataReadyForSegue];
}

-(void)setDataReadyForSegue
{
    target_user_email_id = [[chattingTargetUser objectAtIndex:0] objectForKey:@"id"];
    company_display = [[chattingTargetUser objectAtIndex:0] objectForKey:@"company_display"];
    education_display = [[chattingTargetUser objectAtIndex:0] objectForKey:@"education_display"];
    skill_display = [[chattingTargetUser objectAtIndex:0] objectForKey:@"skill_display"];
    industry_display = [[chattingTargetUser objectAtIndex:0] objectForKey:@"industry_display"];
    summary_display = [[chattingTargetUser objectAtIndex:0] objectForKey:@"summary_display"];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    SelfProfileDetailsViewController * pdv = [segue destinationViewController];
    
    for (int i = 0; i < [chattingTargetUser count]; i++) {
        if ([company_display  isEqual: @"Y"]) {
            pdv.publicCompanyList = [[[chattingTargetUser objectAtIndex:i] objectForKey:@"company"] convertToArray];
            pdv.publicPositionTitleList = [[[chattingTargetUser objectAtIndex:i] objectForKey:@"position"] convertToArray];
        }
        
        if ([skill_display isEqual:@"Y"]) {
            pdv.publicSkillList = [[[chattingTargetUser objectAtIndex:i] objectForKey:@"skills"] convertToArray];
        }
        
        if ([industry_display isEqual:@"Y"]) {
            pdv.industry = [[chattingTargetUser objectAtIndex:i] objectForKey:@"industry"];
        }
        
        if ([summary_display isEqual:@"Y"]) {
            pdv.summary = [[chattingTargetUser objectAtIndex:i] objectForKey:@"summary"];
        }
        
        if ([education_display isEqual:@"Y"]) {
            pdv.publicSchoolNames = [[[chattingTargetUser objectAtIndex:i] objectForKey:@"school_name"] convertToArray];
            pdv.publicFieldOfStudy = [[[chattingTargetUser objectAtIndex:i] objectForKey:@"field_of_study"] convertToArray];
        }
            
        
    }
}

//textField delegate methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([msgField isFirstResponder]) {
        
        [self sendMsg:self];
        [msgField resignFirstResponder];
    } 
    
    return YES;
}

//Make sure keyboard will not cover the textfields

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField: textField up: YES];
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField: textField up: NO];
}

- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    const int movementDistance = 180;
    
    const float movementDuration = 0.3f;
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}



@end
