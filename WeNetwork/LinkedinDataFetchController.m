//
//  LinkedinDataFetchController.m
//  WeNetwork
//
//  Created by zhour on 12/03/2014.
//  Copyright (c) 2014 Deszie. All rights reserved.
//

#import "LinkedinDataFetchController.h"

@implementation LinkedinDataFetchController


-(void)loadDataFromLinkedinToLocalDefault:(NSDictionary *)results
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    for (int i= 0; i < [results count]; i++) {
        NSString * keyName = [[results allKeys] objectAtIndex:i];
        [prefs setObject:[results objectForKey:keyName] forKey:keyName];
    }
}
@end
