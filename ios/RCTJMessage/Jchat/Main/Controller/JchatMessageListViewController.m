//
//  JchatMessageListViewController.m
//  DecorateTogether
//
//  Created by 张羽 on 16/10/9.
//  Copyright © 2016年 Aiken. All rights reserved.
//

#import "JchatMessageListViewController.h"
#import "JCHATConversationListCell.h"
#import "JCHATConversationViewController.h"
#import "MBProgressHUD+Add.h"
#define AppKey @"f852aa5931cba0c712f468fa"
@interface JchatMessageListViewController ()
@property(nonatomic,copy)NSMutableArray *JMSGConversationArr;
@property(nonatomic,copy)NSMutableArray *messageListArr;
@property(nonatomic,strong)UITableView *JchatMessageListTableView;
@end

@implementation JchatMessageListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    [self setTableView];
    UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 40)];
    [btn setTitle:@"加好友" forState:UIControlStateNormal];
    btn.backgroundColor=[UIColor grayColor];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    [btn addTarget:self action:@selector(addFriend) forControlEvents:UIControlEventTouchUpInside];
    [self addDelegate];
    // Do any additional setup after loading the view.
}
-(void)addFriend
{
    UIAlertView *alerView =[[UIAlertView alloc] initWithTitle:@"添加好友"
                                                      message:@"输入好友用户名!"
                                                     delegate:self
                                            cancelButtonTitle:@"取消"
                                            otherButtonTitles:@"确定", nil];
    alerView.alertViewStyle =UIAlertViewStylePlainTextInput;
    [alerView show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
    } else if (buttonIndex == 1)
    {
        if ([[alertView textFieldAtIndex:0].text isEqualToString:@""]) {
           [MBProgressHUD showMessage:@"请输入用户名" view:self.view];
            return;
        }
        

        __block JCHATConversationViewController *sendMessageCtl = [[JCHATConversationViewController alloc] init];
        sendMessageCtl.superViewController = self;
        sendMessageCtl.hidesBottomBarWhenPushed = YES;
        [[alertView textFieldAtIndex:0] resignFirstResponder];
        __weak __typeof(self)weakSelf = self;
        [JMSGConversation createSingleConversationWithUsername:[alertView textFieldAtIndex:0].text appKey:AppKey completionHandler:^(id resultObject, NSError *error) {
           
            
            if (error == nil) {
                
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                __strong __typeof(weakSelf) strongSelf = weakSelf;
                sendMessageCtl.conversation = resultObject;
                [strongSelf.navigationController pushViewController:sendMessageCtl animated:YES];
            } else {
                
               [MBProgressHUD showMessage:@"添加的用户不存在" view:self.view];
            }
        }];
    }
}

-(void)setTableView
{
    if (!_JchatMessageListTableView) {
        _JchatMessageListTableView=[[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain ];
        _JchatMessageListTableView.delegate=self;
        _JchatMessageListTableView.dataSource=self;
        [self.view addSubview:_JchatMessageListTableView];
        
        
    }
}
- (void)addDelegate {
    [JMessage addDelegate:self withConversation:nil];
}
-(NSMutableArray *)JMSGConversationArr
{
    if (_JMSGConversationArr==nil) {
        _JMSGConversationArr=[NSMutableArray array];
    }
    return _JMSGConversationArr;
}
-(NSMutableArray*)messageListArr
{
    if (_messageListArr==nil) {
        _messageListArr=[NSMutableArray array];
        
    }
    return _messageListArr;
}
-(void)getLastMessage
{
    [JMSGConversation allConversations:^(id resultObject, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error == nil) {
                _JMSGConversationArr= [self sortConversation:resultObject];
                for (NSInteger i=0; i < [_JMSGConversationArr count]; i++) {
                    JMSGConversation *conversation = [_JMSGConversationArr objectAtIndex:i];
                }
                
                [self.JchatMessageListTableView reloadData];
            } else {
                _JMSGConversationArr = nil;
            }

        });
    }];
}
#pragma mark --排序conversation
- (NSMutableArray *)sortConversation:(NSMutableArray *)conversationArr {
    NSArray *sortResultArr = [conversationArr sortedArrayUsingFunction:sortType context:nil];
    return [NSMutableArray arrayWithArray:sortResultArr];
    return nil;
}
NSInteger sortType(id object1,id object2,void *cha) {
    JMSGConversation *model1 = (JMSGConversation *)object1;
    JMSGConversation *model2 = (JMSGConversation *)object2;
    if([model1.latestMessage.timestamp integerValue] > [model2.latestMessage.timestamp integerValue]) {
        return NSOrderedAscending;
    } else if([model1.latestMessage.timestamp integerValue] < [model2.latestMessage.timestamp integerValue]) {
        return NSOrderedDescending;
    }
    return NSOrderedSame;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([_JMSGConversationArr count] > 0) {
        return [_JMSGConversationArr count];
    } else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"JCHATConversationListCell";
    JCHATConversationListCell *cell = (JCHATConversationListCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        cell=[[JCHATConversationListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    JMSGConversation *conversation =[_JMSGConversationArr objectAtIndex:indexPath.row];
    cell.JMSGConversation=conversation;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
-(void)onReceiveMessage:(JMSGMessage *)message error:(NSError *)error
{
    [self getLastMessage];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JCHATConversationViewController *jchat=[[JCHATConversationViewController alloc]init];
    jchat.conversation=_JMSGConversationArr[indexPath.row];
    [self.navigationController pushViewController:jchat animated:YES];
    
}
-(void)viewWillAppear:(BOOL)animated
{
     [self getLastMessage];
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
