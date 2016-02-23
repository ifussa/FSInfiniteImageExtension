//
//  ViewController.m
//  图片轮播器
//
//  Created by Fussa on 16/2/23.
//  Copyright © 2016年 fussa. All rights reserved.
//

#import "ViewController.h"
#import "FSInfiniteImageView.h"

@interface ViewController ()<FSInfiniteImageViewDelegate>
//@property (nonatomic, weak) FSInfiniteScrollView *infiniteScrollView;
@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
//	CGFloat screenH	= [UIScreen mainScreen].bounds.size.height;

	
	FSInfiniteImageView *infiniteScrollView = [[FSInfiniteImageView alloc] init];
	infiniteScrollView.images = @[
								  [UIImage imageNamed:@"FSInfiniteScrollView_img_01"],
								  [UIImage imageNamed:@"FSInfiniteScrollView_img_02"],
								  [UIImage imageNamed:@"FSInfiniteScrollView_img_03"],
								  [UIImage imageNamed:@"FSInfiniteScrollView_img_04"],
								  [UIImage imageNamed:@"FSInfiniteScrollView_img_05"]
								  ];
	infiniteScrollView.delegate = self;
	infiniteScrollView.direction = FSInfiniteScrollViewDirectionTypeHorizontal;
	infiniteScrollView.delayTime = 3.0;
	infiniteScrollView.startDelayTime = 1.0;
	infiniteScrollView.duringTime = 1.0;
	
	CGFloat infiniteScrollViewW = screenW;
	CGFloat infiniteScrollViewH = 260 * screenW / 600;
	infiniteScrollView.frame = CGRectMake(0, 0, infiniteScrollViewW , infiniteScrollViewH);
//	self.infiniteScrollView = infiniteScrollView;

//	NSMutableArray *imageArray = [NSMutableArray array];
//	for (int i = 0; i < imageCount; i++) {
//		UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"img_0%d", i+1]];
//		[imageArray addObject:image];
//	}
//	infiniteScrollView.images = imageArray;
	
	[self.view addSubview:infiniteScrollView];
	
	
}


#pragma mark -  FSInfiniteScrollViewDelegate
- (void)infiniteImageView:(FSInfiniteImageView *)scrollView didSelectItemAtIndex:(NSInteger)index{
	NSLog(@"%zd",index);

}


@end
