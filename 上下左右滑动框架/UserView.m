//
//  UserView.m
//  上下左右滑动框架
//
//  Created by AppleCheng on 16/9/22.
//  Copyright © 2016年 AppleCheng. All rights reserved.
//

#import "UserView.h"
#import "SDAutoLayout/SDAutoLayout.h"
@interface UserView() <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) UIVisualEffectView * effectView;
@end
@implementation UserView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addUI];
        [self addTable];
    }
    return self;
}
-(void)addUI{
    self.backgroundColor =[UIColor clearColor];
    UIBlurEffect *blurEffect =[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    _effectView =[[UIVisualEffectView alloc] initWithEffect:blurEffect];
    _effectView.frame =self.bounds;
    _effectView.alpha =1.0;
    [self addSubview:_effectView];
    
    UIImageView * userPhoto =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"user.jpg"]];
    userPhoto.frame =CGRectMake(0, 0, 100, 100);
    userPhoto.center = CGPointMake(self.frame.size.width/2, 100);
    [_effectView addSubview:userPhoto];
    [self addCorner:userPhoto];
    _userPhoto =userPhoto;
    
}
-(void)addTable{
    _tableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 100 , 100) style:UITableViewStylePlain];
    _tableView.dataSource =self;
    _tableView.delegate =self;
    _tableView.scrollEnabled =NO;
    _tableView.backgroundColor =[UIColor clearColor];
    _tableView.separatorStyle =UITableViewCellSeparatorStyleNone;
    [_effectView addSubview:_tableView ];
    _tableView.sd_layout.topSpaceToView(_userPhoto,50).leftSpaceToView(_effectView,25).rightSpaceToView(_effectView,5).bottomSpaceToView(_effectView,5);
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _titleArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    cell.textLabel.text =_titleArray[indexPath.row];
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    cell.backgroundColor =[UIColor clearColor];
    return cell;
}
-(void)addCorner:(UIView *)view{
    CGRect rect = view.bounds;
    CGSize size =CGSizeMake(view.frame.size.width/2, view.frame.size.width/2);
    UIRectCorner corner =UIRectCornerAllCorners;
    UIBezierPath *path =[UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corner cornerRadii:size];
    CAShapeLayer * mask =[CAShapeLayer layer];
    mask.frame = view.bounds;
    mask.path = path.CGPath;
    view.layer.mask = mask;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
