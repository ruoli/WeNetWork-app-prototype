//
//  ChattingFlow.m
//  WeNetwork
//
//  Created by zhour on 29/04/2014.
//  Copyright (c) 2014 Deszie. All rights reserved.
//

#import "ChattingFlow.h"

@interface ChattingFlow()
@property(strong,nonatomic)ServiceConnector *serviceConnector;
@property(strong,nonatomic)NSArray * chattingData;
@end

@implementation ChattingFlow
@synthesize serviceConnector;
@synthesize chattingData;

- (id)init
 {
    self = [super init];
    if (self) {
        serviceConnector = [[ServiceConnector alloc] init];
        serviceConnector.delegate = self;
    }
    return self;
}

-(void)getChattingFolksSender:(NSString *)sender
                     Receiver:(NSString *)receiver
                      Message:(NSString *)message
                          URL:(NSString *)url
{
    NSMutableDictionary *identifier = [[NSMutableDictionary alloc] init];
    [identifier setValue:sender forKeyPath:@"sender"];
    [identifier setValue:receiver forKeyPath:@"receiver"];
    [identifier setValue:message forKeyPath:@"message"];
    
    [serviceConnector postDataToWebService:identifier webServiceURL:url];
}


-(void)requestReturnedData:(NSData *)data
{
    NSError *error;
    if (data != NULL) {
        chattingData = [[NSArray alloc] initWithArray:[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error]];
        NSLog(@"%@", chattingData);
    }
    
}

-(NSArray *)getChatMessage
{
    return chattingData;
}
@end
