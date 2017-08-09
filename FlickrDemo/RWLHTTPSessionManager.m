//
//  RWLHTTPSessionManager.m
//  FlickrDemo
//
//  Created by Bob Law on 8/8/17.
//  Copyright © 2017 Bob Law. All rights reserved.
//

#import "RWLHTTPSessionManager.h"

static NSString * const flickrAPIKey = @"92c304e7be2893bf368730358752da55";
static NSString * const flickrAPISecret = @"f1274220b72ab20c";

@implementation RWLHTTPSessionManager

- (instancetype)init
{
  if (self = [super init]) {
    
//    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
//    responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//    self.responseSerializer = responseSerializer;
  }
  
  return self;
}

- (void)searchFlickrImageWithTerm:(NSString *)term page:(NSInteger)page limit:(NSInteger)limit completion:(void (^)(id, NSError *))completion
{
  if (!term || ![term isKindOfClass:[NSString class]] || term.length == 0) {
    if (completion) {
      completion(nil, [NSError errorWithDomain:@"FlickrDemo.RWLHTTPSessionManager.invalidParamters" code:0 userInfo:nil]);
    }
    return;
  }
  
  NSDictionary *parameters = @{@"api_key":flickrAPIKey, @"format":@"json", @"nojsoncallback":@(YES), @"method":@"flickr.photos.search", @"text":term, @"page":@(page), @"per_page":@(limit)};
  
  [self GET:@"https://api.flickr.com/services/rest" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    if (completion) {
      completion(responseObject, nil);
    }
  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    if (completion) {
      completion(nil, error);
    }
  }];
}

@end
