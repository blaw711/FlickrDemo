//
//  RWLImageCellNode.m
//  FlickrDemo
//
//  Created by Bob Law on 8/8/17.
//  Copyright © 2017 Bob Law. All rights reserved.
//

#import "RWLImageCellNode.h"
#import "RWLFlickrImage.h"

@implementation RWLImageCellNode
{
  ASNetworkImageNode *_networkImageNode;
  ASDisplayNode *_highlightNode;
  
  RWLFlickrImage *_flickrImage;
}

- (instancetype)initWithImage:(RWLFlickrImage *)image
{
  if (self = [super init]) {
    self.automaticallyManagesSubnodes = YES;
    
    _flickrImage = image;
    
    _networkImageNode = [ASNetworkImageNode new];
    _networkImageNode.backgroundColor = ASDisplayNodeDefaultPlaceholderColor();
    
    _highlightNode = [ASDisplayNode new];
    _highlightNode.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.2];
  }
  
  return self;
}

- (void)didEnterPreloadState
{
  [super didEnterPreloadState];
  
  _networkImageNode.URL = _flickrImage.smallURL;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize
{
  ASLayoutSpec *layoutSpec = [ASRelativeLayoutSpec relativePositionLayoutSpecWithHorizontalPosition:ASRelativeLayoutSpecPositionStart verticalPosition:ASRelativeLayoutSpecPositionStart sizingOption:ASRelativeLayoutSpecSizingOptionDefault child:_networkImageNode];
  
  if (self.isHighlighted) {
    layoutSpec = [ASOverlayLayoutSpec overlayLayoutSpecWithChild:layoutSpec overlay:_highlightNode];
  }
  
  return layoutSpec;
}

- (void)animateLayoutTransition:(id<ASContextTransitioning>)context
{
  _highlightNode.alpha = !self.isHighlighted;
  
  [UIView animateWithDuration:0.1 animations:^{
    _highlightNode.alpha = self.isHighlighted;
  } completion:^(BOOL finished) {
    [context completeTransition:finished];
  }];
}

- (void)setHighlighted:(BOOL)highlighted
{
  [super setHighlighted:highlighted];
  
  [self transitionLayoutWithAnimation:YES shouldMeasureAsync:YES measurementCompletion:^{
    [self setNeedsLayout];
  }];
}


@end
