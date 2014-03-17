//
//  LinkedinDataFetchController.m
//  WeNetwork
//
//  Created by zhour on 12/03/2014.
//  Copyright (c) 2014 Deszie. All rights reserved.
//

#import "LinkedinDataFetcher.h"

@implementation LinkedinDataFetcher
@synthesize companyList,skillList,jobTitleList,masterList;

- (id)init {
    self = [super init];
    if (self) {
        masterList = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)loadDataFromLinkedinToLocalDefault:(NSDictionary *)results
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    for (int i= 0; i < [results count]; i++) {
        NSString * keyName = [[results allKeys] objectAtIndex:i];
        if ([[results objectForKey:keyName] isKindOfClass:[NSDictionary class]]) {
            [self loadDataFromLinkedinToLocalDefault:[results objectForKey:keyName]];
           
        }
        else if ([[results objectForKey:keyName] isKindOfClass:[NSArray class]]) {
            [masterList addObject:[results objectForKey:keyName]];
//            [self loadDataFromLinkedinToLocalDefault:[[results objectForKey:keyName] objectAtIndex:i]];
            
        }
        else if ([[results objectForKey:keyName] isKindOfClass:[NSString class]]){
            [prefs setObject:[results objectForKey:keyName] forKey:keyName];
        }
    }
    
//    [prefs setObject:skillList forKey:@"skillList"];
    
    
//    NSLog(@"skill: %@", skillList);
//    NSLog(@"skill: %@", [prefs objectForKey:@"degree"]);
//    NSLog(@"skill: %@", [prefs objectForKey:@"title"]);
}

-(void)setMasterListToPrefs
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:masterList forKey:@"masterList"];
    NSLog(@"degree: %@", [[masterList objectAtIndex:0] objectAtIndex:0]);
    NSLog(@"company: %@", [[[masterList objectAtIndex:1] objectAtIndex:0] objectForKey:@"company"]);
    NSLog(@"title: %@", [[[masterList objectAtIndex:1] objectAtIndex:0] objectForKey:@"title"]);
}
@end
