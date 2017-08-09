//
//  RWLFlickrImageDetailViewController.h
//  FlickrDemo
//
//  Created by Bob Law on 8/8/17.
//  Copyright © 2017 Bob Law. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

@class RWLFlickrImage;

@interface RWLFlickrImageDetailViewController : ASViewController

- (instancetype)initWithImage:(RWLFlickrImage *)image;

@end
