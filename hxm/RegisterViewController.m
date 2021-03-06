//
//  RegisterViewController.m
//  hxm
//
//  Created by Bruce on 15-5-14.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//

#import "RegisterViewController.h"
#import "ApplyViewController.h"
#import "AFNetworkTool.h"
#import "BWCommon.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

UITextField *username;
UITextField *password;
UITextField *repassword;
UITextField *mobile;
UITextField *email;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self pageLayout];
}

-(void) pageLayout {
    
    UIColor *bgColor = [BWCommon getBackgroundColor];
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    
    UIScrollView *sclView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    sclView.backgroundColor = bgColor;
    sclView.scrollEnabled = YES;
    sclView.contentSize = CGSizeMake(size.width, size.height);
    [self.view addSubview:sclView];

    self.view.backgroundColor = bgColor;
    [self.navigationItem setTitle:@"注册"];
    
    username = [self createTextField:@"login-user.png" Title:@"会员名"];
    [sclView addSubview:username];
    
    password = [self createTextField:@"login-password.png" Title:@"登录密码"];
    password.secureTextEntry = YES;
    [sclView addSubview:password];
    
    repassword = [self createTextField:@"register-password.png" Title:@"确认密码"];
    repassword.secureTextEntry = YES;
    [sclView addSubview:repassword];
    
    mobile = [self createTextField:@"register-cellphone.png" Title:@"手机号码"];
    [sclView addSubview:mobile];
    
    email = [self createTextField:@"register-email.png" Title:@"电子邮箱"];
    [sclView addSubview:email];
    
    UIButton *btnRegister = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnRegister.frame = CGRectMake(0, 0, 270, 50);
    [btnRegister.layer setMasksToBounds:YES];
    [btnRegister.layer setCornerRadius:5.0];
    btnRegister.translatesAutoresizingMaskIntoConstraints = NO;
    btnRegister.backgroundColor = [UIColor colorWithRed:119/255.0 green:179/255.0 blue:215/255.0 alpha:1];
    btnRegister.tintColor = [UIColor whiteColor];
    btnRegister.titleLabel.font = [UIFont systemFontOfSize:22];
    
    [btnRegister setTitle:@"提交注册" forState:UIControlStateNormal];
    
    //点击回调
    [btnRegister addTarget:self action:@selector(applyTouched:) forControlEvents:UIControlEventTouchUpInside];
    
    [sclView addSubview:btnRegister];
    
    
    
    
    
    NSArray *constraints1= [NSLayoutConstraint constraintsWithVisualFormat:@"|-[username(==270)]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(username)];
    NSArray *constraints2= [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-60-[username(==50)]-10-[password(==50)]-10-[repassword(==50)]-10-[mobile(==50)]-10-[email(==50)]-20-[btnRegister(==50)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(username,password,repassword,mobile,email,btnRegister)];
    
    NSArray *constraints3= [NSLayoutConstraint constraintsWithVisualFormat:@"|-[password(==270)]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(password)];
    NSArray *constraints4= [NSLayoutConstraint constraintsWithVisualFormat:@"|-[repassword(==270)]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(repassword)];
    NSArray *constraints5= [NSLayoutConstraint constraintsWithVisualFormat:@"|-[mobile(==270)]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(mobile)];
    NSArray *constraints6= [NSLayoutConstraint constraintsWithVisualFormat:@"|-[email(==270)]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(email)];
    
    NSArray *constraints7= [NSLayoutConstraint constraintsWithVisualFormat:@"|-[btnRegister(==270)]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(btnRegister)];
    
    [sclView addConstraints:constraints1];
    [sclView addConstraints:constraints2];
    [sclView addConstraints:constraints3];
    [sclView addConstraints:constraints4];
    [sclView addConstraints:constraints5];
    [sclView addConstraints:constraints6];
    [sclView addConstraints:constraints7];
    
    
    //水平居中
    
    [self setTextFieldCenter:[[NSArray alloc] initWithObjects:username,password,repassword,mobile,email,btnRegister,nil]];
    

    
}


-(void) registerTouched: (id)sender
{
    NSString *usernameValue = username.text;
    NSString *passwordValue = password.text;
    NSString *repasswordValue = repassword.text;
    NSString *mobileValue = mobile.text;
    NSString *emailValue = email.text;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    
    if([usernameValue isEqualToString:@""])
    {
        [alert setMessage:@"用户名未输入"];
        [alert show];
        return;
    }
    
    if([passwordValue isEqualToString:@""])
    {
        [alert setMessage:@"密码未输入"];
        [alert show];
        return;
    }
    
    if(![passwordValue isEqualToString:repasswordValue])
    {
        [alert setMessage:@"两次输入的密码不一致"];
        [alert show];
        return;
    }
    
    
    NSString *api_url = [BWCommon getBaseInfo:@"api_url"];
    
    NSString *url =  [api_url stringByAppendingString:@"user/addUser"];
    
    NSDictionary *postData = @{@"username":usernameValue,@"password":passwordValue,@"repassword":repasswordValue,@"mobile":mobileValue,@"email":emailValue};
    
    
    [AFNetworkTool postJSONWithUrl:url parameters:postData success:^(id responseObject) {
        
        
        NSLog(@"%@",responseObject);
        
        
        NSInteger errNo = [[responseObject objectForKey:@"errno"] integerValue];
        
        if (errNo >= 0) {
            [alert setMessage:[responseObject objectForKey:@"error"]];
            [alert show];
        }
        else
        {
            //NSDictionary *data = [responseObject objectForKey:@"data"];
            
            //NSUserDefaults *udata = [NSUserDefaults standardUserDefaults];
            //udata = [data copy];
            //[udata setObject:[data objectForKey:@"uid"] forKey:@"uid"];
            
            //[self backTouched:nil];
            
            //NSLog(@"%@",udata);
        }

    } fail:^{
        NSLog(@"请求失败");
    }];
    
    
}

- (void) setTextFieldCenter:(NSArray *) items{
    
    NSInteger i = 0;
    
    for (i=0; i<[items count]; i++) {
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:[items objectAtIndex:i] attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    }
    
}

- (UITextField *) createTextField:(NSString *)image Title:(NSString *) title{
    
    UITextField * field = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 270, 50)];
    field.borderStyle = UITextBorderStyleRoundedRect;
    [field.layer setCornerRadius:5.0];
    field.placeholder = title;
    UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:image]];
    field.leftView = icon;
    field.leftViewMode = UITextFieldViewModeAlways;
    field.translatesAutoresizingMaskIntoConstraints = NO;
    field.delegate = self;
    
    return field;
}

- (void) applyTouched:(id)sender
{
    
    ApplyViewController * applyView = [[ApplyViewController alloc] init];
    
    [self.navigationController pushViewController:applyView animated:YES];
    
    NSLog(@"apply touched");
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
