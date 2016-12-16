//
//  TYTabPagerController.m
//
//  Created by tanyang on 16/5/3.
//  Copyright © 2016年 tanyang. All rights reserved.
//

#import "TYTabPagerController.h"

@interface TYTabPagerController ()<UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>
{
    struct {
        unsigned int titleForIndex :1;
    }_tabDataSourceFlags;
    
    struct {
        unsigned int configreReusableCell :1;
        unsigned int didSelectAtIndexPath :1;
        unsigned int didScrollToTabPageIndex :1;
        unsigned int transitionFromeCellAnimated :1;
        unsigned int transitionFromeCellProgress :1;
    }_tabDelegateFlags;
}

// views
@property (nonatomic, weak) UIView *pagerBarView;
@property (nonatomic, weak) UICollectionView *collectionViewBar;
@property (nonatomic, weak) UIView *progressView;

@property (nonatomic ,assign) Class cellClass;
@property (nonatomic ,assign) BOOL cellContainXib;
@property (nonatomic ,strong) NSString *cellId;

@end

#define kCollectionViewBarHieght 36
#define kUnderLineViewHeight 2

@implementation TYTabPagerController

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self configireTabPropertys];
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        [self configireTabPropertys];
    }
    return self;
}

- (void)configireTabPropertys
{
    _animateDuration = 0.25;
    _barStyle = TYPagerBarStyleProgressView;
    
    _normalTextFont = [UIFont systemFontOfSize:15];
    _selectedTextFont = [UIFont systemFontOfSize:18];
    
    _cellSpacing = 0;
    _cellEdging = 0;
    
    _progressHeight = kUnderLineViewHeight;
    _progressEdging = 0;
    _progressWidth = 0;
    
    self.changeIndexWhenScrollProgress = 1.0;
    self.contentTopEdging = kCollectionViewBarHieght;
}

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // add pager bar
    [self addPagerBarView];
    
    // add title views
    [self addCollectionViewBar];
    
    // add progress view
    [self addUnderLineView];
    
//    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
//    NSLayoutConstraint* left = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeLeftMargin relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeftMargin multiplier:1.0 constant:0];
//    NSLayoutConstraint* right = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeRightMargin relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRightMargin multiplier:1.0 constant:0];
//    NSLayoutConstraint* top = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeTopMargin relatedBy:NSLayoutRelationEqual toItem:_pagerBarView attribute:NSLayoutAttributeBottomMargin multiplier:1.0 constant:0];
//    NSLayoutConstraint* bottom = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeBottomMargin relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottomMargin multiplier:1.0 constant:0];
//    
//    [NSLayoutConstraint activateConstraints:@[left,right,bottom,top]];
}

- (void)addPagerBarView
{
    UIView *pagerBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), self.contentTopEdging)];
    [self.view addSubview:pagerBarView];
    _pagerBarView = pagerBarView;
    
//    _pagerBarView.translatesAutoresizingMaskIntoConstraints = NO;
//    NSLayoutConstraint* left = [NSLayoutConstraint constraintWithItem:_pagerBarView attribute:NSLayoutAttributeLeftMargin relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeftMargin multiplier:1.0 constant:0];
//    
//    NSLayoutConstraint* right = [NSLayoutConstraint constraintWithItem:_pagerBarView attribute:NSLayoutAttributeRightMargin relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRightMargin multiplier:1.0 constant:0];
//    
//    NSLayoutConstraint* top = [NSLayoutConstraint constraintWithItem:_pagerBarView attribute:NSLayoutAttributeTopMargin relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTopMargin multiplier:1.0 constant:0];
//    
//    NSLayoutConstraint* height = [NSLayoutConstraint constraintWithItem:_pagerBarView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.contentTopEdging ];
//    
//    [NSLayoutConstraint activateConstraints:@[left,right,top,height]];
}

- (void)addCollectionViewBar
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), self.contentTopEdging) collectionViewLayout:layout];
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.contentInset = UIEdgeInsetsMake(0, 20, 0, 20);
    
    [_pagerBarView addSubview:collectionView];
    _collectionViewBar = collectionView;
    
    if (_cellContainXib) {
        UINib *nib = [UINib nibWithNibName:_cellId bundle:nil];
        [collectionView registerNib:nib forCellWithReuseIdentifier:_cellId];
    }else {
        [collectionView registerClass:_cellClass forCellWithReuseIdentifier:_cellId];
    }
    
     [self addMoreButton];
    
