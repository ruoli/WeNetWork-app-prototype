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
            
        }
        else if ([[results objectForKey:keyName] isKindOfClass:[NSString class]]){
            [prefs setObject:[results objectForKey:keyName] forKey:keyName];
        }
    }
}

-(void)setMasterListToPrefs
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:masterList forKey:@"masterList"];
}
@end
