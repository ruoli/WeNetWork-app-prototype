//
//  ServiceConnector.h
//  WeNetwork
//
//  Created by zhour on 20/03/2014.
//  Copyright (c) 2014 Deszie. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ServiceConnectorDelegate <NSObject>

-(void)requestReturnedData:(NSData*)data;

@end

@interface ServiceConnector : NSObject <NSURLConnectionDelegate,NSURLConnectionDataDelegate>

@property (strong,nonatomic)NSUserDefaults *prefs;
@property (strong,nonatomic) id <ServiceConnectorDelegate> delegate;

-(void)getTest;
-(void)postTest;
-(void)retrieveDataFromDB;

@end
