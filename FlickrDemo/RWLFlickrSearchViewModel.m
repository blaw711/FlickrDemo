//
//  RWLImageViewModel.m
//  FlickrDemo
//
//  Created by Bob Law on 8/8/17.
//  Copyright © 2017 Bob Law. All rights reserved.
//

#import "RWLFlickrSearchViewModel.h"
#import "RWLFlickrService.h"
#import "RWLFlickrResponse.h"

static NSInteger const RWLFlickrSearchPageSize = 40;

@interface RWLFlickrSearchViewModel ()

@property (nonatomic, strong) RWLFlickrService *flickrService;

@property (nonatomic, strong) NSMutableArray <RWLFlickrImage *> *photos;

@property (nonatomic, strong) NSString *currentSearchTerm;

@property (nonatomic, assign, getter=isSearchingImages) BOOL searchingImages;

@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation RWLFlickrSearchViewModel

- (instancetype)initWithFlickrService:(RWLFlickrService *)flickrService
{
  if (self = [super init]) {
    _flickrService = flickrService;
    
    _photos = [NSMutableArray new];
    
    _searchingImages = NO;
  }
  
  return self;
}

- (NSInteger)numberOfImages
{
  return _photos.count;
}

- (NSInteger)numberOfSections
{
  return 1;
}

- (RWLFlickrImage *)imageForIndexPath:(NSIndexPath *)indexPath
{
  return _photos[indexPath.row];
}

- (void)searchFlickrImageWithTerm:(NSString *)term completion:(void (^)(BOOL, NSError *))completion
{
  if (!self.isSearchingImages || ![term isEqualToString:self.currentSearchTerm]) {
    _currentSearchTerm = term;
    [_photos removeAllObjects];
    
    _searchingImages = YES;
    _currentPage = 0;
    
    [self searchFlickrServiceWithTerm:term completion:^(RWLFlickrResponse *response, NSError *error) {
      if ([response.searchTerm isEqualToString:self.currentSearchTerm]) {
        [self.photos addObjectsFromArray:response.photos];
        
        if (completion) {
          completion(YES, error);
        }
      }
      
      _searchingImages = NO;
    }];
  } else if(completion) {
    completion(nil, nil);
  }
}

- (void)pageResultsWithCompletion:(void (^)(NSArray <NSIndexPath *> *indexPaths))completion
{
  [self searchFlickrServiceWithTerm:self.currentSearchTerm completion:^(RWLFlickrResponse *response, NSError *NSError) {
    if (completion && [response.searchTerm isEqualToString:self.currentSearchTerm]) {
      
      [self.photos addObjectsFromArray:response.photos];
      
      NSInteger section = 0;
      NSMutableArray *indexPaths = [NSMutableArray new];
      NSInteger totalNewPhotos = _photos.count;
      
      for (NSInteger row = (totalNewPhotos - response.photos.count); row < totalNewPhotos; row++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:row inSection:section];
        [indexPaths addObject:indexPath];
      }
      
      completion(indexPaths);
    }
  }];
}

- (BOOL)canPageMorePhotos
{
  return !self.isSearchingImages && [self.currentSearchTerm isKindOfClass:[NSString class]] && self.currentSearchTerm.length > 0 && _photos.count <= 200;
}

- (NSArray <RWLFlickrImage *> *)getCurrentImageResults
{
  return self.photos.copy;
}

#pragma mark - Convenience Methods

- (BOOL)isSearchingImages
{
  return _searchingImages;
}

- (void)searchFlickrServiceWithTerm:(NSString *)term completion:(void (^)(RWLFlickrResponse *response, NSError *error))completion
{
  [self.flickrService searchFlickrImageWithTerm:term page:_currentPage++ limit:RWLFlickrSearchPageSize completion:^(RWLFlickrResponse *response, NSError *error) {
    if (completion) {
      completion(response, error);
    }
  }];
}

@end
