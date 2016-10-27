//
//  TableVC.h
//  上下左右滑动框架
//
//  Created by AppleCheng on 16/9/21.
//  Copyright © 2016年 AppleCheng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ScrollEvent)(UIScrollView * scrollView);
@interface TableVC : UITableViewController

@property (nonatomic,copy) ScrollEvent scrollViewDidScroll;
@property (nonatomic,copy) ScrollEvent scrollViewEndDrag;
@end
