//
//  ViewController.m
//  上下左右滑动框架
//
//  Created by AppleCheng on 16/8/5.
//  Copyright © 2016年 AppleCheng. All rights reserved.
//

#import "ViewController.h"
#import "CLSliderFrame.h"
#import "TableView1.h"
#import "JazzHands/IFTTTJazzHands.h"
@interface ViewController () <UIScrollViewDelegate>
@property (nonatomic,assign) CGFloat headerHeight;
@property (nonatomic,strong) UIScrollView * scrollview;
@property (nonatomic,strong) NSMutableArray * tableArr;
@property (nonatomic,strong) IFTTTAnimator * animator;
@property (nonatomic,strong) CLSliderFrame * slider;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _headerHeight =[UIScreen mainScreen].bounds.size.height/2;
    [self loadScrollView];
    [self loadHeader];
    [self loadSlider];
}
-(void)loadScrollView{
    _scrollview =[[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollview.contentSize =CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height*3/2);
    _scrollview.backgroundColor =[UIColor grayColor];
    _scrollview.delegate =self;
    _scrollview.pagingEnabled =YES; //滚动到子视图的边界
    _scrollview.bounces =NO;
    _scrollview.showsVerticalScrollIndicator =NO;
    [self.view addSubview:_scrollview];
    //[_scrollview addObserver:self forKeyPath:NSStringFromSelector(@selector(contentOffset)) options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    
}
-(void)loadHeader{
    UIView * header =[[UIView alloc] initWithFrame:CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, _headerHeight)];
    header.backgroundColor =[UIColor lightGrayColor];
    UIImageView * photo =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tu.jpg"]];
    photo.frame =CGRectMake(0, 0, 250, 250);
    photo.center = header.center;
    photo.contentMode = UIViewContentModeScaleAspectFit;
    [header addSubview:photo];
    [_scrollview addSubview:header];
    
    _animator =[IFTTTAnimator new];
    IFTTTScaleAnimation * scaleAnimation =[IFTTTScaleAnimation animationWithView:photo];
    [self.animator addAnimation:scaleAnimation];
    [scaleAnimation addKeyframeForTime:30 scale:0.9];
    [scaleAnimation addKeyframeForTime:300 scale:0.3];
    
    IFTTTTranslationAnimation * translateAnimatin =[IFTTTTranslationAnimation animationWithView:photo];
    [_animator addAnimation:translateAnimatin];
    [translateAnimatin addKeyframeForTime:0 translation:CGPointMake(0, 0)];
    [translateAnimatin addKeyframeForTime:300 translation:CGPointMake(0, 200)];
}
-(void)loadSlider{
    _tableArr =[NSMutableArray arrayWithCapacity:7];
    for (int i =0; i<7; i++) {
        TableView1 *table =[[TableView1 alloc] init];
        table.view.backgroundColor =[UIColor colorWithRed:arc4random_uniform(255.0)/255.0 green:arc4random_uniform(255.0)/255.0 blue:arc4random_uniform(255.0)/255.0 alpha:1.0];
        [_tableArr addObject:table];
    }
    _slider =[[CLSliderFrame alloc] initWithArray:@[@"推荐",@"头条",@"娱乐",@"关注",@"文化",@"历史",@"政治"] andVCs:_tableArr andPageCounts:4];
    [self addChildViewController:_slider];
    _slider.view.frame =CGRectMake(0, _headerHeight, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    [_scrollview addSubview:_slider.view];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat y =scrollView.contentOffset.y;
    [_animator animate:y];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"scrollY" object:[NSValue valueWithCGPoint: _scrollview.contentOffset] userInfo:nil];
}

//-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
//    CGPoint newP =[change[NSKeyValueChangeNewKey] CGPointValue];
//    NSLog(@"-------%f",newP.y);
//    if (newP.y >=_headerHeight) {
//        
//    }
//}
-(void)handleScroll:(NSNotification *)notification{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
