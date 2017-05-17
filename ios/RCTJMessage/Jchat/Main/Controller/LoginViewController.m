//
//  LoginViewController.m
//  框架demo
//
//  Created by 张羽 on 17/3/24.
//  Copyright © 2017年 张羽. All rights reserved.
//

#import "LoginViewController.h"
#import "UIView+AutoLayout.h"
#import "UIColor+expanded.h"
#import "RegisterViewController.h"
#import "JchatMessageListViewController.h"
#import "JMessage/JMessage.h"
#import "MBProgressHUD+Add.h"
@interface LoginViewController ()
@property(nonatomic,strong)UITextField *accoutView;
@property(nonatomic,strong)UITextField *passView;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    [self setLoginUI];
    
    // Do any additional setup after loading the view.
}

#pragma  mark  页面出现
-(void)viewWillAppear:(BOOL)animated
{
  
    if ( [self isLogin]) {
      dispatch_async(dispatch_get_main_queue(), ^{
          [JMSGUser logout:^(id resultObject, NSError *error) {
              if (error==nil) {
                  [MBProgressHUD showSuccess:@"退出登录成功" toView:self.view];
              }
          }];
      });
       
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark 页面ui
-(void)setLoginUI
{
       UIButton * backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 40)];
    [backBtn setTitle:@"注册" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    backBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [backBtn addTarget:self action:@selector(registerAccout) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    self.view.backgroundColor=[UIColor whiteColor];
    UIView *login=[[UIView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:login];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidekeyboard)];
    [login addGestureRecognizer:tap];
    login.userInteractionEnabled=YES;
    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(0, 3, self.view.frame.size.width, 1)];
    [login addSubview:line];
    line.backgroundColor=[UIColor colorWithHexString:@"9b9b9b"];
    
    
    UILabel *label=[[UILabel alloc]init];
    label.text=@"账号";
    label.font=[UIFont systemFontOfSize:14];
    [login addSubview:label];
    [label autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:40];
    [label autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:3];
    [label autoSetDimension:ALDimensionHeight toSize:50];
    UITextField *accoutView=[[UITextField alloc]init];
    self.accoutView=accoutView;
    [login  addSubview:accoutView];
    accoutView.placeholder=@"请输入账号";
    accoutView.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    accoutView.font=[UIFont systemFontOfSize:14];
    [accoutView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:line withOffset:0];
    [accoutView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    [accoutView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:label withOffset:20];
    [accoutView autoSetDimension:ALDimensionHeight toSize:50];
    UIView *line2=[[UIView alloc]init];
    [login addSubview:line2];
    line2.backgroundColor=[UIColor colorWithHexString:@"9b9b9b"];
    [line2 autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [line2 autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    [line2 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:accoutView withOffset:0];
    [line2 autoSetDimension:ALDimensionHeight toSize:1];
    
    UILabel *passLable=[[UILabel alloc]init];
    passLable.font=[UIFont systemFontOfSize:14];
    passLable.text=@"密码";
    [login addSubview:passLable];
    [passLable autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:40];
    [passLable autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:label withOffset:0];
    [passLable autoSetDimension:ALDimensionHeight toSize:50];
    UITextField*passTextView=[[UITextField alloc]init];
    self.passView=passTextView;
    passTextView.font=[UIFont systemFontOfSize:14];
    passTextView.placeholder=@"请输入密码";
    passTextView.clearButtonMode = UITextFieldViewModeWhileEditing;
    passTextView.secureTextEntry = YES;
    [login addSubview:passTextView];
    [passTextView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:passLable withOffset:20];
    [passTextView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    [passTextView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:line2 withOffset:0];
    [passTextView autoSetDimension:ALDimensionHeight toSize:50];
    
    UIView *line3=[[UIView alloc]init];
    [login addSubview:line3];
    line3.backgroundColor=[UIColor colorWithHexString:@"9b9b9b"];
    [line3 autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [line3 autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    [line3 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:passTextView withOffset:0];
    [line3 autoSetDimension:ALDimensionHeight toSize:1];
    UIButton *btn=[[UIButton alloc]init];
    [btn setTitle:@"登录" forState:UIControlStateNormal];
    btn.layer.cornerRadius = 5;
    btn.layer.masksToBounds = YES;
    [login addSubview:btn];
    [btn autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:40];
    [btn autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:40];
    [btn autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:passTextView withOffset:50];
    [btn autoSetDimensionsToSize:CGSizeMake((self.view.frame.size.width-80)/2, 45)];
    btn.backgroundColor=[UIColor colorWithHexString:@"0x1AB054"];
    [btn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    
    

}
#pragma mark 登录
-(void)login
{
    NSString *userName=self.accoutView.text;
    if (userName.length==0) {
        [MBProgressHUD showError:@"帐号不能为空" toView:self.view];
        return ;
    }
    NSString *password=self.passView.text;
    if (password.length==0) {
        [MBProgressHUD showError:@"密码不能为空" toView:self.view];
        return;
    }

    [JMSGUser loginWithUsername:userName password:password completionHandler:^(id resultObject, NSError *error) {
        if (error==nil) {
            [MBProgressHUD showSuccess:@"登录成功" toView:self.navigationController.view];
            JchatMessageListViewController *list=[[JchatMessageListViewController alloc]init];
            
            [self.navigationController pushViewController:list animated:YES];
        }else{
            [MBProgressHUD showError:@"登录失败" toView:self.view];
        }

    }];

}
#pragma mark 注册帐号
-(void)registerAccout
{
    RegisterViewController *regtster=[[RegisterViewController alloc]init];
    [self.navigationController pushViewController:regtster animated:YES];
}
#pragma mark 隐去键盘
-(void)hidekeyboard
{
    [self.accoutView resignFirstResponder];
    [self.passView resignFirstResponder];
}
#pragma mark 判断是否登录
-(BOOL)isLogin
{
    JMSGUser *user=[JMSGUser myInfo];
    if (user) {
        return YES;
    }else{
        return NO;
    }
    
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
