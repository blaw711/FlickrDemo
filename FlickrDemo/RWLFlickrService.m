//
//  RWLFlickrService.m
//  FlickrDemo
//
//  Created by Bob Law on 8/8/17.
//  Copyright © 2017 Bob Law. All rights reserved.
//

#import "RWLFlickrService.h"
#import "RWLFlickrResponse.h"

@interface RWLFlickrService ()

@property (nonatomic, strong) RWLHTTPSessionManager *sessionManager;

@end

@implementation RWLFlickrService

- (instancetype)initWithSessionManager:(RWLHTTPSessionManager *)sessionManager
{
  if (self = [super init]) {
    _sessionManager = sessionManager;
  }
  
  return self;
}

- (void)searchFlickrImageWithTerm:(NSString *)term page:(NSInteger)page limit:(NSInteger)limit completion:(void (^)(RWLFlickrResponse *, NSError *))completion
{
  [self.sessionManager searchFlickrImageWithTerm:term page:page limit:limit completion:^(id results, NSError *error) {
    RWLFlickrResponse *response;
    if ([results isKindOfClass:[NSDictionary class]]) {
      NSDictionary *resultsDictionary = (NSDictionary *)results;
      NSDictionary *photosDictionary = [resultsDictionary objectForKey:@"photos"];
      
      response = [[RWLFlickrResponse alloc] initWithDictionary:photosDictionary];
      response.searchTerm = term;
    }
    
    if (completion) {
      completion(response, error);
    }
  }];
}



@end