//    _collectionViewBar.translatesAutoresizingMaskIntoConstraints = NO;
//    NSLayoutConstraint* left = [NSLayoutConstraint constraintWithItem:_collectionViewBar attribute:NSLayoutAttributeLeadingMargin relatedBy:NSLayoutRelationEqual toItem:_pagerBarView attribute:NSLayoutAttributeLeadingMargin multiplier:1.0 constant:0];
//    
//    NSLayoutConstraint* right = [NSLayoutConstraint constraintWithItem:_collectionViewBar attribute:NSLayoutAttributeTrailingMargin relatedBy:NSLayoutRelationEqual toItem:_moreButton attribute:NSLayoutAttributeLeadingMargin multiplier:1.0 constant:0];
//    
//    NSLayoutConstraint* centerY = [NSLayoutConstraint constraintWithItem:_collectionViewBar attribute:NSLayoutAttributeCenterYWithinMargins relatedBy:NSLayoutRelationEqual toItem:_pagerBarView attribute:NSLayoutAttributeCenterYWithinMargins multiplier:1.0 constant:0];
//    
//    NSLayoutConstraint* height = [NSLayoutConstraint constraintWithItem:_collectionViewBar attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_pagerBarView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0];
//    [NSLayoutConstraint activateConstraints:@[left,centerY,right ,height]];
    
   
}

/**********************************************************/
- (void)addMoreButton{
    
//    UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame)-50, [self statusBarHeight], 50, self.contentTopEdging)];
//    [button setImage:[UIImage imageNamed:@"button_more_n"] forState:UIControlStateNormal];
//    [button setImage:[UIImage imageNamed:@"button_more_h"] forState:UIControlStateHighlighted];
//    [button setBackgroundColor:[UIColor clearColor]];
//    
//    [_pagerBarView addSubview:button];
//    
//    _moreButton = button;
//    
//    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
//    _moreButton.translatesAutoresizingMaskIntoConstraints = NO;
//    NSLayoutConstraint* right = [NSLayoutConstraint constraintWithItem:_moreButton attribute:NSLayoutAttributeRightMargin relatedBy:NSLayoutRelationEqual toItem:_pagerBarView attribute:NSLayoutAttributeRightMargin multiplier:1.0 constant:0];
//    NSLayoutConstraint* centerY = [NSLayoutConstraint constraintWithItem:_moreButton attribute:NSLayoutAttributeCenterYWithinMargins relatedBy:NSLayoutRelationEqual toItem:_pagerBarView attribute:NSLayoutAttributeCenterYWithinMargins multiplier:1.0 constant:0];
//    
//    NSLayoutConstraint* width = [NSLayoutConstraint constraintWithItem:_moreButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationLessThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:80];
//    
//    [NSLayoutConstraint activateConstraints:@[right,centerY,width]];
    
}

- (void)buttonClicked:(UIButton*)sender{
    if ([self.delegate respondsToSelector:@selector(pagerController:didSelectMoreButton:)]){
        [self.delegate pagerController:self didSelectMoreButton:sender];
    }
}

/**********************************************************/

- (void)addUnderLineView
{
    UIView *underLineView = [[UIView alloc]init];
    underLineView.hidden = (_barStyle == TYPagerBarStyleNoneView);
    if (_barStyle != TYPagerBarStyleCoverView) {
        [_collectionViewBar addSubview:underLineView];
    }else{
        underLineView.layer.zPosition = -1;
        [_collectionViewBar insertSubview:underLineView atIndex:0];
    }
    _progressView = underLineView;
}

#pragma mark - setter

- (void)setBarStyle:(TYPagerBarStyle)barStyle
{
    _barStyle = barStyle;
    _progressView.hidden = (_barStyle == TYPagerBarStyleNoneView);
}

- (void)setDelegate:(id<TYTabPagerControllerDelegate>)delegate
{
    [super setDelegate:delegate];
    _tabDelegateFlags.configreReusableCell = [self.delegate respondsToSelector:@selector(pagerController:configreCell:forItemTitle:atIndexPath:)];
    _tabDelegateFlags.didSelectAtIndexPath = [self.delegate respondsToSelector:@selector(pagerController:didSelectAtIndexPath:)];
    _tabDelegateFlags.didScrollToTabPageIndex = [self.delegate respondsToSelector:@selector(pagerController:didScrollToTabPageIndex:)];
    _tabDelegateFlags.transitionFromeCellAnimated = [self.delegate respondsToSelector:@selector(pagerController:transitionFromeCell:toCell:animated:)];
    _tabDelegateFlags.transitionFromeCellProgress = [self.delegate respondsToSelector:@selector(pagerController:transitionFromeCell:toCell:progress:)];
}

- (void)setDataSource:(id<TYPagerControllerDataSource>)dataSource
{
    [super setDataSource:dataSource];
    
    _tabDataSourceFlags.titleForIndex = [self.dataSource respondsToSelector:@selector(pagerController:titleForIndex:)];
    NSAssert(_tabDataSourceFlags.titleForIndex, @"TYPagerControllerDataSource pagerController:titleForIndex: not impletement!");
}

#pragma mark - public

