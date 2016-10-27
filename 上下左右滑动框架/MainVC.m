//
//  MainVC.m
//  上下左右滑动框架
//
//  Created by AppleCheng on 16/9/22.
//  Copyright © 2016年 AppleCheng. All rights reserved.
//

#import "MainVC.h"
#import "CLUpDownScrollVC.h"
#import "UserView.h"
#import "POP.h"
@interface MainVC ()
@property (nonatomic,weak) UITabBarController * tabVC;
@property (nonatomic,strong) UserView * userView;
@property (nonatomic,assign) CGFloat maxWidth;
@property (nonatomic,assign) CGFloat maxHeight;
@end

@implementation MainVC

-(id)init{
    if (self =[super init]) {
        _maxWidth =[UIScreen mainScreen].bounds.size.width;
        _maxHeight =[UIScreen mainScreen].bounds.size.height;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UITabBarController * tabVC =[[UITabBarController alloc] init];
    CLUpDownScrollVC * CLScrollVC =[[CLUpDownScrollVC alloc] init];
    UIBarButtonItem * leftBtn =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(shouldShowLeftView)];
    CLScrollVC.navigationItem.leftBarButtonItem = leftBtn;
    UINavigationController * nav =[[UINavigationController alloc] initWithRootViewController:CLScrollVC];
 
    nav.title =@"主页";
    nav.tabBarItem =[[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemFeatured tag:0];
    
    UIViewController * vc2 =[[UIViewController alloc] init];
    vc2.view.backgroundColor =[UIColor cyanColor];
    vc2.tabBarItem =[[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemMore tag:1];
    vc2.title=@"副业";
    tabVC.viewControllers =@[nav,vc2];
    [self addChildViewController:tabVC];
    [self.view addSubview:tabVC.view];
    _tabVC =tabVC;
    [self addLeftView];
}
-(void)addLeftView{
    _userView =[[UserView alloc] initWithFrame:CGRectMake(-240, 64, 240, _maxHeight)];
    _userView.titleArray =@[@"🇯🇵高能文化",@"🇺🇸骑兵文化",@"🇨🇳优衣库",@"🇬🇧无耻文化",@"🇰🇷步兵文化",@"🇵🇭脑残一区"];
    _userView.isShow =NO;
    [self.view addSubview:_userView];
    UIPanGestureRecognizer * leftPan =[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(leftPanAction:)];
    [_userView addGestureRecognizer:leftPan];
}
-(void)leftPanAction:(UIPanGestureRecognizer *)gesture{
    CGFloat x =[gesture translationInView:_userView].x;
    CGFloat originX =_userView.frame.origin.x;
    if (gesture.state == UIGestureRecognizerStateBegan || gesture.state == UIGestureRecognizerStateChanged) {
        _userView.center = CGPointMake(_userView.center.x + x, _userView.center.y);
        [gesture setTranslation:CGPointZero inView:_userView];
    }else{
        if (originX<-100) {
            [self hideLeft];
        }else{
            [self showLeft];
        }
    }
}
-(void)shouldShowLeftView{
    _userView.isShow == NO ? [self showLeft] : [self hideLeft];
    _userView.isShow =!_userView.isShow;
}
-(void)showLeft{
    POPSpringAnimation * anim =[POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
    anim.springBounciness =20;
    anim.springSpeed =20;
    anim.toValue = [NSValue valueWithCGRect:CGRectMake(0, 64, 240, _maxHeight)];
    [_userView pop_addAnimation:anim forKey:@"显示userView"];
}
-(void)hideLeft{
    POPSpringAnimation * anim =[POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
    anim.springBounciness =20;
    anim.springSpeed =20;
    anim.toValue = [NSValue valueWithCGRect:CGRectMake(-240, 64, 240, _maxHeight)];
    [_userView pop_addAnimation:anim forKey:@"显示userView"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
