//
//  SMHomeViewController.h
//  sunMobile
//
//  Created by duck on 16/3/17.
//  Copyright © 2016年 www.sunontalent.com. All rights reserved.
//

#import "UIBarButtonItem+Common.h"
#import "UIView+Frame.h"
#import <objc/runtime.h>

static const void *ItemActionBlockKey = &ItemActionBlockKey;
static const void *IsHighlightedKey = &IsHighlightedKey;

@implementation UIBarButtonItem (Common)

#pragma mark -  Create UIBarButtonItem

- (void)setLocaString:(NSString *)locaString{
    self.title = NSLocalizedString(locaString, nil);
}
- (NSString *)locaString{
    return self.title;
}

+ (UIBarButtonItem *)itemWithBtnTitle:(NSString *)title target:(id)obj action:(SEL)selector{
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:obj action:selector];
    [buttonItem setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]} forState:UIControlStateDisabled];
    return buttonItem;
}

+ (UIBarButtonItem *)itemWithIcon:(NSString*)iconName showBadge:(BOOL)showbadge target:(id)obj action:(SEL)selector {
    UIButton* button = [[UIButton alloc] init];
    button.imageEdgeInsets = UIEdgeInsetsMake(-2, 0, 0, 0);
    [button setImage:[UIImage imageNamed:iconName] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:iconName] forState:UIControlStateHighlighted];
    CGSize imgSize = button.imageView.image.size;
    button.size = CGSizeMake(imgSize.width, imgSize.height);
    
    [button addTarget:obj action:selector forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:button];;
}

+ (UIBarButtonItem *)itemWithBtnTitle:(NSString *)title actionBolock:(ItemActonBlock)actionBlock{
    
    
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] init];
     objc_setAssociatedObject(buttonItem, ItemActionBlockKey, actionBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    buttonItem.title = title;
    buttonItem.target = buttonItem;
    buttonItem.action = @selector(itemBarbuttom:);
    buttonItem.tintColor = [UIColor whiteColor];
    [buttonItem setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]} forState:UIControlStateDisabled];
    return buttonItem;
}

+ (UIBarButtonItem *)itemWithIcon:(NSString*)iconName showBadge:(BOOL)showbadge actionBolock:(ItemActonBlock)actionBlock {
    
    return [UIBarButtonItem itemWithIcon:iconName highlightedIcon:iconName showBadge:showbadge actionBolock:actionBlock];
}


+ (UIBarButtonItem *)itemWithIcon:(NSString*)iconName highlightedIcon:(NSString *)hIconName showBadge:(BOOL)showbadge count:(NSInteger)count actionBolock:(ItemActonBlock)actionBlock{
    
    UIButton* button = [[UIButton alloc] init];
    button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [button setImage:[UIImage imageNamed:iconName] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:hIconName] forState:UIControlStateSelected];
    CGSize imgSize = button.imageView.image.size;
    button.size = CGSizeMake(imgSize.width, imgSize.height);
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    [button addTarget:item action:@selector(itemAction:) forControlEvents:UIControlEventTouchUpInside];
    if (count > 0) {
        if (showbadge) {
            UILabel *badgeLabel = [[UILabel alloc]init];
            badgeLabel.frame = CGRectMake(10, -5, 14, 14);
            badgeLabel.textColor = [UIColor whiteColor];
            badgeLabel.font = [UIFont systemFontOfSize:11.0];
            badgeLabel.backgroundColor = [[UIColor redColor]colorWithAlphaComponent:0.8];
            badgeLabel.text = [NSString stringWithFormat:@"%ld",count];
            badgeLabel.layer.cornerRadius = 7;
            badgeLabel.textAlignment = NSTextAlignmentCenter;
            badgeLabel.layer.masksToBounds = YES;
            [button addSubview:badgeLabel];
        }
    }
    
    objc_setAssociatedObject(button, ItemActionBlockKey, actionBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    return item;
    
    
}

#pragma mark - UIBarButtonItem Action
- (void)itemBarbuttom:(UIBarButtonItem *)btem{
    
    void(^ItemActonBlock)(UIBarButtonItem *) = objc_getAssociatedObject(btem, ItemActionBlockKey);
    if (ItemActonBlock)
        ItemActonBlock(self);
}

- (void)itemAction:(UIButton *)sender{

   void(^ItemActonBlock)(UIBarButtonItem *) = objc_getAssociatedObject(sender, ItemActionBlockKey);
    if (ItemActonBlock)
        ItemActonBlock(self);
}

#pragma mark - property
- (void)setIsHighlighted:(BOOL)isHighlighted{
    objc_setAssociatedObject(self, &IsHighlightedKey, @(isHighlighted),OBJC_ASSOCIATION_ASSIGN);

    UIButton *button = self.customView;
    button.selected = isHighlighted;
}
- (BOOL)isHighlighted{
    NSNumber *num = objc_getAssociatedObject(self, &IsHighlightedKey);
    return [num boolValue];
}
@end
