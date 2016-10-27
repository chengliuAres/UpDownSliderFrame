//
//  TableVC.m
//  上下左右滑动框架
//
//  Created by AppleCheng on 16/9/21.
//  Copyright © 2016年 AppleCheng. All rights reserved.
//

#import "TableVC.h"
#import "Cell.h"
@interface TableVC ()<UIScrollViewDelegate>
@property (nonatomic,strong) NSArray * dataArr;
@property (nonatomic,strong) NSMutableArray * rowArr;
@end

@implementation TableVC
-(instancetype)init{
    if (self =[super init]) {
        self.tableView.separatorStyle =UITableViewCellSeparatorStyleNone;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 30)];
    label.font =[UIFont systemFontOfSize:28];
    label.textColor =[UIColor colorWithDisplayP3Red:arc4random_uniform(255.0)/255.0 green:arc4random_uniform(255.0)/255.0 blue:arc4random_uniform(255.0)/255.0 alpha:1.0];
    label.textAlignment =NSTextAlignmentCenter;
    label.text =@"我可是有底线的";
    self.tableView.tableFooterView =label;
    
    _dataArr =@[@"王老吉",@"六、block回调不起作用，可能是调用block属性变量的类的实例对象已不是原来的对象个问题只能具体情况具体分析了，程序运行可能不会错，就是block回调不起作用，有些功能实现不了，断点调试发现根本不走回调。之前我有一个同事就遇到过这个问题，另外一个同事给他解决了一个小时也没解决，我让他检查一下调用block块的类对象"];
    _rowArr =[NSMutableArray arrayWithObjects:@1,@2,@3, nil];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self addRefresh];
}
-(void)addRefresh{
    self.refreshControl =[[UIRefreshControl alloc] init];
    self.refreshControl.attributedTitle =[[NSAttributedString alloc] initWithString:@"拼命加载中..." attributes:@{NSForegroundColorAttributeName:[UIColor grayColor]}];
    [self.refreshControl addTarget:self action:@selector(refreshAction:) forControlEvents:UIControlEventValueChanged];
}
-(void)refreshAction:(UIRefreshControl *)control{
    NSLog(@"刷新中");
    [_rowArr addObjectsFromArray:@[@"1",@"2"]];
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _rowArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView cellHeightForIndexPath:indexPath cellContentViewWidth:[UIScreen mainScreen].bounds.size.width tableView:tableView];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell =[[Cell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    //产生1-x的随机数
    cell.imgView.image =[UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",arc4random_uniform(6)+1]];
    cell.strArr = _dataArr;
    return cell;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (_scrollViewDidScroll) {
        self.scrollViewDidScroll(scrollView);
    }
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (_scrollViewEndDrag) {
        //self.scrollViewEndDrag(scrollView);
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
