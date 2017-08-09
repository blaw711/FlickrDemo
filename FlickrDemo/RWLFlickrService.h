//
//  RWLFlickrService.h
//  FlickrDemo
//
//  Created by Bob Law on 8/8/17.
//  Copyright © 2017 Bob Law. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RWLHTTPSessionManager.h"

@class RWLFlickrResponse;

@interface RWLFlickrService : NSObject

- (instancetype)initWithSessionManager:(RWLHTTPSessionManager *)sessionManager;

- (void)searchFlickrImageWithTerm:(NSString *)term page:(NSInteger)page limit:(NSInteger)limit completion:(void (^)(RWLFlickrResponse *response, NSError *error))completion;

@end
