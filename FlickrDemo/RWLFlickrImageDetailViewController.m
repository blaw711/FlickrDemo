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
  
  self.title = self.flickrImage.title;
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  
  self.navigationController.hidesBarsOnTap = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  
  self.navigationController.hidesBarsOnTap = NO;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
  [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
  
  [self.multiplexImageNode reloadImageIdentifierSources];
}

#pragma mark - ASMultiplexImageNodeDataSource

- (NSURL *)multiplexImageNode:(ASMultiplexImageNode *)imageNode URLForImageIdentifier:(ASImageIdentifier)imageIdentifier
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

@end
