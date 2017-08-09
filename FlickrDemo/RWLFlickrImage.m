//
//  RWLFlickrImage.m
//  FlickrDemo
//
//  Created by Bob Law on 8/8/17.
//  Copyright © 2017 Bob Law. All rights reserved.
//

#import "RWLFlickrImage.h"

@interface RWLFlickrImage ()

@property (nonatomic, strong) NSNumber *isFamily;
@property (nonatomic, strong) NSNumber *isFriend;
@property (nonatomic, strong) NSNumber *isPublic;

@property (nonatomic, strong) NSNumber *farm;
@property (nonatomic, strong) NSString *server;
@property (nonatomic, strong) NSString *secret;

@property (nonatomic, strong) NSString *owner;
@property (nonatomic, strong) NSString *imageID;
@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSURL *smallURL;
@property (nonatomic, strong) NSURL *mediumURL;
@property (nonatomic, strong) NSURL *largeURL;

@end

@implementation RWLFlickrImage

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
  if (self = [super init]) {
    _isFamily = [self jsonElementGaurd:[dictionary objectForKey:@"isfamily"]];
    _isFriend = [self jsonElementGaurd:[dictionary objectForKey:@"isfriend"]];
    _isPublic = [self jsonElementGaurd:[dictionary objectForKey:@"ispublic"]];
    
    _farm = [self jsonElementGaurd:[dictionary objectForKey:@"farm"]];
    _server = [self jsonElementGaurd:[dictionary objectForKey:@"server"]];
    _secret = [self jsonElementGaurd:[dictionary objectForKey:@"secret"]];
    
    _owner = [self jsonElementGaurd:[dictionary objectForKey:@"owner"]];
    _imageID = [self jsonElementGaurd:[dictionary objectForKey:@"id"]];
    _title = [self jsonElementGaurd:[dictionary objectForKey:@"title"]];
    
    [self configureImageURLs];
  }
  
  return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
  if (self = [super init]) {
    _isFamily = [decoder decodeObjectForKey:@"isFamily"];
    _isFriend = [decoder decodeObjectForKey:@"isFriend"];
    _isPublic = [decoder decodeObjectForKey:@"isPublic"];
    
    _farm = [decoder decodeObjectForKey:@"farm"];
    _server = [decoder decodeObjectForKey:@"server"];
    _secret = [decoder decodeObjectForKey:@"secret"];
    
    _owner = [decoder decodeObjectForKey:@"owner"];
    _imageID = [decoder decodeObjectForKey:@"imageID"];
    _title = [decoder decodeObjectForKey:@"title"];
    
    _smallURL = [decoder decodeObjectForKey:@"smallURL"];
    _mediumURL = [decoder decodeObjectForKey:@"mediumURL"];
    _largeURL = [decoder decodeObjectForKey:@"largeURL"];
  }
  
  return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
  [encoder encodeObject:self.isFamily forKey:@"isFamily"];
  [encoder encodeObject:self.isFriend forKey:@"isFriend"];
  [encoder encodeObject:self.isPublic forKey:@"isPublic"];
  
  [encoder encodeObject:self.farm forKey:@"farm"];
  [encoder encodeObject:self.server forKey:@"server"];
  [encoder encodeObject:self.secret forKey:@"secret"];
  
  [encoder encodeObject:self.owner forKey:@"owner"];
  [encoder encodeObject:self.imageID forKey:@"imageID"];
  [encoder encodeObject:self.title forKey:@"title"];
  
  [encoder encodeObject:self.smallURL forKey:@"smallURL"];
  [encoder encodeObject:self.mediumURL forKey:@"mediumURL"];
  [encoder encodeObject:self.largeURL forKey:@"largeURL"];
}

- (void)configureImageURLs
{
  NSString *baseFormatString = [NSString stringWithFormat:@"https://farm%@.staticflickr.com/%@/%@_%@", self.farm, self.server, self.imageID, self.secret];
  
  NSString *smallURLString = [baseFormatString stringByAppendingString:@"_m.jpg"];
  _smallURL = [NSURL URLWithString:smallURLString];
  
  NSString *mediumURLString = [baseFormatString stringByAppendingString:@"_z.jpg"];
  _mediumURL = [NSURL URLWithString:mediumURLString];
  
  NSString *largeURLString = [baseFormatString stringByAppendingString:@"_b.jpg"];
  _largeURL = [NSURL URLWithString:largeURLString];
}

- (id)jsonElementGaurd:(id)element
{
  return [element isKindOfClass:[NSNull class]] ? nil : element;
}

@end
