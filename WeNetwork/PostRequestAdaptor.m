//
//  HomeViewContactConnectAdaptor.m
//  WeNetwork
//
//  Created by zhour on 14/04/2014.
//  Copyright (c) 2014 Deszie. All rights reserved.
//

#import "PostRequestAdaptor.h"
@interface PostRequestAdaptor ()
@property(strong,nonatomic)ServiceConnector *serviceConnector;
@end

@implementation PostRequestAdaptor
@synthesize serviceConnector;

- (id)init {
    self = [super init];
    if (self) {
        serviceConnector = [[ServiceConnector alloc] init];
    }
    return self;
}



-(void)postContactRequest:(NSMutableDictionary *)dictionary :(NSString *)url
{
    [serviceConnector postDataToWebService:dictionary webServiceURL:url];
    
}

@end