- (void)reloadData
{
    [_collectionViewBar reloadData];
    
    [super reloadData];
}

// update tab subviews frame
- (void)updateContentView
{
    [super updateContentView];
    
    [self layoutTabPagerView];
    
    [self setUnderLineFrameWithIndex:self.curIndex animated:NO];
    
    [self tabScrollToIndex:self.curIndex animated:NO];
}

- (void)registerCellClass:(Class)cellClass isContainXib:(BOOL)isContainXib
{
    _cellClass = cellClass;
    _cellId = NSStringFromClass(cellClass);
    _cellContainXib = isContainXib;
}

- (CGRect)cellFrameWithIndex:(NSInteger)index
{
    if (index >= self.countOfControllers) {
        return CGRectZero;
    }
    UICollectionViewLayoutAttributes * cellAttrs = [_collectionViewBar layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
    return cellAttrs.frame;
}

- (UICollectionViewCell *)cellForIndex:(NSInteger)index
{
    if (index >= self.countOfControllers) {
        return nil;
    }
    return [_collectionViewBar cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
}

- (void)tabScrollToIndex:(NSInteger)index animated:(BOOL)animated
{
    if (_tabDelegateFlags.didScrollToTabPageIndex) {
        [self.delegate pagerController:self didScrollToTabPageIndex:index];
    }
    
    if (index < self.countOfControllers) {
        [_collectionViewBar scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:animated];
    }
}

#pragma mark - private

// layout tab view
- (void)layoutTabPagerView
{
    ((UICollectionViewFlowLayout *)_collectionViewBar.collectionViewLayout).minimumLineSpacing = _cellSpacing;
    CGFloat collectionViewEaging = _barStyle != TYPagerBarStyleCoverView ? _collectionLayoutEdging : (_collectionLayoutEdging > 0 ? _collectionLayoutEdging : -_progressEdging+_cellSpacing);
    ((UICollectionViewFlowLayout *)self.collectionViewBar.collectionViewLayout).sectionInset = UIEdgeInsetsMake(0, collectionViewEaging, 0, collectionViewEaging);
    
    _pagerBarView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), self.contentTopEdging+[self statusBarHeight]);
    
    _collectionViewBar.frame = CGRectMake(0, [self statusBarHeight], CGRectGetWidth(self.view.frame), self.contentTopEdging);
//    _moreButton.frame = CGRectMake(CGRectGetWidth(self.view.frame)-50, [self statusBarHeight], 50, self.contentTopEdging);
}

// set up progress view frame
- (void)setUnderLineFrameWithIndex:(NSInteger)index animated:(BOOL)animated
{
    if (_progressView.isHidden || self.countOfControllers == 0) {
        return;
    }
    
    CGRect cellFrame = [self cellFrameWithIndex:index];
    CGFloat progressEdging = _progressWidth > 0 ? (cellFrame.size.width - _progressWidth)/2 : _progressEdging;
    CGFloat progressX = cellFrame.origin.x+progressEdging;
    CGFloat progressY = _barStyle == TYPagerBarStyleCoverView ? (cellFrame.size.height - _progressHeight)/2:(cellFrame.size.height - _progressHeight);
    CGFloat width = cellFrame.size.width-2*progressEdging;
    
    if (animated) {
        [UIView animateWithDuration:_animateDuration animations:^{
            _progressView.frame = CGRectMake(progressX, progressY, width, _progressHeight);
        }];
    }else {
        _progressView.frame = CGRectMake(progressX, progressY, width, _progressHeight);
    }
}

- (void)setUnderLineFrameWithfromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(CGFloat)progress
{
    if (_progressView.isHidden || self.countOfControllers == 0) {
        return;
    }
    
    CGRect fromCellFrame = [self cellFrameWithIndex:fromIndex];
    CGRect toCellFrame = [self cellFrameWithIndex:toIndex];
    
    CGFloat progressFromEdging = _progressWidth > 0 ? (fromCellFrame.size.width - _progressWidth)/2 : _progressEdging;
    CGFloat progressToEdging = _progressWidth > 0 ? (toCellFrame.size.width - _progressWidth)/2 : _progressEdging;
    CGFloat progressY = _barStyle == TYPagerBarStyleCoverView ? (toCellFrame.size.height - _progressHeight)/2:(toCellFrame.size.height - _progressHeight);
    CGFloat progressX, width;
    
    if (_barStyle == TYPagerBarStyleProgressBounceView) {
        if (fromCellFrame.origin.x < toCellFrame.origin.x) {
            if (progress <= 0.5) {
                progressX = fromCellFrame.origin.x + progressFromEdging;
                width = (toCellFrame.size.width-progressToEdging+progressFromEdging+_cellSpacing)*2*progress + fromCellFrame.size.width-2*progressFromEdging;
            }else {
                progressX = fromCellFrame.origin.x + progressFromEdging + (fromCellFrame.size.width-progressFromEdging+progressToEdging+_cellSpacing)*(progress-0.5)*2;
                width = CGRectGetMaxX(toCellFrame)-progressToEdging - progressX;
            }
        }else {
            if (progress <= 0.5) {
                progressX = fromCellFrame.origin.x + progressFromEdging - (toCellFrame.size.width-progressToEdging+progressFromEdging+_cellSpacing)*2*progress;
                width = CGRectGetMaxX(fromCellFrame) - progressFromEdging - progressX;
            }else {
                progressX = toCellFrame.origin.x + progressToEdging;
                width = (fromCellFrame.size.width-progressFromEdging+progressToEdging + _cellSpacing)*(1-progress)*2 + toCellFrame.size.width - 2*progressToEdging;
            }
        }
    }else {
        progressX = (toCellFrame.origin.x+progressToEdging-(fromCellFrame.origin.x+progressFromEdging))*progress+fromCellFrame.origin.x+progressFromEdging;
        width = (toCellFrame.size.width-2*progressToEdging)*progress + (fromCellFrame.size.width-2*progressFromEdging)*(1-progress);
    }
    
    _progressView.frame = CGRectMake(progressX,progressY, width, _progressHeight);
}

