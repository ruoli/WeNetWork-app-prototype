//
//  HomeViewContactConnectAdaptor.h
//  WeNetwork
//
//  Created by zhour on 14/04/2014.
//  Copyright (c) 2014 Deszie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServiceConnector.h"
@interface PostRequestAdaptor : NSObject
-(void)postContactRequest:(NSMutableDictionary *)dictionary :(NSString *)url;
@end
