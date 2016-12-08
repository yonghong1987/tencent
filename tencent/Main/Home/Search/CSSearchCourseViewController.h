//
//  CSSearchCourseViewController.h
//  tencent
//
//  Created by cyh on 16/10/27.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSBaseViewController.h"

typedef NS_ENUM(NSInteger, CSSearchType) {
    CSSearchCourseType,//热门课程
    CSSearchSpecialType,//专题
    CSSearchRepositoryType,//知识库
};
@interface CSSearchCourseViewController : CSBaseViewController<UISearchBarDelegate>
@property (nonatomic, assign) CSBaseViewController *rootVC;
;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, assign) CSSearchType searchType;
@property (nonatomic, copy) NSString *searchWord;
@end
