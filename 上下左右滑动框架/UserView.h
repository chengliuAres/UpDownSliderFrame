//
//  UserView.h
//  上下左右滑动框架
//
//  Created by AppleCheng on 16/9/22.
//  Copyright © 2016年 AppleCheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserView : UIView
@property (nonatomic,assign) BOOL isShow;
@property (nonatomic,weak) UIImageView * userPhoto;
@property (nonatomic,copy) NSArray * titleArray;
-(instancetype)initWithFrame:(CGRect)frame;
@end
