//
//  RWLFlickrResultsViewController.m
//  FlickrDemo
//
//  Created by Bob Law on 8/8/17.
//  Copyright © 2017 Bob Law. All rights reserved.
//

#import "RWLFlickrResultsViewController.h"
#import "RWLFlickrImageDetailViewController.h"
#import "RWLImageCellNode.h"
#import "RWLFlickrSearchViewModel.h"
#import "RWLFlickrService.h"

@interface RWLFlickrResultsViewController () <ASCollectionDataSource, ASCollectionDelegate>

@property (nonatomic, strong) RWLFlickrService *flickrService;

@property (nonatomic, strong) ASCollectionNode *collectionNode;

@property (nonatomic, strong) RWLFlickrSearchViewModel *viewModel;

@end

@implementation RWLFlickrResultsViewController

- (instancetype)initWithFlickrService:(RWLFlickrService *)flickrService
{
  UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
  CGFloat width = [UIScreen mainScreen].bounds.size.width;
  flowLayout.minimumLineSpacing = 2;
  flowLayout.minimumInteritemSpacing = 2;
  flowLayout.itemSize = CGSizeMake(width / 3 - 3, width / 3 - 3);
  flowLayout.sectionInset = UIEdgeInsetsMake(2, 2, 2, 2);
  
  _collectionNode = [[ASCollectionNode alloc] initWithCollectionViewLayout:flowLayout];
  
  if (self = [super initWithNode:_collectionNode]) {
    _flickrService = flickrService;
    
    _viewModel = [[RWLFlickrSearchViewModel alloc] initWithFlickrService:flickrService];
    
    _collectionNode.delegate = self;
    _collectionNode.dataSource = self;
  }
  
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];

}

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
  [self.viewModel searchFlickrImageWithTerm:searchController.searchBar.text completion:^(BOOL finished, NSError *error) {
    [self.collectionNode reloadData];
  }];
  
  [self.collectionNode reloadData];
}

#pragma mark - ASCollectionDataSource

- (NSInteger)collectionNode:(ASCollectionNode *)collectionNode numberOfItemsInSection:(NSInteger)section
{
  return [self.viewModel numberOfImages];
}

- (NSInteger)numberOfSectionsInCollectionNode:(ASCollectionNode *)collectionNode
{
  return [self.viewModel numberOfSections];
}

- (ASCellNodeBlock)collectionNode:(ASCollectionNode *)collectionNode nodeBlockForItemAtIndexPath:(NSIndexPath *)indexPath
{
  RWLFlickrImage *image = [self.viewModel imageForIndexPath:indexPath];
  
  return ^{
    return [[RWLImageCellNode alloc] initWithImage:image];
  };
}

#pragma mark - ASCollectionDelegate

- (void)collectionNode:(ASCollectionNode *)collectionNode didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
  RWLFlickrImage *image = [self.viewModel imageForIndexPath:indexPath];
  
  RWLFlickrImageDetailViewController *detailViewController = [[RWLFlickrImageDetailViewController alloc] initWithImage:image];
  [self.self.parentViewController.presentingViewController.navigationController pushViewController:detailViewController animated:YES];
}

- (void)collectionNode:(ASCollectionNode *)collectionNode willBeginBatchFetchWithContext:(ASBatchContext *)context
{
  [self.viewModel pageResultsWithCompletion:^(NSArray<NSIndexPath *> *indexPaths) {
    [self.collectionNode performBatchAnimated:NO updates:^{
      [self.collectionNode insertItemsAtIndexPaths:indexPaths];
    } completion:^(BOOL finished) {
      [context completeBatchFetching:finished];
    }];
  }];
}

- (BOOL)shouldBatchFetchForCollectionNode:(ASCollectionNode *)collectionNode
{
  return [self.viewModel canPageMorePhotos];
}

@end
