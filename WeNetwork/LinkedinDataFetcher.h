//
//  LinkedinDataFetchController.h
//  WeNetwork
//
//  Created by zhour on 12/03/2014.
//  Copyright (c) 2014 Deszie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LinkedinDataFetcher : NSObject
@property(strong,nonatomic) NSMutableArray * companyList;
@property(strong,nonatomic) NSMutableArray * skillList;
@property(strong,nonatomic) NSMutableArray * jobTitleList;
@property(strong,nonatomic) NSMutableArray * masterList;

-(void)loadDataFromLinkedinToLocalDefault:(NSDictionary *)results;
-(void)setMasterListToPrefs;
@end
