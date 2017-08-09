//
//  RWLFlickrImage.h
//  FlickrDemo
//
//  Created by Bob Law on 8/8/17.
//  Copyright © 2017 Bob Law. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RWLFlickrImage : NSObject

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@property (nonatomic, strong, readonly) NSNumber *isFamily;
@property (nonatomic, strong, readonly) NSNumber *isFriend;
@property (nonatomic, strong, readonly) NSNumber *isPublic;

@property (nonatomic, strong, readonly) NSNumber *farm;

@property (nonatomic, strong, readonly) NSString *server;
@property (nonatomic, strong, readonly) NSString *secret;

@property (nonatomic, strong, readonly) NSString *owner;
@property (nonatomic, strong, readonly) NSString *imageID;
@property (nonatomic, strong, readonly) NSString *title;

@property (nonatomic, strong, readonly) NSURL *smallURL;
@property (nonatomic, strong, readonly) NSURL *mediumURL;
@property (nonatomic, strong, readonly) NSURL *largeURL;


@end
