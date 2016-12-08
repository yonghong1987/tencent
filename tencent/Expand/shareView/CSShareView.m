//
//  CSShareView.m
//  tencent
//
//  Created by admin on 16/5/6.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSShareView.h"
#import "CSShareItemView.h"
#import "CSFrameConfig.h"
#import "CSFontConfig.h"
#import "AppDelegate.h"
#import "AppDelegate+Category.h"
#import "WXApi.h"
#import "UIColor+HEX.h"
@interface CSShareView ()
/*
 ***标题
 */
@property (nonatomic, strong) UILabel *titleLabel;
/*
 **取消按钮
 */
@property (nonatomic, strong) UIButton *cancelBtn;
/*
 **蒙板
 */
@property (nonatomic, strong) UIView *maskView;

/*
 **标题数组
 */
@property (nonatomic, strong) NSArray *titleNames;
/*
 **图片数组
 */
@property (nonatomic,strong) NSArray *icons;

@end

@implementation CSShareView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)init{
    if (self = [super init]) {
        self.viewController = self.viewController.navigationController.topViewController;
        [self initUI];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.viewController = self.viewController.navigationController.topViewController;
        [self initUI];
    }
    return self;
}

-(void)initUI{
    self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.6];
    self.titleNames = @[@"朋友圈",@"微信好友"];
    self.icons = @[@"img_friends",@"img_wechat"];
    
    self.maskView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    [self.maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)]];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kCSScreenWidth, 36)];
    self.titleLabel.text = @"分享到社交平台";
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = kContentFont;
    [self addSubview:self.titleLabel];
    
    CGFloat padding = 40.0;
    NSInteger column = 3 ;
    CGFloat btnWidth = (kCSScreenWidth - (column + 1) * padding) / column;
    for (int i = 0; i < self.titleNames.count; i++) {
        CSShareItemView *shareItemView = [[CSShareItemView alloc] initWithFrame:CGRectMake((i + 1) * padding + i * btnWidth, self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height, btnWidth, btnWidth + 20)];
        shareItemView.titlLabel.text = self.titleNames[i];
        shareItemView.iocnIV.image = [UIImage imageNamed:self.icons[i]];
        shareItemView.tag = 1000 + i;
        [shareItemView addTarget:self action:@selector(shareToThirdPlatform:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:shareItemView];
    }
    
    self.cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cancelBtn.frame = CGRectMake(40, self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height + btnWidth + 20 + 20, kCSScreenWidth - 80, 40);
    self.cancelBtn.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.cancelBtn addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.cancelBtn];
    
    CGFloat shareViewHeight = CGRectGetMaxY(self.cancelBtn.frame) + 100;
    self.frame = CGRectMake(0, kCSScreenHeight, kCSScreenWidth, shareViewHeight);
}


- (void)hide
{
    [self hide:nil];
}

- (void)hide:(void(^)())completion
{
    CGRect frame = self.frame;
    frame.origin.y += frame.size.height;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = frame;
    } completion:^(BOOL finished) {
        [self.maskView removeFromSuperview];
        [self removeFromSuperview];
        if (completion) {
            completion();
        }
    }];
}

-(void)shareToThirdPlatform:(CSShareItemView *)sender{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"专访张小龙：产品之上的世界观";
    message.description = @"微信的平台化发展方向是否真的会让这个原本简洁的产品变得臃肿？在国际化发展方向上，微信面临的问题真的是文化差异壁垒吗？腾讯高级副总裁、微信产品负责人张小龙给出了自己的回复。";
    [message setThumbImage:[UIImage imageNamed:@"res2.png"]];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = @"http://tech.qq.com/zt2012/tmtdecode/252.htm";
    message.mediaObject = ext;
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    switch (sender.tag) {
        case 1000:
          req.scene=WXSceneTimeline;
            break;
        case 1001:
        req.scene=WXSceneSession;
            break;
        default:
            break;
    }
    [WXApi sendReq:req];
}

- (void)showShareView{
    [self.viewController.view addSubview:self.maskView];
    [self.viewController.view addSubview:self];
    CGRect frame = self.frame;
    frame.origin.y -= frame.size.height;
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = frame;
    } completion:^(BOOL finished) {
        
    }];
}
@end
