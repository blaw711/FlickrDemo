//
//  RWLFlickrImageDetailViewController.m
//  FlickrDemo
//
//  Created by Bob Law on 8/8/17.
//  Copyright © 2017 Bob Law. All rights reserved.
//

#import "RWLFlickrImageDetailViewController.h"
#import "RWLFlickrImage.h"

@interface RWLFlickrImageDetailViewController () <ASMultiplexImageNodeDataSource>

@property (nonatomic, strong) RWLFlickrImage *flickrImage;

@property (nonatomic, strong) ASMultiplexImageNode *multiplexImageNode;

@end

@implementation RWLFlickrImageDetailViewController

- (instancetype)initWithImage:(RWLFlickrImage *)image
{
  _multiplexImageNode = [[ASMultiplexImageNode alloc] init];
  
  if (self = [super initWithNode:_multiplexImageNode]) {
    _flickrImage = image;
    
    _multiplexImageNode.contentMode = UIViewContentModeScaleAspectFit;
    _multiplexImageNode.dataSource = self;
    _multiplexImageNode.downloadsIntermediateImages = YES;
    _multiplexImageNode.imageIdentifiers = @[@"large", @"medium", @"small"];
  }
  
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
}

#pragma mark - ASMultiplexImageNodeDataSource

- (nullable NSURL *)multiplexImageNode:(ASMultiplexImageNode *)imageNode URLForImageIdentifier:(ASImageIdentifier)imageIdentifier
{
  NSURL *url;
  
  if ([imageIdentifier isEqual:@"small"]) {
    url = self.flickrImage.smallURL;
  } else if ([imageIdentifier isEqual:@"medium"]) {
    url = self.flickrImage.mediumURL;
  } else if ([imageIdentifier isEqual:@"large"]) {
    url = self.flickrImage.largeURL;
  }
  
  return url;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
