//
//  SettingsViewController.m
//  WeNetwork
//
//  Created by Ruoli Zhou on 05/03/2014.
//  Copyright (c) 2014 Deszie. All rights reserved.
//

#import "SettingsViewController.h"
#define POST_REGION_AND_ID_TO_WS @"http://localhost:8888/post_basic_profile.php"


@interface SettingsViewController ()
@property(strong,nonatomic)NSString *selectedCountry;
@property(strong,nonatomic)NSMutableArray *selectedCountriesList;
@end

@implementation SettingsViewController
@synthesize menuBtn;
@synthesize chatBtn;
@synthesize textField;
@synthesize selectedCountry;
@synthesize selectedCountriesList;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    textField.text = @"";
    selectedCountriesList = [[NSMutableArray alloc] init];
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
    
    
    //init data picker
    //init picker
    self.numberOfCol = @"";
    self.countryPicker.showsSelectionIndicator = TRUE;
    self.listOfCountries = [[NSArray alloc] initWithObjects:@"China",@"UK",@"USA",@"Japan",@"Switzland",@"Danmark",nil];
    
    [super viewDidLoad];
}


-(IBAction)revealMenu:(id)sender
{
    [self.slidingViewController anchorTopViewTo:ECRight];
}

-(IBAction)revealChat:(id)sender
{
    [self.slidingViewController anchorTopViewTo:ECLeft];
}


- (IBAction)logOutBtn:(id)sender {
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    [self dismissViewControllerAnimated:YES completion:nil];
}

//return the number of rows for picker
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.listOfCountries count];
}

//display details for picker
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.listOfCountries objectAtIndex:row];
}

//return the col num for picker
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0 && [selectedCountriesList count] < 3) {
        selectedCountry = [self.listOfCountries objectAtIndex:row];
//        if (selectedCountry != NULL) {
//            [selectedCountriesList addObject:selectedCountry];
//        }
    }
    
}

- (IBAction)confirmAddCountryAction:(id)sender {
//    NSString *tempString;
//    if (selectedCountry !=NULL && ![selectedCountry isEqual: @""]) {
//        [selectedCountriesList addObject:selectedCountry];
//        for (int i = 0; i < [selectedCountriesList count]; i++) {
//            
//            tempString = [textField.text stringByAppendingString:[NSString stringWithFormat:@"%@,",[selectedCountriesList objectAtIndex:i]]];
//            textField.text = [tempString substringToIndex:[tempString length]-1];
//        }
//        [selectedCountriesList removeAllObjects];
//    }
    textField.text = selectedCountry;
    ServiceConnector *serviceConnector = [[ServiceConnector alloc] init];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *regionDictionary = [[NSMutableDictionary alloc] init];
    [regionDictionary setValue:[prefs objectForKey:@"emailAddress"] forKey:@"id"];
    [regionDictionary setValue:selectedCountry forKey:@"region"];
    [serviceConnector postDataToWebService:regionDictionary webServiceURL:POST_REGION_AND_ID_TO_WS];
}

@end