//
//  CSStudyCaseDetailViewController.h
//  tencent
//
//  Created by admin on 16/5/18.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSBaseViewController.h"
#import "CSConfig.h"
#import "CSFrameConfig.h"
#import "SMBaseTableView.h"
#import "CSTableHeadWebView.h"
#import "CSFrameConfig.h"
#import "CSCommitCaseAnswerView.h"
#import "CSCaseCommentView.h"
#import "CSReplyTextView.h"
#import "CSSpecialCommentViewController.h"
#import "UIBarButtonItem+Common.h"
#import "CSHttpRequestManager.h"
#import "ConstFile.h"
#import "CSUrl.h"
#import "CSStudyCaseDetailModel.h"
#import "CSOptionModel.h"
#import "CSSubjectiveAnswerCell.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "CSGlobalMacro.h"
#import "CSAskAndAnswerCell.h"
#import "CSRadioAnswerCell.h"
#import "CSRadioCell.h"
#import "CSMultiselectCell.h"
#import "CSMultiselectAnswerCell.h"
#import "CSJudgeCell.h"
#import "CSFillBlankCell.h"
#import "CSDisplayWitchTitleModel.h"
#import "CSCaseDetailCellDataModel.h"
#import "CSSpecialCommentModel.h"
#import "MBProgressHUD+SMHUD.h"
#import "MBProgressHUD+CYH.h"
#import "CSReplyCommentModel.h"
#import "CSCommentCell.h"
#import "CSToolButtonView.h"
#import "CSColorConfig.h"
#import "CSReplyCommentCell.h"
#import "NSDictionary+convenience.h"
#import "SMGlobalApi.h"
#import "CSJudgeAnswerCell.h"
@interface CSStudyCaseDetailViewController : CSBaseViewController
/*
**案列id
 */
@property (nonatomic, strong) NSNumber *caseId;
@end
