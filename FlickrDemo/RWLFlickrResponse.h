//
//  RWLFlickrResponse.h
//  FlickrDemo
//
//  Created by Bob Law on 8/8/17.
//  Copyright © 2017 Bob Law. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RWLFlickrImage;

@interface RWLFlickrResponse : NSObject

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@property (nonatomic, strong, readonly) NSNumber *page;
@property (nonatomic, strong, readonly) NSNumber *perPage;

@property (nonatomic, strong, readonly) NSNumber *pages;

@property (nonatomic, strong, readonly) NSArray <RWLFlickrImage *> *photos;

@property (nonatomic, strong) NSString *searchTerm;

@end
