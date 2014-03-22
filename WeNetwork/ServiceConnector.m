//
//  ServiceConnector.m
//  WeNetwork
//
//  Created by zhour on 20/03/2014.
//  Copyright (c) 2014 Deszie. All rights reserved.
//

#import "ServiceConnector.h"
#import "JSONDictionaryExtensions.h"

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


-(void)getTest{
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://localhost:8888/testgetpost.php"]];
    
    [request setHTTPMethod:@"GET"];
    [request addValue:@"getValues" forHTTPHeaderField:@"METHOD"];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if(!connection){
        NSLog(@"Connection Failed");
    }
    
}

-(void)postTest{
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://localhost:8888/index.php"]];
    
    [request setHTTPMethod:@"POST"];
    [request addValue:@"postValues" forHTTPHeaderField:@"METHOD"];
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue:[prefs objectForKey:@"emailAddress"] forKey:@"id"];
    [dictionary setValue:[prefs objectForKey:@"firstName"] forKey:@"first_name"];
    [dictionary setValue:[prefs objectForKey:@"lastName"] forKey:@"last_name"];
    [dictionary setValue:[prefs objectForKey:@"industry"] forKey:@"industry"];
    [dictionary setValue:[prefs objectForKey:@"pictureUrl"] forKey:@"picture_url"];
    [dictionary setValue:[[[[prefs objectForKey:@"masterList"] objectAtIndex:1] objectAtIndex:0] objectForKey:@"title"] forKey:@"position"];
    [dictionary setValue:[[[[[prefs objectForKey:@"masterList"] objectAtIndex:1] objectAtIndex:0] objectForKey:@"company"] objectForKey:@"name"] forKey:@"company"];
    
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
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://localhost:8888/testgetpost.php"]];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if(!connection){
        NSLog(@"Connection Failed");
    }
}

#pragma mark - Data connection delegate -

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    
    receivedData = data;
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
    NSLog(@"Connection failed with error: %@",error.localizedDescription);
}

-(void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge{
    
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    NSLog(@"Request Complete,recieved %d bytes of data",receivedData.length);
    
    [self.delegate requestReturnedData:receivedData];
}

@end
