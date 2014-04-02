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

-(void)postProfileData{
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://localhost:8888/index.php"]];
    
    [request setHTTPMethod:@"POST"];
    [request addValue:@"postValues" forHTTPHeaderField:@"METHOD"];
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue:[prefs objectForKey:@"emailAddress"] forKey:@"id"];
    [dictionary setValue:[prefs objectForKey:@"firstName"] forKey:@"first_name"];
    [dictionary setValue:[prefs objectForKey:@"lastName"] forKey:@"last_name"];
    [dictionary setValue:[prefs objectForKey:@"industry"] forKey:@"industry"];
    [dictionary setValue:[prefs objectForKey:@"pictureUrl"] forKey:@"picture_url"];
    [dictionary setValue:self.getPositionTitleList forKey:@"position"];
    [dictionary setValue:self.getCompanyHistoryList forKey:@"company"];
    [dictionary setValue:self.getSkillSetList forKey:@"skills"];
    [dictionary setValue:[prefs objectForKey:@"summary"] forKey:@"summary"];
    
    NSData *data = [[dictionary copy] JSONValue];
    
    [request setHTTPBody:data];
    [request addValue:[NSString stringWithFormat:@"%d",data.length] forHTTPHeaderField:@"Content-Length"];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if(!connection){
        NSLog(@"Connection Failed");
    }
    
}

-(void)postDataControllerSigns:(NSMutableDictionary *)dictionary
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://localhost:8888/postControllers.php"]];
    
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
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://localhost:8888/testgetpost.php"]];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if(!connection){
        NSLog(@"Connection Failed");
    }
}


-(NSString *)getCompanyHistoryList
{
    NSString * companies = @"";
    NSArray * companyList = [[prefs objectForKey:@"masterList"] objectAtIndex:1];
    for (int i=0; i<[companyList count]; i++) {
        NSString *companyName = [[[companyList objectAtIndex:i] objectForKey:@"company"] objectForKey:@"name"];
        
        companies = [companies stringByAppendingString:[NSString stringWithFormat:@"%@,", companyName]];
    }
    return [companies substringToIndex:[companies length]-1];
}


-(NSString *)getPositionTitleList
{
    NSString * titles = @"";
    NSArray * titlesList = [[prefs objectForKey:@"masterList"] objectAtIndex:1];
    for (int i = 0; i<[titlesList count]; i++) {
        NSString *titlesName = [[titlesList objectAtIndex:i] objectForKey:@"title"];
        
        titles = [titles stringByAppendingString:[NSString stringWithFormat:@"%@,", titlesName]];
    }
    return [titles substringToIndex:[titles length]-1];
}

-(NSString *)getSkillSetList
{
    NSString * skills = @"";
    NSArray * skillsList = [[prefs objectForKey:@"masterList"] objectAtIndex:2];
    for (int i = 0; i<[skillsList count]; i++) {
        NSString *skillsName = [[[skillsList objectAtIndex:i] objectForKey:@"skill"] objectForKey:@"name"];
        
        skills = [skills stringByAppendingString:[NSString stringWithFormat:@"%@,", skillsName]];
    }
    return [skills substringToIndex:[skills length]-1];
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
