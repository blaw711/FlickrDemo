//
//  RWLHTTPSessionManager.h
//  FlickrDemo
//
//  Created by Bob Law on 8/8/17.
//  Copyright © 2017 Bob Law. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface RWLHTTPSessionManager : AFHTTPSessionManager

- (void)searchFlickrImageWithTerm:(NSString *)term page:(NSInteger)page limit:(NSInteger)limit completion:(void (^)(id results, NSError *error))completion;

@end
