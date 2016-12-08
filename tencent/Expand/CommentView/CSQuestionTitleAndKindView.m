//
//  CSQuestionTitleAndKindView.m
//  tencent
//
//  Created by bill on 16/5/10.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSQuestionTitleAndKindView.h"

#define LeftMargin 10
#define RightMargin 10
#define TopMargin 10
#define BottomMargin 10

#define LINESPACE 10

@interface CSQuestionTitleAndKindView ()

@property (nonatomic, strong) UILabel *questionLbl;

@property (nonatomic, strong) UIImageView *questionImg;

@property (nonatomic, strong) NSMutableAttributedString *questionContent;

@property (nonatomic, strong) NSString *questionKind;
@end

@implementation CSQuestionTitleAndKindView


- (id)initWithFrame:(CGRect)frame QuestionContent:(NSString *)content QustionKind:(NSString *)kind{
    self = [super initWithFrame:frame];
    if ( self ) {
        self.backgroundColor = [UIColor lightGrayColor];
        
        self.questionContent = [[NSMutableAttributedString alloc] initWithString:content];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:LINESPACE];
        [self.questionContent addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [content length])];
        
        
        self.questionKind = kind;
        
        [self addSubview:self.questionLbl];
        [self addSubview:self.questionImg];
    }
    return self;
}


- (CGFloat)getViewHeight{
    
    [self resetView];
    return CGRectGetMaxY(self.questionImg.frame) + BottomMargin;
}

- (void)resetView{
    _questionLbl.attributedText = self.questionContent;
    [_questionLbl sizeToFit];
    
    CGRect frame = self.questionLbl.frame;
    CGPoint point = [self getPositionOfLastWord];
    point.y += frame.origin.y + LINESPACE;
    if ( point.x + 50 > self.frame.size.width ) {
        point.y += 21;
        point.x = 10;
    }else{
        point.x += 20;
    }
    
    frame = self.questionImg.frame;
    frame.origin = point;
    self.questionImg.frame = frame;
}

- (UILabel *)questionLbl{
    if ( !_questionLbl ) {
        _questionLbl = [[UILabel alloc] initWithFrame:CGRectMake( LeftMargin, TopMargin, self.bounds.size.width - (LeftMargin + RightMargin), 21)];
        _questionLbl.font = [UIFont systemFontOfSize:14];
        _questionLbl.numberOfLines = 0;
    }
    return _questionLbl;
}

- (UIImageView *)questionImg{
    if ( !_questionImg ) {
        _questionImg = [[UIImageView alloc] initWithFrame:CGRectMake( 0, TopMargin, 30, 21)];
        _questionImg.backgroundColor = [UIColor brownColor];
    }
    return _questionImg;
}

- (CGPoint)getPositionOfLastWord{
    
    CGPoint lastPoint = CGPointZero;
    
    //不换行时，文字的宽度
    CGSize sz = [self.questionLbl.text sizeWithFont:self.questionLbl.font
                                  constrainedToSize:CGSizeMake(MAXFLOAT, 21)];
    
    //换行时，文字的高度
    CGSize linesSz = [self.questionLbl.text sizeWithFont:self.questionLbl.font
                                       constrainedToSize:CGSizeMake(self.questionLbl.frame.size.width, MAXFLOAT)
                                           lineBreakMode:NSLineBreakByCharWrapping];
    
    //判读是否换行
    if( sz.width <= linesSz.width ){
        lastPoint = CGPointMake(self.questionLbl.frame.origin.x + sz.width, self.questionLbl.frame.origin.y);
    }else{
        lastPoint = CGPointMake(self.questionLbl.frame.origin.x + (int)sz.width % (int)linesSz.width,linesSz.height - sz.height);
    }
    return lastPoint;
}
@end
