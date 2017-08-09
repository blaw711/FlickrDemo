//
//  RWLFlickrResultHistory.m
//  FlickrDemo
//
//  Created by Bob Law on 8/9/17.
//  Copyright © 2017 Bob Law. All rights reserved.
//

#import "RWLFlickrResultHistory.h"

static NSString *const RWLFlickrResultHistoryKey = @"RWLFlickrResultHistoryKey";
static NSInteger const RWLFlickrResultHistoryMax = 200;

@interface RWLFlickrResultHistory ()

@property (nonatomic, strong) NSUserDefaults *userDefaults;

@end

@implementation RWLFlickrResultHistory

- (instancetype)initWithUserDefaults:(NSUserDefaults *)userDefaults
{
  if (self = [super init]) {
    _userDefaults = userDefaults ?: [NSUserDefaults standardUserDefaults];
  }
  
  return self;
}

- (void)saveFlickrImages:(NSArray<RWLFlickrImage *> *)images
{
  if ([images isKindOfClass:[NSArray class]] && images.count > 0) {
    NSMutableArray *currentlySavedDataArray = [self currentlySavedData].mutableCopy;

    if (!currentlySavedDataArray) {
      currentlySavedDataArray = [[NSMutableArray alloc] initWithCapacity:images.count];
    }
    
    [images enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(RWLFlickrImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
      NSData *data = [NSKeyedArchiver archivedDataWithRootObject:obj];
      [currentlySavedDataArray insertObject:data atIndex:0];
    }];
    
    if (currentlySavedDataArray.count > RWLFlickrResultHistoryMax) {
      currentlySavedDataArray = [currentlySavedDataArray subarrayWithRange:NSMakeRange(0, RWLFlickrResultHistoryMax - 1)].mutableCopy;
    }
    
    [self.userDefaults setObject:currentlySavedDataArray.copy forKey:RWLFlickrResultHistoryKey];
    [self.userDefaults synchronize];
  }
}

- (NSArray <RWLFlickrImage *> *)fetchFlickrImages
{
  NSArray <NSData *> *dataArray = [self currentlySavedData];
  
  NSMutableArray *imagesArray = [[NSMutableArray alloc] initWithCapacity:dataArray.count];
  
  [dataArray enumerateObjectsUsingBlock:^(NSData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    RWLFlickrImage *image = [NSKeyedUnarchiver unarchiveObjectWithData:obj];
    [imagesArray addObject:image];
  }];
  
  return imagesArray.copy;
}
                                               
#pragma mark - Convenience Methods

- (NSArray <NSData *> *)currentlySavedData
{
  return [self.userDefaults objectForKey:RWLFlickrResultHistoryKey];
}

@end
