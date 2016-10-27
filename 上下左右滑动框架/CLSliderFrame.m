//
//  CLSliderFrame.m
//  图片拉伸_Layer的contents相关属性
//
//  Created by AppleCheng on 16/8/1.
//  Copyright © 2016年 AppleCheng. All rights reserved.
//

#import "CLSliderFrame.h"

@interface CLSliderFrame () <UIScrollViewDelegate>
@property (nonatomic,strong) UIScrollView * titleScrollview;
@property (nonatomic,strong) UIScrollView * pageScrollview;
@property (nonatomic,strong) UIView * line;

@property (nonatomic,assign) CGFloat screenWidth;
@property (nonatomic,assign) CGFloat screenHeight;
@property (nonatomic,assign) CGFloat maxMoveDistance;

@property (nonatomic,assign) CGFloat labelW; //一个label的宽度
@property (nonatomic,assign) int pageLabelCount; //一个页面中需要现实的label
@property (nonatomic,assign) int allTitleCount; //全部的标题个数
@property (nonatomic,assign) CGFloat titleHeight; //标题的高度
@property (nonatomic,copy) NSArray * titlesArray;
@property (nonatomic,copy) NSArray * VCsArray;


@property (nonatomic,assign) int currentIndex;
@property (nonatomic,assign) int lastIndex;
@end

@implementation CLSliderFrame

-(void)basicPrepare{

    if (!_noSelectColor) {
        _noSelectColor =[UIColor blackColor];
    }
    if (!_selectedColor) {
        _selectedColor =[UIColor redColor];
    }
    if (!_titleFont) {
        _titleFont =[UIFont systemFontOfSize:14];
    }
    _titleHeight =40; //最高44
    _allTitleCount = (int)_titlesArray.count;
    _screenWidth =[UIScreen mainScreen].bounds.size.width;
    _screenHeight =self.view.frame.size.height;
    _labelW = _screenWidth/_pageLabelCount;
}

-(instancetype)initWithArray:(NSArray *)titles andVCs:(NSArray *)VCs andPageCounts:(int)pageCounts{
    self =[super init];
    if (self) {
        self.titlesArray = [titles copy];
        self.VCsArray =[VCs copy];
        _pageLabelCount = pageCounts ? pageCounts:4;
    }
    return self;
}

-(void)loadTItles{
    CGFloat untilNavHeight =_isInNavigation ? 64 :0;
    if (_isInNavigation) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    _titleScrollview =[[UIScrollView alloc] initWithFrame:CGRectMake(0, untilNavHeight,_screenWidth, 44)];
    _maxMoveDistance =(_allTitleCount - _pageLabelCount)*_labelW;
    _titleScrollview.contentSize =CGSizeMake(_allTitleCount*_labelW,0);
    _titleScrollview.backgroundColor =[UIColor whiteColor];
    _titleScrollview.bounces =NO;
    _titleScrollview.showsHorizontalScrollIndicator =NO;
    [self.view addSubview:_titleScrollview];
    for (int i = 0; i<_allTitleCount; i++) {
        CGFloat btnX = i* _labelW;
        UILabel * label =[[UILabel alloc] initWithFrame:CGRectMake(btnX, 0, _labelW, _titleHeight)];
        label.textAlignment =NSTextAlignmentCenter;
        label.backgroundColor =[UIColor whiteColor];
        label.text =_titlesArray[i];
        label.tag =1000+i;
        label.textColor =_noSelectColor;
        label.tag =1000+i;
        [_titleScrollview addSubview:label];
        UITapGestureRecognizer * tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickGesture:)];
        tap.numberOfTapsRequired =1;
        tap.numberOfTouchesRequired =1;
        label.userInteractionEnabled =YES;
        [label addGestureRecognizer:tap];
        if (i == 0) {
            label.textColor =_selectedColor;
            _currentIndex =0;
        }
    }
    [self loadLine];
}
-(void)loadLine{
    _line =[[UIView alloc] initWithFrame:CGRectMake(0, _titleHeight, _labelW, 3)];
    _line.backgroundColor =_selectedColor;
    [_titleScrollview addSubview:_line];
}
-(void)loadPageView{
    CGFloat pageY =CGRectGetMaxY(_titleScrollview.frame);
    CGFloat pageHeight =_screenHeight -pageY;
    _pageScrollview =[[UIScrollView alloc] initWithFrame:CGRectMake(0, pageY, _screenWidth, pageHeight)];
    _pageScrollview.contentSize =CGSizeMake(_screenWidth*_allTitleCount, 0);
    _pageScrollview.bounces =NO;
    _pageScrollview.pagingEnabled =YES;
    _pageScrollview.delegate =self;
    [self.view addSubview:_pageScrollview];
    int i =0;
    for (UIViewController * vc in _VCsArray) {
        [self addChildViewController:vc];
        UIView * vcView =vc.view;
        CGFloat vcViewX =i*_screenWidth;
        vcView.frame =CGRectMake(vcViewX, 0, _screenWidth, pageHeight);
        [_pageScrollview addSubview:vcView];
        i++;
    }
}
-(void)clickGesture:(UITapGestureRecognizer *)gesture{
    UILabel * label =(UILabel *)gesture.view;
    int index =(int)label.tag - 1000;
    [self clickAtindex:index];
    [self showPageviewAtIndex:index];
}
-(void)clickAtindex:(int)index{ //标题点击触发
    UILabel *  currentlabel =(UILabel *)[_titleScrollview viewWithTag:(index+1000)];
    _lastIndex =_currentIndex;
    UILabel  * lastlabel =(UILabel *)[_titleScrollview viewWithTag:(_lastIndex+1000)];
    lastlabel.textColor =_noSelectColor;
    _currentIndex = index;
    //CGFloat scrollX = (index-2)*_labelW + 0.5*_labelW;
    CGFloat scrollX =_labelW*(2*index-_pageLabelCount+1)/2; //最重要的公式
    if (scrollX < 0) {
        scrollX =0;
    }else if (scrollX >= _maxMoveDistance){
        scrollX =_maxMoveDistance;
    }
    currentlabel.textColor =_selectedColor;
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        _titleScrollview.contentOffset =CGPointMake(scrollX, 0);
       // _line.frame =CGRectMake(index*_labelW, _titleHeight, _labelW, 3);
    } completion:nil];
}
-(void)showPageviewAtIndex:(int)index{
    CGFloat pageViewX =index*_screenWidth;
    [_pageScrollview setContentOffset:CGPointMake(pageViewX, 0) animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self basicPrepare];
    [self loadTItles];
    [self loadPageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat x =scrollView.contentOffset.x;
    CGFloat lineX =x/_screenWidth*_labelW;
    _line.frame =CGRectMake(lineX, _titleHeight, _labelW, 3);
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat x =scrollView.contentOffset.x;
    int index =(int)x/_screenWidth;
    [self clickAtindex:index];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
