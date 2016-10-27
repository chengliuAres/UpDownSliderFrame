//
//  CLSliderFrame.h
//  图片拉伸_Layer的contents相关属性
//
//  Created by AppleCheng on 16/8/1.
//  Copyright © 2016年 AppleCheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLSliderFrame : UIViewController
@property (nonatomic,strong) UIColor * noSelectColor;
@property (nonatomic,strong) UIColor * selectedColor;
@property (nonatomic,strong) UIFont * titleFont;
@property (nonatomic,assign) BOOL  isInNavigation; //改导航页面是否在UINavigation下面
//一个页面中 标题的数组 VC的数组 已经一个页面中要显示title的个数
-(instancetype)initWithArray:(NSArray *)titles andVCs:(NSArray *)VCs andPageCounts:(int)pageCounts;

@end
