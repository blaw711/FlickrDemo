//
//  RWLFlickrResultHistory.h
//  FlickrDemo
//
//  Created by Bob Law on 8/9/17.
//  Copyright © 2017 Bob Law. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RWLFlickrImage;

@interface RWLFlickrResultHistory : NSObject

- (instancetype)initWithUserDefaults:(NSUserDefaults *)userDefaults;

- (void)saveFlickrImages:(NSArray <RWLFlickrImage *> *)images;

- (NSArray <RWLFlickrImage *> *)fetchFlickrImages;

@end
