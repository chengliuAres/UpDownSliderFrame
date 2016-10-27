//
//  UpDownVC.m
//  上下左右滑动框架
//
//  Created by AppleCheng on 16/9/20.
//  Copyright © 2016年 AppleCheng. All rights reserved.
//

#import "UpDownVC.h"
#import "SDAutoLayout.h"
#import "POP.h"
#define  MAXWidth  [UIScreen mainScreen].bounds.size.width
#define  MAXHeight  [UIScreen mainScreen].bounds.size.height


@interface UpDownVC () <UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
@property (nonatomic,strong) UIView * headerView;
@property (nonatomic,strong) UIView * dividerView;
@property (nonatomic,strong) UIView * contentView;

@property (nonatomic,weak) UITableView * table;
@end

@implementation UpDownVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addHeaderView];
    [self addImage];
}
-(void)addImage{
    UIImageView * imgView =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tu.jpg"]];
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    [_headerView addSubview:imgView];
    imgView.sd_layout.topSpaceToView(_headerView,0).rightSpaceToView(_headerView,0).leftSpaceToView(_headerView,0).bottomSpaceToView(_headerView,0);
}
-(void)addHeaderView{
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAXWidth, 200)];
    _headerView.backgroundColor =[UIColor purpleColor];
    [self.view addSubview:_headerView];
    
    _dividerView =[[UIView alloc] init];
    _dividerView.backgroundColor =[UIColor yellowColor];
    [self.view addSubview:_dividerView];
    [_dividerView addObserver:self forKeyPath:NSStringFromSelector(@selector(frame)) options:NSKeyValueObservingOptionNew context:nil];
    
    _contentView =[[UIView alloc] init];
    _contentView.backgroundColor =[UIColor lightGrayColor];
    [self.view addSubview:_contentView];
    
    _headerView.sd_layout.leftSpaceToView(self.view,0).rightSpaceToView(self.view,0);
    _dividerView.sd_layout.topSpaceToView(_headerView,0).leftEqualToView(_headerView).rightEqualToView(_headerView).heightIs(40);
    _contentView.sd_layout.topSpaceToView(_dividerView,0).leftEqualToView(_headerView).rightEqualToView(_headerView).bottomSpaceToView(self.view,0);
    
    //    UIPanGestureRecognizer * pan =[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    //    [_contentView addGestureRecognizer:pan];
    UITableView * tableView =[[UITableView alloc] init];
    tableView.delegate=self;
    tableView.dataSource =self;
    [_contentView addSubview:tableView];
    tableView.sd_layout.leftSpaceToView(_contentView,0).topSpaceToView(_contentView,0).bottomSpaceToView(_contentView,0).rightSpaceToView(_contentView,0);
    _table =tableView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    cell.textLabel.text =@"鼻子";
    return cell;
}

-(void)panAction:(UIPanGestureRecognizer *)gesture{
    CGPoint point =[gesture translationInView:self.view];
    NSLog(@"%@",NSStringFromCGPoint(point));
    //_contentView.center = CGPointMake(_contentView.center.x, _contentView.center.y+point.y);
    [UIView animateWithDuration:0.01 animations:^{
        _headerView.frame = CGRectMake(0, 0, MAXWidth, _headerView.frame.size.height+point.y);
    }];
    [gesture setTranslation:CGPointZero inView:self.view];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    CGPoint point = scrollView.contentOffset;
    NSLog(@"beginDrag:%f",point.y);
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat orignY = _dividerView.frame.origin.y;
    CGFloat offsetY = scrollView.contentOffset.y;
    NSLog(@"偏移量：%f 原点y坐标：%f",offsetY,orignY);
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
        _headerView.frame = CGRectMake(0, 0, MAXWidth, _headerView.frame.size.height-offsetY*0.2);
        scrollView.contentOffset = CGPointZero;
    }
    
    if (_headerView.frame.size.height<0 ) {
        _headerView.frame =CGRectMake(0, 0, MAXWidth, 0);
    }
    //else if (_headerView.frame.size.height>200){
    //        _headerView.frame =CGRectMake(0, 0, MAXWidth, 200);
    //    }
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    CGFloat originY = _dividerView.frame.origin.y;
    if (originY>210) {
        NSLog(@"下拉结束");
        /*[UIView animateWithDuration:0.6 animations:^{
            _headerView.frame =CGRectMake(0, 0, MAXWidth, 200);
        }];*/
        POPSpringAnimation * anim =[POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
        anim.springBounciness =10.0;
        anim.springSpeed =20.0;
        anim.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, MAXWidth, 200)];
        [_headerView pop_addAnimation:anim forKey:@"恢复动画"];
    }
    /*CGFloat headerHeight = _headerView.frame.size.height;
    CGFloat setHeight =0;
    if (headerHeight >=100) {
        setHeight = 200;
    }
    POPSpringAnimation * anim =[POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
    anim.springBounciness =10.0;
    anim.springSpeed =10.0;
    anim.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, MAXWidth, setHeight)];
    [_headerView pop_addAnimation:anim forKey:@"恢复动画"];*/
    
}
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"frame"]) {
        CGRect originRect = [[change objectForKey:NSKeyValueChangeNewKey] CGRectValue];
        CGFloat orignY = originRect.origin.y;
        if (orignY>200) {
            //_headerView.frame =CGRectMake(0, 0, MAXWidth, 200);
        }
    }
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
