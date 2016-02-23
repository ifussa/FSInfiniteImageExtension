//
//  FSInfiniteScrollView.m
//  图片轮播器
//
//  Created by Fussa on 16/2/23.
//  Copyright © 2016年 fussa. All rights reserved.
//

#import "FSInfiniteImageView.h"

@interface FSInfiniteImageView ()<UIScrollViewDelegate>
/* 显示内容 */
@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, weak) UIScrollView *scrollView;
/* 定时器 */
@property (nonatomic, weak) NSTimer *timer;

@end

@implementation FSInfiniteImageView
/**
 *  一些默认值
 */
-(CGFloat)delayTime {
	if (_delayTime == 0) return 2.0;		//默认滚动间隔时间
	return _delayTime;
}
- (CGFloat)startDelayTime {
	if (_startDelayTime == 0) return 3.0;	//默认手放开停止滚动后,定时器开启的时间间隔
	return _startDelayTime;
}
-(CGFloat)duringTime {
	if (_duringTime == 0) return 1.0;		//默认从当前页滚动到一页的所用时间
	return _duringTime;
}

- (instancetype)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		
		//设置滚动的scrollView
		[self setupScrollView];
		
		//设置scrollView上面的图片
		[self setupImage];
		
		//设置PageControl
		[self setupPageControl];
		
		//开启定时器
		[self startTimer];
	}
	return self;
}

- (void)setImages:(NSArray<UIImage *> *)images {
	_images = images;
	self.pageControl.numberOfPages = images.count;
}

/**
 *  scrollView的创建和设置
 */
- (void)setupScrollView {
	
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    self.scrollView          = scrollView;
    scrollView.bounces       = NO;
    scrollView.delegate      = self;
    scrollView.pagingEnabled = YES;
	scrollView.showsVerticalScrollIndicator	  = NO;
	scrollView.showsHorizontalScrollIndicator = NO;
	[self addSubview:scrollView];
}
/**
 *  设置scrollView上面的图片
 */
- (void)setupImage {
	
	for (int i = 0; i < 3; i++) {
		UIImageView *imageView = [[UIImageView alloc] init];
		self.imageView         = imageView;
		imageView.userInteractionEnabled = YES;
		[imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewClick:)]];
		[self.scrollView addSubview:imageView];
	}
}
/**
 *  设置PageControl
 */
- (void)setupPageControl {
	
	UIPageControl *pageControl = [[UIPageControl alloc] init];
	self.pageImage = [UIImage imageNamed:@"FSInfiniteScrollView_other"];
	self.currentPageImage = [UIImage imageNamed:@"FSInfiniteScrollView_current"];
	[pageControl setValue:_pageImage forKeyPath:@"_pageImage"];
	[pageControl setValue:_currentPageImage forKeyPath:@"_currentPageImage"];
	self.pageControl = pageControl;
	[self addSubview:pageControl];
}

/**
 *  布局子控件
 */
- (void)layoutSubviews {
	[super layoutSubviews];
	
	CGFloat scrollViewW = self.bounds.size.width;
	CGFloat scrollViewH = self.bounds.size.height;
	
	//imageView
	for (NSInteger i = 0; i < 3; i++) {
		
		UIImageView *imageView = self.scrollView.subviews[i];
		if (self.direction == FSInfiniteScrollViewDirectionTypeHorizontal) {
			imageView.frame = CGRectMake(i *scrollViewW, 0 , scrollViewW, scrollViewH);
		}else {
			imageView.frame = CGRectMake(0, i *scrollViewH, scrollViewW, scrollViewH);
		}
	}
	
	//scrollView
	self.scrollView.frame = self.bounds;
	if (self.direction == FSInfiniteScrollViewDirectionTypeHorizontal) {
		self.scrollView.contentSize = CGSizeMake(scrollViewW * 3, 0);
	} else {
		self.scrollView.contentSize = CGSizeMake(0, scrollViewH * 3);
		
	}
	
	//pageView
	CGFloat pageControlW   = 150;
	CGFloat pageControlH   = 25;
	self.pageControl.frame = CGRectMake(scrollViewW - pageControlW, scrollViewH - pageControlH, pageControlW, pageControlH);


	[self updateContent];
}

