//
//  ChattingFlow.h
//  WeNetwork
//
//  Created by zhour on 29/04/2014.
//  Copyright (c) 2014 Deszie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServiceConnector.h"
@interface ChattingFlow : NSObject <ServiceConnectorDelegate>
-(void)getChattingFolksSender:(NSString *)sender
                     Receiver:(NSString *)receiver
                      Message:(NSString *)message
                          URL:(NSString *)url;

-(NSArray *)getChatMessage;
@end
