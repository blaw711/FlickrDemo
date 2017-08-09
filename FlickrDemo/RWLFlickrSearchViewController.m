//
//  RWLFlickrSearchViewController.m
//  FlickrDemo
//
//  Created by Bob Law on 8/8/17.
//  Copyright © 2017 Bob Law. All rights reserved.
//

#import "RWLFlickrSearchViewController.h"
#import "RWLFlickrResultsViewController.h"

@interface RWLFlickrSearchViewController ()

@property (nonatomic, strong) RWLFlickrService *flickrService;

@property (nonatomic, strong) UISearchController *searchController;

@property (nonatomic, strong) ASCollectionNode *collectionNode;

@end

@implementation RWLFlickrSearchViewController

- (instancetype)initWithFlickrService:(RWLFlickrService *)flickrService
{
  _collectionNode = [[ASCollectionNode alloc] initWithCollectionViewLayout:[UICollectionViewLayout new]];
  
  if (self = [super initWithNode:_collectionNode]) {
    
    RWLFlickrResultsViewController *resultsViewController = [[RWLFlickrResultsViewController alloc] initWithFlickrService:flickrService];
    
    _searchController = [[UISearchController alloc] initWithSearchResultsController:resultsViewController];
    _searchController.searchResultsUpdater = resultsViewController;
    _searchController.hidesNavigationBarDuringPresentation = NO;
    
    self.definesPresentationContext = YES;
  }
  
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.navigationItem.titleView = _searchController.searchBar;
}

@end
