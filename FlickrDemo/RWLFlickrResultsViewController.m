//
//  RWLFlickrResultsViewController.m
//  FlickrDemo
//
//  Created by Bob Law on 8/8/17.
//  Copyright © 2017 Bob Law. All rights reserved.
//

#import "RWLFlickrResultsViewController.h"
#import "RWLFlickrImageDetailViewController.h"
#import "RWLFlickrResultHistory.h"
#import "RWLImageCellNode.h"
#import "RWLFlickrSearchViewModel.h"
#import "RWLFlickrService.h"

static NSString *const RWLSearchThrottleTimerSearchTermKey = @"searchTerm";

@interface RWLFlickrResultsViewController () <ASCollectionDataSource, ASCollectionDelegate>

@property (nonatomic, strong) RWLFlickrService *flickrService;

@property (nonatomic, strong) ASCollectionNode *collectionNode;

@property (nonatomic, strong) RWLFlickrSearchViewModel *viewModel;

@property (nonatomic, strong) RWLFlickrResultHistory *resultHistory;

@property (nonatomic, strong) NSTimer *searchThrottleTimer;

@end

@implementation RWLFlickrResultsViewController

- (instancetype)initWithFlickrService:(RWLFlickrService *)flickrService flickrResultHistory:(RWLFlickrResultHistory *)resultHistory
{
  UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
  CGFloat width = [UIScreen mainScreen].bounds.size.width;
  flowLayout.minimumLineSpacing = 1;
  flowLayout.minimumInteritemSpacing = 1;
  flowLayout.itemSize = CGSizeMake(width / 3 - 1, width / 3 - 1);
  flowLayout.sectionInset = UIEdgeInsetsMake(1, 0, 1, 0);
  
  _collectionNode = [[ASCollectionNode alloc] initWithCollectionViewLayout:flowLayout];
  
  if (self = [super initWithNode:_collectionNode]) {
    _flickrService = flickrService;
    _resultHistory = resultHistory;
    
    _viewModel = [[RWLFlickrSearchViewModel alloc] initWithFlickrService:flickrService];
    
    _collectionNode.delegate = self;
    _collectionNode.dataSource = self;
  }
  
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];

  [self setupNotifications];
}

- (void)setupNotifications
{
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillTerminateNotification:) name:UIApplicationWillTerminateNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackgroundNotification:) name:UIApplicationDidEnterBackgroundNotification object:nil];
}

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
  NSString *searchTerm = searchController.searchBar.text;
  
  if (![searchTerm isEqualToString:self.viewModel.currentSearchTerm]) {
    
    if (self.searchThrottleTimer) {
      [self.searchThrottleTimer invalidate];
      self.searchThrottleTimer = nil;
    }
    
    self.searchThrottleTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(searchThrottleTimerTicked:) userInfo:@{RWLSearchThrottleTimerSearchTermKey:searchTerm} repeats:NO];
  }
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
  [self.parentViewController.presentingViewController.navigationController pushViewController:detailViewController animated:YES];
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

#pragma mark - NSNotifications

- (void)applicationWillTerminateNotification:(NSNotification *)notification
{
  [self saveCurrentImageResults];
}

- (void)applicationDidEnterBackgroundNotification:(NSNotification *)notification
{
  [self saveCurrentImageResults];
}

#pragma mark - Timer Call

- (void)searchThrottleTimerTicked:(NSTimer *)timer
{
  NSString *searchTerm = timer.userInfo[RWLSearchThrottleTimerSearchTermKey];
  
  [self saveCurrentImageResults];
  
  [self.viewModel searchFlickrImageWithTerm:searchTerm completion:^(BOOL finished, NSError *error) {
    [self.collectionNode reloadData];
  }];
  
  [self.collectionNode reloadData];
  
  [timer invalidate];
  timer = nil;
}

#pragma mark - Convenience Methods

- (void)saveCurrentImageResults
{
  NSArray *currentImageResults = [self.viewModel getCurrentImageResults];
  
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    [self.resultHistory saveFlickrImages:currentImageResults];
  });
}

@end
