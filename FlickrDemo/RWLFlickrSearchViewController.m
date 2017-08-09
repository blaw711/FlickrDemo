//
//  RWLFlickrSearchViewController.m
//  FlickrDemo
//
//  Created by Bob Law on 8/8/17.
//  Copyright © 2017 Bob Law. All rights reserved.
//

#import "RWLFlickrSearchViewController.h"
#import "RWLFlickrResultsViewController.h"
#import "RWLFlickrImageDetailViewController.h"
#import "RWLFlickrResultHistory.h"
#import "RWLImageCellNode.h"
#import "RWLFlickrImage.h"

@interface RWLFlickrSearchViewController () <ASCollectionDelegate, ASCollectionDataSource>

@property (nonatomic, strong) RWLFlickrService *flickrService;

@property (nonatomic, strong) UISearchController *searchController;

@property (nonatomic, strong) ASCollectionNode *collectionNode;

@property (nonatomic, strong) NSArray <RWLFlickrImage *> *flickrImageHistory;

@end

@implementation RWLFlickrSearchViewController

- (instancetype)initWithFlickrService:(RWLFlickrService *)flickrService
{
  UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
  CGFloat width = [UIScreen mainScreen].bounds.size.width;
  flowLayout.minimumLineSpacing = 1;
  flowLayout.minimumInteritemSpacing = 1;
  flowLayout.itemSize = CGSizeMake(width / 3 - 1, width / 3 - 1);
  flowLayout.sectionInset = UIEdgeInsetsMake(1, 0, 1, 0);
  flowLayout.headerReferenceSize = CGSizeMake(width, 44);
  
  _collectionNode = [[ASCollectionNode alloc] initWithCollectionViewLayout:flowLayout];
  
  if (self = [super initWithNode:_collectionNode]) {
    self.definesPresentationContext = YES;
    
    RWLFlickrResultHistory *resultHistory = [[RWLFlickrResultHistory alloc] initWithUserDefaults:[NSUserDefaults standardUserDefaults]];
    
    RWLFlickrResultsViewController *resultsViewController = [[RWLFlickrResultsViewController alloc] initWithFlickrService:flickrService flickrResultHistory:resultHistory];
    
    _searchController = [[UISearchController alloc] initWithSearchResultsController:resultsViewController];
    _searchController.searchResultsUpdater = resultsViewController;
    _searchController.hidesNavigationBarDuringPresentation = NO;
    _searchController.searchBar.placeholder = @"Search Flickr";
    
    [_collectionNode registerSupplementaryNodeOfKind:UICollectionElementKindSectionHeader];
    _collectionNode.delegate = self;
    _collectionNode.dataSource = self;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
      _flickrImageHistory = [resultHistory fetchFlickrImages];
      dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionNode reloadData];
      });
    });
  }
  
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.navigationItem.titleView = _searchController.searchBar;
}

#pragma mark - ASCollectionDataSource

- (NSInteger)collectionNode:(ASCollectionNode *)collectionNode numberOfItemsInSection:(NSInteger)section
{
  return self.flickrImageHistory.count;
}

- (NSInteger)numberOfSectionsInCollectionNode:(ASCollectionNode *)collectionNode
{
  return self.flickrImageHistory.count > 0 ? 1 : 0;
}

- (ASCellNodeBlock)collectionNode:(ASCollectionNode *)collectionNode nodeBlockForItemAtIndexPath:(NSIndexPath *)indexPath
{
  RWLFlickrImage *image = self.flickrImageHistory[indexPath.row];
  
  return ^{
    return [[RWLImageCellNode alloc] initWithImage:image];
  };
}

- (ASCellNodeBlock)collectionNode:(ASCollectionNode *)collectionNode nodeBlockForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
  return ^{
    ASTextCellNode *textCellNode = [ASTextCellNode new];
    textCellNode.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.9];
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
      textCellNode.text = @"Previous Search History";
    }
    
    return textCellNode;
  };
}

#pragma mark - ASCollectionDelegate

- (void)collectionNode:(ASCollectionNode *)collectionNode didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
  RWLFlickrImage *image = self.flickrImageHistory[indexPath.row];
  
  RWLFlickrImageDetailViewController *detailViewController = [[RWLFlickrImageDetailViewController alloc] initWithImage:image];
  [self.navigationController pushViewController:detailViewController animated:YES];
}

@end
