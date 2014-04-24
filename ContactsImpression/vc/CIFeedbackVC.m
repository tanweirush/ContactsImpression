//
//  CIFeedbackVC.m
//  ContactsImpression
//
//  Created by 谭伟 on 14-3-25.
//  Copyright (c) 2014年 谭伟. All rights reserved.
//

#import "CIFeedbackVC.h"
#import "PushViewController+UINavigationController.h"
#import "CITitleV.h"
#import "HSLoaddingVC.h"

@interface CIFeedbackVC ()

@property (nonatomic, retain) HSLoaddingVC *loadding;
@property (nonatomic, retain) NetServiceManager *net;

@end

@implementation CIFeedbackVC
@synthesize loadding = _loadding;
@synthesize net = _net;

- (id)init
{
    self = [super initWithNibName:@"CIFeedbackVC" bundle:nil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    CITitleV *title = [[CITitleV alloc] initWithTitle:@"给我们吐槽吧"];
    [self.navigationItem setTitleView:title];
    
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnBack setFrame:CGRectMake(0, 0, 44, 44)];
    [btnBack setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [btnBack setImageEdgeInsets:UIEdgeInsetsMake(0, -(44 - 5), 0, 0)];
    [btnBack addTarget:self action:@selector(OnBack:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
    self.navigationItem.leftBarButtonItem = backItem;
    
    
    UIButton *btnOK = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnOK setFrame:CGRectMake(0, 0, 44, 44)];
    [btnOK setImage:[UIImage imageNamed:@"ok.png"] forState:UIControlStateNormal];
    [btnOK setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -(44 - 10))];
    [btnOK addTarget:self action:@selector(OnOK:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *OKItem = [[UIBarButtonItem alloc] initWithCustomView:btnOK];
    self.navigationItem.rightBarButtonItem = OKItem;
}

-(void)viewDidAppear:(BOOL)animated
{
    [self performSelector:@selector(showKeyboard) withObject:nil afterDelay:0.333];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated
{
    self.loadding = nil;
    self.net = nil;
}

-(void)OnBack:(id)sender
{
//    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController popViewControllerWithTransitionType:@"push" SubType:@"fromLeft"];
}

-(void)OnOK:(id)sender
{
    if (self.tv.text.length == 0)
    {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示"
                                                     message:@"您还没有写下您要给我们吐槽的内容呢！"
                                                    delegate:self
                                           cancelButtonTitle:@"确定"
                                           otherButtonTitles:nil];
        [av show];
        return;
    }
    
    [self.tv resignFirstResponder];
    if (self.loadding == nil)
    {
        self.loadding = [[HSLoaddingVC alloc] initWithView:self.view Type:LOADDING_DEF];
        [self.view addSubview:self.loadding.view];
    }
    [self.loadding setTipText:@"吐槽中"];
    [self.loadding show];
    
    NetServiceManager *net = [[NetServiceManager alloc] init];
    [net setDelegate:self];
    [net SendFeedback:[[NSMutableDictionary alloc] initWithObjectsAndKeys:self.tv.text, CI_CONTENT, nil]];
    self.net = net;
}

-(BOOL)             textView:(UITextView *)textView
     shouldChangeTextInRange:(NSRange)range
             replacementText:(NSString *)text
{
    NSString *textReplace = [text stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    if (textReplace.length < text.length)
    {
        [self OnOK:nil];
        return FALSE;
    }
    NSString *s = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if (s.length > 255)
    {
        return FALSE;
    }
    return TRUE;
}

-(void)showKeyboard
{
    [self.tv becomeFirstResponder];
}

-(void)NoNeedUpdata:(NSInteger)tag Msg:(NSString *)m Result:(NSInteger)r
{
    [self.loadding setTipText:@"收到吐槽，谢谢支持"];
    [self.loadding hideAfterDelay:1.5];
    [self performSelector:@selector(OnBack:) withObject:nil afterDelay:2.0];
}

-(void)FeedbackData:(id)data Tag:(NSInteger)tag
{
    [self NoNeedUpdata:0 Msg:nil Result:1];
}
@end
