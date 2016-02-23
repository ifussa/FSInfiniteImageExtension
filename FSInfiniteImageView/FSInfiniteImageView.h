//
//  FSInfiniteScrollView.h
//  图片轮播器
//
//  Created by Fussa on 16/2/23.
//  Copyright © 2016年 fussa. All rights reserved.
//

#import <UIKit/UIKit.h>
@class  FSInfiniteImageView;

@protocol FSInfiniteImageViewDelegate <NSObject>

 @optional
- (void)infiniteImageView:(FSInfiniteImageView *)scrollView didSelectItemAtIndex:(NSInteger)index;
@end
typedef NS_ENUM(NSInteger, FSInfiniteScrollViewDirectionType) {
	/* 水平滚动 */
	FSInfiniteScrollViewDirectionTypeHorizontal  = 0,
	/* 垂直滚动 */
	FSInfiniteScrollViewDirectionTypeVertical
};

@interface FSInfiniteImageView : UIView
/* 图片数组, 用于保存播放器的图片 */
@property (nonatomic, strong) NSArray<UIImage *> *images;
/* 遵守代理, 实现一些代理方法 */
@property (nonatomic, weak) id<FSInfiniteImageViewDelegate> delegate;
/* 滚动方法 */
@property (nonatomic, assign) FSInfiniteScrollViewDirectionType direction;
/* 从当前页滚动到一页的所用时间 */
@property (nonatomic, assign) CGFloat duringTime;
/* 滚动间隔时间 */
@property (nonatomic, assign) CGFloat delayTime;
/* 从手放开停止滚动后,定时器开启的时间间隔 */
@property (nonatomic, assign) CGFloat startDelayTime;
/* 当前页得到角标图片 */
@property (nonatomic, weak) UIImage *pageImage;
/* 下一页得到角标图片 */
@property (nonatomic, weak) UIImage *currentPageImage;
/* 页码显示 */
@property (nonatomic, weak) UIPageControl *pageControl;

@end
