//
//  Cell.h
//  上下左右滑动框架
//
//  Created by AppleCheng on 16/9/21.
//  Copyright © 2016年 AppleCheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDAutoLayout/SDAutoLayout.h"

@interface Cell : UITableViewCell
@property (nonatomic,strong) UIImageView * imgView;
@property (nonatomic,copy) NSArray * strArr;
@end
