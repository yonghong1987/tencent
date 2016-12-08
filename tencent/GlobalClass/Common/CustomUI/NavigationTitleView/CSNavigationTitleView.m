//
//  CSNavigationTitleView.m
//  tencent
//
//  Created by bill on 16/4/25.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSNavigationTitleView.h"
#import "CSFrameConfig.h"
#import "CSProjectDefault.h"
#import "CSConfig.h"
#import "UIView+SDAutoLayout.h"


@interface CSNavigationTitleView ()


/**
 *  TitleView的文字部分
 */
@property (nonatomic, strong) UILabel *contentLbl;

/**
 *  初始状态的图片
 */
@property (nonatomic, strong) NSString *normalImageName;

/**
 *  切换状态后的图片
 */
@property (nonatomic, strong) NSString *SelectedImageName;

@end


@implementation CSNavigationTitleView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithNomalImageName:(NSString *)nomalName
             SelectedImageName:(NSString *)selectedName{

    self = [super init];
    if ( self ) {
        
        self.frame = CGRectMake( 0, 0, kCSScreenWidth, KNavigationHegiht);
        self.backgroundColor = [UIColor clearColor];
        self.normalImageName = nomalName;
        self.SelectedImageName = selectedName;
 
        //加载文字
        _contentLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _contentLbl.font = [UIFont boldSystemFontOfSize:16];
        _contentLbl.textColor = [UIColor whiteColor];
        [self addSubview:_contentLbl];
        
        //加载图片
        self.contentImg = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:_contentImg];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(responseToNotify)
                                                     name:kChangeProjectNotifycation
                                                   object:nil];
        [self resetView];
        

    }
    
    return self;
}


- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark 刷新UI
- (void)resetView{
    
    if ( [[[CSProjectDefault shareProjectDefault] getProjectId] integerValue] != 0 ) {
        
        NSString *content = [[CSProjectDefault shareProjectDefault] getProjectName];
        //图片的size
        UIImage *image = [UIImage imageNamed:self.normalImageName];
        
        CGSize imageSize = image.size;
        
        //文字的size
        CGSize contentLblSize = CGSizeMake( kCSScreenWidth, 21);
        NSDictionary *attributes = [NSDictionary dictionaryWithObject:[UIFont boldSystemFontOfSize:16] forKey:NSFontAttributeName];
        NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:content attributes:attributes];
        CGRect rect = [attributedText boundingRectWithSize:contentLblSize
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                   context:nil];
        contentLblSize = rect.size;
        
        CGFloat backViewWidth = contentLblSize.width + 3 + imageSize.width;
        
        //设置titleView居中
        CGFloat orginX = 0;
        if ( backViewWidth < (kCSScreenWidth - 180) ) {
            orginX = ( (kCSScreenWidth - 180) - backViewWidth)/2;
            backViewWidth = (kCSScreenWidth - 180);
        }
        
        self.frame = CGRectMake( (kCSScreenWidth - backViewWidth)/2, 7, backViewWidth, 30);
        
        _contentLbl.frame = CGRectMake( orginX ,  5, contentLblSize.width, 21);
        _contentLbl.text = content;
        
        self.contentImg.frame = CGRectMake( CGRectGetMaxX(_contentLbl.frame) + 3,  (21 -  imageSize.height)/2 + 5,
                                       imageSize.width, imageSize.height);
        self.contentImg.image = image;
        
    }
}

#pragma mark 响应通知
- (void)responseToNotify{
    [self resetView];
}


@end
