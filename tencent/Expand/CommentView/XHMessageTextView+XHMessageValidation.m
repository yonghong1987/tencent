//
//  XHMessageTextView+XHMessageValidation.m
//  sunMobile
//
//  Created by duck on 16/8/29.
//  Copyright © 2016年 www.sunontalent.com. All rights reserved.
//

#import "XHMessageTextView+XHMessageValidation.h"
#import "MBProgressHUD+SMHUD.h"
#import "UIView+ViewController.h"
#import <objc/runtime.h>

const char textFiledMaxLenthKey;
const char textFilederrorMesgKey;

@interface XHMessageTextView ()<UITextViewDelegate>
@property (nonatomic,assign)NSUInteger maxLenth;
@property (nonatomic,copy) NSString * errorMesg;
@end

@implementation XHMessageTextView (XHMessageValidation)

- (void)setMaxLenth:(NSUInteger)maxLenth{
    
    objc_setAssociatedObject(self, &textFiledMaxLenthKey, @(maxLenth), OBJC_ASSOCIATION_COPY_NONATOMIC);
}
-(NSUInteger)maxLenth{
    NSNumber * lenth = objc_getAssociatedObject(self, &textFiledMaxLenthKey);
    return [lenth integerValue];
}

- (void)setErrorMesg:(NSString *)errorMesg{
        objc_setAssociatedObject(self, &textFilederrorMesgKey,errorMesg, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
-(NSString *)errorMesg{
    return  objc_getAssociatedObject(self, &textFilederrorMesgKey);
}

- (void)setMaxLenth:(NSUInteger)maxLenth withErrorMesg:(NSString *)mesg{
    
    self.maxLenth = maxLenth;
    self.errorMesg = mesg;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewEditChanged:) name:UITextViewTextDidChangeNotification object:self];
}

// 监听文本改变
-(void)textViewEditChanged:(NSNotification *)obj{
    UITextView *textView = (UITextView *)obj.object;
    NSString *toBeString = textView.text;
    NSString *lang = [[UIApplication sharedApplication]textInputMode].primaryLanguage;
//    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textView markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > self.maxLenth) {
                textView.text = [toBeString substringToIndex:self.maxLenth];
            }
        }else{
         // 有高亮选择的字符串，则暂不对文字进行统计和限制
        }
    }else{
        
        // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        if (toBeString.length > self.maxLenth) {
            
            textView.text = [toBeString substringToIndex:self.maxLenth];
            [self resignFirstResponder];
           
            [MBProgressHUD showToView:self.viewController.view text:self.errorMesg afterDelay:1 hideBlock:^(MBProgressHUD * _Nonnull hud) {
                [self becomeFirstResponder];
            }];
        }
        
    }
}


- (BOOL)validWithError:(NSString *)mesg{
    
    if (self.text.length) {
        return YES;
    }
    MBProgressHUD * hud = [MBProgressHUD showToView:self.viewController.view.window text:mesg afterDelay:2 hideBlock:nil];
    hud.label.font =[UIFont systemFontOfSize:13];
    
    return NO;
}
@end
