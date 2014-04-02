//
//  NSString+ConvertToArray.m
//  WeNetwork
//
//  Created by Ruoli Zhou on 02/04/2014.
//  Copyright (c) 2014 Deszie. All rights reserved.
//

#import "NSString+ConvertToArray.h"

@implementation NSString (ConvertToArray)

-(NSArray *)convertToArray
{
    NSArray *arr = [self componentsSeparatedByString:@","];
    return arr;
}

@end
