//
//  RWLFlickrResultsViewController.h
//  FlickrDemo
//
//  Created by Bob Law on 8/8/17.
//  Copyright © 2017 Bob Law. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

@class RWLFlickrService;
@class RWLFlickrResultHistory;

@interface RWLFlickrResultsViewController : ASViewController <UISearchResultsUpdating>

- (instancetype)initWithFlickrService:(RWLFlickrService *)flickrService flickrResultHistory:(RWLFlickrResultHistory *)resultHistory;

@end
