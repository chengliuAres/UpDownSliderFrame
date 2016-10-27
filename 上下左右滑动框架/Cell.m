//
//  Cell.m
//  上下左右滑动框架
//
//  Created by AppleCheng on 16/9/21.
//  Copyright © 2016年 AppleCheng. All rights reserved.
//

#import "Cell.h"
@interface Cell()
@property (nonatomic,strong) UILabel * title;
@property (nonatomic,strong) UILabel * content;
@end
@implementation Cell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self =[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _imgView =[[UIImageView alloc] init];
        [self.contentView addSubview:_imgView];
        _title =[[UILabel alloc] init];
        _title.font =[UIFont systemFontOfSize:20];
        _title.textColor =[UIColor redColor];
        [self.contentView addSubview:_title];
        
        _content =[[UILabel alloc] init];
        _content.font =[UIFont systemFontOfSize:14];
        //content.numberOfLines =0;
        _content.lineBreakMode =NSLineBreakByWordWrapping;
        [self.contentView addSubview:_content];
        
        UIView * line =[[UIView alloc] init];
        line.backgroundColor =[UIColor grayColor];
        [self.contentView addSubview:line];
        
        _imgView.sd_layout.topSpaceToView(self.contentView,10).leftSpaceToView(self.contentView,10).heightIs(60).widthIs(60);

        _title.sd_layout.topSpaceToView(self.contentView,10).leftSpaceToView(_imgView,10).rightSpaceToView(self.contentView,10).heightIs(30);
        _content.sd_layout.topSpaceToView(_title,0).leftSpaceToView(_imgView,10).rightSpaceToView(self.contentView,10).autoHeightRatio(0);
        line.sd_layout.topSpaceToView(_content,10).leftSpaceToView(self.contentView,10).rightSpaceToView(self.contentView,10).heightIs(1);
        [self setupAutoHeightWithBottomView:line bottomMargin:10];
        
    }
    return self;
}
-(void)setStrArr:(NSArray *)strArr{
    if (strArr.count > 1) {
        _title.text = strArr[0];
        _content.text = strArr[1];
      
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
