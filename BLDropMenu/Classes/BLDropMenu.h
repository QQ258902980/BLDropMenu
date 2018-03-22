//
//  BLDropMenu.h
//  BLDropMenu
//
//  Created by 武文强 on 2018/3/22.
//  Copyright © 2018年 武文强. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BLDropMenuType) {
    /// 默认类型,向下伸展
    BLDropMenuDown = 0,
    /// 向上伸展
    BLDropMenuUp = 1,
};

@class BLDropMenu;
@protocol BLDropMenuDelegate <NSObject>
@optional
- (void)menuWillShow:(BLDropMenu *)menu; //当菜单将要显示时调用
- (void)menuDidShow:(BLDropMenu *)menu; //当菜单已经显示时调用
- (void)menuWillHidden:(BLDropMenu *)menu; //当菜单将要收起时调用
- (void)menuDidHidden:(BLDropMenu *)menu; //当菜单已经收起时调用
- (void)dropMenu:(BLDropMenu *)menu selectedNumber:(NSInteger)number; //当选择某个选项时调用
@end
@interface BLDropMenu : UIView<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UIButton * menuButton;//点击展开的Button
@property (nonatomic,assign) BLDropMenuType menuType;//菜单打开类型
@property (nonatomic, unsafe_unretained) id <BLDropMenuDelegate>delegate;
@property (nonatomic, copy)void (^selectedMenu)(NSInteger number);
- (id)initWithFrame:(CGRect)frame andMenuType:(BLDropMenuType)type;//初始化直接设置
- (void)setMenuTitles:(NSArray *)titles rowHeight:(CGFloat)height;  //设置样式
- (void)showMenu; //显示菜单
- (void)hideMenu; //隐藏菜单

@end
