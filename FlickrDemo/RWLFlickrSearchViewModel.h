//
//  RWLImageViewModel.h
//  FlickrDemo
//
//  Created by Bob Law on 8/8/17.
//  Copyright © 2017 Bob Law. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RWLFlickrService;
@class RWLFlickrImage;

@interface RWLFlickrSearchViewModel : NSObject

@property (nonatomic, strong, readonly) NSString *currentSearchTerm;

- (instancetype)initWithFlickrService:(RWLFlickrService *)flickrService;

- (NSInteger)numberOfImages;
- (NSInteger)numberOfSections;

- (RWLFlickrImage *)imageForIndexPath:(NSIndexPath *)indexPath;

- (void)searchFlickrImageWithTerm:(NSString *)term completion:(void (^)(BOOL finished, NSError *error))completion;

- (void)pageResultsWithCompletion:(void (^)(NSArray <NSIndexPath *> *indexPaths))completion;

- (BOOL)canPageMorePhotos;

- (NSArray <RWLFlickrImage *> *)getCurrentImageResults;

@end
