//
//  RWLFlickrResponse.m
//  FlickrDemo
//
//  Created by Bob Law on 8/8/17.
//  Copyright © 2017 Bob Law. All rights reserved.
//

#import "RWLFlickrResponse.h"
#import "RWLFlickrImage.h"

@interface RWLFlickrResponse ()

@property (nonatomic, strong) NSNumber *page;
@property (nonatomic, strong) NSNumber *perPage;

@property (nonatomic, strong) NSNumber *pages;

@property (nonatomic, strong) NSArray <RWLFlickrImage *> *photos;

@end

@implementation RWLFlickrResponse

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
  if (self = [super init]) {
    _page = [self jsonElementGaurd:[dictionary objectForKey:@"page"]];
    _perPage = [self jsonElementGaurd:[dictionary objectForKey:@"perpage"]];
    _pages = [self jsonElementGaurd:[dictionary objectForKey:@"pages"]];

    NSArray <NSDictionary *> *photos = [self jsonElementGaurd:[dictionary objectForKey:@"photo"]];
    if ([photos isKindOfClass:[NSArray class]]) {
      _photos = [self flickrImagesFromArray:photos];
    }
  }
  
  return self;
}

- (id)jsonElementGaurd:(id)element
{
  return [element isKindOfClass:[NSNull class]] ? nil : element;
}

- (NSArray <RWLFlickrImage *> *)flickrImagesFromArray:(NSArray <NSDictionary *> *)array
{
  NSMutableArray <RWLFlickrImage *> *photos = [NSMutableArray new];
  
  [array enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    RWLFlickrImage *image = [[RWLFlickrImage alloc] initWithDictionary:obj];
    [photos addObject:image];
  }];
  
  return photos;
}

@end