#pragma mark - Timer

/**
 *  开启定时器
 */
- (void)startTimer {

	self.timer = [NSTimer scheduledTimerWithTimeInterval:self.delayTime target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
	NSLog(@"%f",self.delayTime);

	[[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

/**
 *  停止定时器
 */
- (void)stopTimer {
	[self.timer invalidate];
	self.timer = nil;
}

#pragma mark - Actions
/**
 *  更新数据
 */
- (void)updateContent {
	
	//当前页码
	NSInteger page = self.pageControl.currentPage;
	
	//更新UIImageview的内容
	for (NSInteger i = 0; i < 3; i++) {
		
		UIImageView *imageView = self.scrollView.subviews[i];
		//图片索引
		NSInteger index = 0;
		if (i == 0) {			//左边的imageView
			index = page - 1;
		} else if (i == 1) {	//中间的ImageView
			index = page;
		} else  {				//右边的ImageView
			index = page + 1;
		}
		
		//特殊情况处理, 防止越界
		if (index == -1) {
			index = self.images.count - 1;
		}else if (index == self.images.count) {
			index = 0;
		}
		
		//设置当前Image
		imageView.image = self.images[index];
		imageView.tag = index;
		
	}
	
	//每次的刷新重设scrollView的contentOffSet为一倍宽度
	if (self.direction == FSInfiniteScrollViewDirectionTypeHorizontal) {
		self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width, 0);
	} else {
		self.scrollView.contentOffset = CGPointMake(0, self.scrollView.frame.size.height);
	}
}

/**
 *  下一页
 */
- (void)nextPage {

	[UIView animateWithDuration:self.duringTime animations:^{
		if (self.direction == FSInfiniteScrollViewDirectionTypeHorizontal) {
			[self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x + self.scrollView.frame.size.width, 0)];;
		} else {
			[self.scrollView setContentOffset:CGPointMake(0, self.scrollView.contentOffset.y + self.scrollView.frame.size.height)];
		}
	}];
	[self updateContent];
	
}
/**
 *  点击了scrollView上面的图片会调用此方法
 */
- (void)imageViewClick:(UITapGestureRecognizer *)tap {
	
	//查看代理对象是否实现了该代理方法, 如果实现了, 则调用戴代理方法
	if ([self.delegate respondsToSelector:@selector(infiniteImageView:didSelectItemAtIndex:	)]) {
		[self.delegate infiniteImageView:self didSelectItemAtIndex:tap.view.tag];
	}
}

#pragma mark - UIScrollViewDelegate
/**
 *  只要滑动就会调用此方法, 实时更新pageControl的当前页
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	
	//求取显示在中间的ImageView
	UIImageView *destImageView = nil;
	CGFloat minDelta = MAXFLOAT;
	for (NSInteger i = 0; i < 3; i++) {
		UIImageView *imageView = self.scrollView.subviews[i];
		CGFloat delta = 0;
		if (self.direction == FSInfiniteScrollViewDirectionTypeHorizontal) {
			delta = ABS(self.scrollView.contentOffset.x - imageView.frame.origin.x);
		} else {
			delta = ABS(self.scrollView.contentOffset.y - imageView.frame.origin.y);
		}
		if (delta <= minDelta) {
			minDelta = delta;
			destImageView = imageView;
		}
	}
	//将显示在中间的ImageView赋给PageControl
	self.pageControl.currentPage = destImageView.tag;
}
/**
 *  开始拖拽的时候, 停止定时器
 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
	[self stopTimer];
}

/**
 *  scrollView停止滚动的时候调用此方法, 刷新内容
 */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
	[self updateContent];
}

/**
 *  scrollView减速完毕, 开启定时器, 刷新内容
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	
	[self updateContent];
	
	//手松开2秒之后, 开启定时器
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.startDelayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		[self startTimer];
	});
	
}


@end