#pragma mark - override transition

- (void)transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex animated:(BOOL)animated
{
    UICollectionViewCell *fromCell = [self cellForIndex:fromIndex];
    UICollectionViewCell *toCell = [self cellForIndex:toIndex];
    
    if (![self isProgressScrollEnabel]) {
        // if isn't progressing
        if (_tabDelegateFlags.transitionFromeCellAnimated) {
            [self.delegate pagerController:self transitionFromeCell:fromCell toCell:toCell animated:animated];
        }
        
        [self setUnderLineFrameWithIndex:toIndex animated:fromCell && animated ? animated: NO];
    }
    
    [self tabScrollToIndex:toIndex animated:toCell ? YES : fromCell && animated ? animated: NO];
}

- (void)transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(CGFloat)progress
{
    UICollectionViewCell *fromCell = [self cellForIndex:fromIndex];
    UICollectionViewCell *toCell = [self cellForIndex:toIndex];
    
    if (_tabDelegateFlags.transitionFromeCellProgress) {
        [self.delegate pagerController:self transitionFromeCell:fromCell toCell:toCell progress:progress];
    }
    
    [self setUnderLineFrameWithfromIndex:fromIndex toIndex:toIndex progress:progress];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.dataSource numberOfControllersInPagerController];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:_cellId forIndexPath:indexPath];
    
    if (_tabDataSourceFlags.titleForIndex) {
        NSString *title = [self.dataSource pagerController:self titleForIndex:indexPath.item];
        if (_tabDelegateFlags.configreReusableCell) {
            [self.delegate pagerController:self configreCell:cell forItemTitle:title atIndexPath:indexPath];
        }
        if (_tabDelegateFlags.transitionFromeCellAnimated) {
            [self.delegate pagerController:self transitionFromeCell:(indexPath.item == self.curIndex ? nil : cell) toCell:(indexPath.item == self.curIndex ? cell : nil) animated:NO];
        }
    }
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self moveToControllerAtIndex:indexPath.item animated:YES];
    if (_tabDelegateFlags.didSelectAtIndexPath) {
        [self.delegate pagerController:self didSelectAtIndexPath:indexPath];
    }
}
// zhj 计算上面那一菜单栏 的宽度 和高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_cellWidth > 0) {
        return CGSizeMake(_cellWidth, CGRectGetHeight(_collectionViewBar.frame));
    }else if(_tabDataSourceFlags.titleForIndex){
        NSString *title = [self.dataSource pagerController:self titleForIndex:indexPath.item];
        CGFloat width = [self boundingSizeWithString:title font:_selectedTextFont constrainedToSize:CGSizeMake(300, 100)].width+_cellEdging*2;
        return CGSizeMake(width, CGRectGetHeight(_collectionViewBar.frame));
    }
    return CGSizeZero;
}

// text size
- (CGSize)boundingSizeWithString:(NSString *)string font:(UIFont *)font constrainedToSize:(CGSize)size
{
    CGSize textSize = CGSizeZero;
    
#if (__IPHONE_OS_VERSION_MIN_REQUIRED && __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0)
    
    if (![string respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        // below ios7
        textSize = [string sizeWithFont:font
                      constrainedToSize:size
                          lineBreakMode:NSLineBreakByWordWrapping];
    }
    else
#endif
    {
        //iOS 7
        CGRect frame = [string boundingRectWithSize:size options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{ NSFontAttributeName:font } context:nil];
        textSize = CGSizeMake(frame.size.width, frame.size.height + 1);
    }
    
    return textSize;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
