//
//  CLUpDownScrollVC.m
//  上下左右滑动框架
//
//  Created by AppleCheng on 16/9/21.
//  Copyright © 2016年 AppleCheng. All rights reserved.
//

#import "CLUpDownScrollVC.h"
#import "CLSliderFrame.h"
#import "SDAutoLayout/SDAutoLayout.h"
#import "TableVC.h"
#import "POP.h"
#import "iCarousel.h"
#import "UINavigationBar+bgColor.h"
#import "UserView.h"
#define  MAXWidth  [UIScreen mainScreen].bounds.size.width
#define  MAXHeight  [UIScreen mainScreen].bounds.size.height
@interface CLUpDownScrollVC () <iCarouselDelegate,iCarouselDataSource>

@property (nonatomic,strong) __block UIView * headerView;
@property (nonatomic,weak) UIView * contentView;
@property (nonatomic,assign) CGFloat headHeight;
@property (nonatomic,strong) NSArray * itemArr;
@property (nonatomic,strong) iCarousel * carousel;
@property (nonatomic,strong) NSTimer * timer;
@property (nonatomic,strong) UIPageControl * pageControl;
@property (nonatomic,strong) UserView * userView;
@end

@implementation CLUpDownScrollVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor]}];
    //self.title=@"首页";
    UIColor * white =[[UIColor whiteColor] colorWithAlphaComponent:0];
    [self.navigationController.navigationBar alphaNavigationBarView:white];
    _headHeight =200;
    _itemArr =@[@"1.jpg",@"2.jpg",@"3.jpg",@"4.jpg",@"5.jpg",@"6.jpg"];
    [self addMain];
    //[self addImg];
    [self addCarousel];
    [self addPageControl];
}

-(void)addMain{
    _headerView =[[UIView alloc]  initWithFrame:CGRectMake(0, 0, MAXWidth, _headHeight)];
    _headerView.backgroundColor =[UIColor purpleColor];
    [self.view addSubview:_headerView];
    
    NSArray * array =@[@"推荐",@"活动",@"最新",@"好评",@"日韩",@"欧美",@"高清",@"无码"];
    NSMutableArray * vcArr =[NSMutableArray array];
    for (int i =0; i<array.count; i++) {
        TableVC * vc =[[TableVC alloc] init];
        [vc setScrollViewDidScroll:^(UIScrollView * scrollView){
            CGFloat orignY = _contentView.frame.origin.y;
            CGFloat offsetY = scrollView.contentOffset.y;
            //上啦
            if (orignY>0 && orignY<=200 && offsetY>0) {
                _headerView.frame = CGRectMake(0, 0, MAXWidth, _headerView.frame.size.height-offsetY);
                scrollView.contentOffset = CGPointZero;
            }else if (orignY <= 0 && offsetY>0){
                _headerView.frame = CGRectMake(0, 0, MAXWidth, 0);
            }
            //下拉
            if (offsetY<0 && orignY>=0 && orignY<200) {
                _headerView.frame =CGRectMake(0, 0, MAXWidth, _headerView.frame.size.height-offsetY);
                scrollView.contentOffset = CGPointZero;
            }else if (offsetY <0 && orignY>=200){
                //继续下拉
                _headerView.frame = CGRectMake(0, 0, MAXWidth, 200);
                //scrollView.contentOffset = CGPointZero; //此时不处理  便于 刷新操作
            }
            
            if (_headerView.frame.size.height<0 ) {
                _headerView.frame =CGRectMake(0, 0, MAXWidth, 0);
            }
        }];
        //如果 vc中没有下拉刷新 可以设置此处一个 弹性动画效果
        [vc setScrollViewEndDrag:^(UIScrollView * scrollView){
            CGFloat originY = _contentView.frame.origin.y;
            if (originY>200) {
                //NSLog(@"下拉结束");
                /*[UIView animateWithDuration:0.6 animations:^{
                 _headerView.frame =CGRectMake(0, 0, MAXWidth, 200);
                 }];*/
                POPSpringAnimation * anim =[POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
                anim.springBounciness =10.0;
                anim.springSpeed =20.0;
                anim.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, MAXWidth, 200)];
                [_headerView pop_addAnimation:anim forKey:@"恢复动画"];
            }
            
        }];
        [vcArr addObject:vc];
    }
    CLSliderFrame *  clSlider =[[CLSliderFrame alloc] initWithArray:array andVCs:vcArr andPageCounts:4];
    clSlider.noSelectColor =[UIColor grayColor];
    [self addChildViewController:clSlider];
    [self.view addSubview:clSlider.view];
    _contentView = clSlider.view;
    
    _contentView.sd_layout.topSpaceToView(_headerView,0).leftSpaceToView(self.view,0).rightSpaceToView(self.view,0).bottomSpaceToView(self.view,0);
}
-(void)addImg{
    NSString * path =[[NSBundle mainBundle] pathForResource:@"tu" ofType:@"jpg"];
    UIImageView * imgView =[[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:path]];
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    [_headerView addSubview:imgView];
    imgView.sd_layout.topSpaceToView(_headerView,0).leftSpaceToView(_headerView,0).rightSpaceToView(_headerView,0).bottomSpaceToView(_headerView,0);
}
-(void)addCarousel{
    _carousel =[[iCarousel alloc] init];
    _carousel.backgroundColor =[UIColor yellowColor];
    _carousel.type = iCarouselTypeCylinder;
    _carousel.clipsToBounds =YES;
    _carousel.delegate =self;
    _carousel.dataSource =self;
    [_headerView addSubview:_carousel];
    _carousel.sd_layout.topSpaceToView(_headerView,0).leftSpaceToView(_headerView,0).rightSpaceToView(_headerView,0).bottomSpaceToView(_headerView,0);
    _timer =[NSTimer scheduledTimerWithTimeInterval:2.5 target:self selector:@selector(nextCarousel) userInfo:nil repeats:YES];
}
-(void)addPageControl{
    _pageControl =[[UIPageControl alloc] init];
    _pageControl.numberOfPages = _itemArr.count;
    _pageControl.currentPage =0;
    _pageControl.currentPageIndicatorTintColor = [UIColor blueColor];
    _pageControl.pageIndicatorTintColor =[UIColor whiteColor];
    [_headerView addSubview:_pageControl];
    _pageControl.sd_layout.leftSpaceToView(_headerView,0).rightSpaceToView(_headerView,0).bottomSpaceToView(_headerView,5).heightIs(20);
    [_pageControl addTarget:self action:@selector(pageControlAction:) forControlEvents:UIControlEventValueChanged];
}
-(void)pageControlAction:(UIPageControl *)control{
    
}
-(NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel{
    return _itemArr.count;
}
-(UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view{
    if (view == nil) {
        view = [[UIImageView alloc] initWithFrame:_headerView.frame];
        view.backgroundColor =[UIColor clearColor];
    }
    ((UIImageView *)view).image = [UIImage imageNamed:_itemArr[index]];
    return view;
}
-(void)nextCarousel{
    NSInteger index =_carousel.currentItemIndex;
    if (index == _itemArr.count-1) {
        index = 0;
    }else{
        index++;
    }
    [_carousel scrollToItemAtIndex:index animated:YES];
    _pageControl.currentPage = index;
}
-(void)carouselWillBeginDragging:(iCarousel *)carousel{
    [_timer setFireDate:[NSDate distantFuture]];
}
-(void)carouselDidEndDragging:(iCarousel *)carousel willDecelerate:(BOOL)decelerate{
    [_timer setFireDate:[NSDate distantPast]];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
    _carousel.delegate =self;
    _carousel.dataSource =self;
    [_timer invalidate];
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
