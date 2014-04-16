//
//  ServiceConnector.m
//  WeNetwork
//
//  Created by zhour on 20/03/2014.
//  Copyright (c) 2014 Deszie. All rights reserved.
//

#import "ServiceConnector.h"
#import "JSONDictionaryExtensions.h"
#define POST_TO_BASIC_PROFILE_WS @"http://localhost:8888/post_basic_profile.php"
#define RETRIEVE_DATA_FROM_WS @"http://localhost:8888/retrieve_others_profile.php"
@implementation ServiceConnector{
    NSData *receivedData;;
}
@synthesize prefs;

- (id)init {
    self = [super init];
    if (self) {
        prefs = [ NSUserDefaults standardUserDefaults];
    }
    return self;
}



-(void)postProfileData{
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:POST_TO_BASIC_PROFILE_WS]];
    
    [request setHTTPMethod:@"POST"];
    [request addValue:@"postValues" forHTTPHeaderField:@"METHOD"];
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue:[prefs objectForKey:@"emailAddress"] forKey:@"id"];
    [dictionary setValue:[prefs objectForKey:@"firstName"] forKey:@"first_name"];
    [dictionary setValue:[prefs objectForKey:@"lastName"] forKey:@"last_name"];
    [dictionary setValue:[prefs objectForKey:@"industry"] forKey:@"industry"];
    [dictionary setValue:[prefs objectForKey:@"pictureUrl"] forKey:@"picture_url"];
    [dictionary setValue:[self getItemNamesList:@"title"] forKey:@"position"];
    [dictionary setValue:[self getItemNamesList:@"company"] forKey:@"company"];
    [dictionary setValue:[self getItemNamesList:@"skill"] forKey:@"skills"];
    [dictionary setValue:[self getItemNamesList:@"schoolName"] forKey:@"school_name"];
    [dictionary setValue:[self getItemNamesList:@"fieldOfStudy"] forKey:@"field_of_study"];
    [dictionary setValue:[prefs objectForKey:@"summary"] forKey:@"summary"];
    
    NSData *data = [[dictionary copy] JSONValue];
    
    [request setHTTPBody:data];
    [request addValue:[NSString stringWithFormat:@"%d",data.length] forHTTPHeaderField:@"Content-Length"];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if(!connection){
        NSLog(@"Connection Failed");
    }
    
}

-(void)postDataToWebService:(NSMutableDictionary *)dictionary
              webServiceURL:(NSString *)wsURL
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:wsURL]];
    
    [request setHTTPMethod:@"POST"];
    [request addValue:@"postValues" forHTTPHeaderField:@"METHOD"];
    
    NSData *data = [[dictionary copy] JSONValue];
    
    [request setHTTPBody:data];
    [request addValue:[NSString stringWithFormat:@"%d",data.length] forHTTPHeaderField:@"Content-Length"];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if(!connection){
        NSLog(@"Connection Failed");
    }
}

-(void)retrieveDataFromDB
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:RETRIEVE_DATA_FROM_WS]];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if(!connection){
        NSLog(@"Connection Failed");
    }
}



-(NSString *)getItemNamesList:(NSString *)itemName
{
    NSString * item = @"";
    NSArray * itemNameList = [[prefs objectForKey:@"masterList"] objectAtIndex:0];
    for (int i=0; i<[itemNameList count]; i++) {
        NSString *itemNames = [[itemNameList objectAtIndex:i] objectForKey:itemName];
        
        item = [item stringByAppendingString:[NSString stringWithFormat:@"%@,", itemNames]];
    }
    return [item substringToIndex:[item length]-1];
}




#pragma mark - Data connection delegate -

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    
    receivedData = data;
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
//    NSLog(@"Connection failed with error: %@",error.localizedDescription);
}

-(void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge{
    
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    NSLog(@"Request Complete,recieved %d bytes of data",receivedData.length);
    
    [self.delegate requestReturnedData:receivedData];
}

@end
