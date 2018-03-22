//
//  BLDropMenu.m
//  BLDropMenu
//
//  Created by 武文强 on 2018/3/22.
//  Copyright © 2018年 武文强. All rights reserved.
//

#import "BLDropMenu.h"
#define animateTimes 0.25f
@implementation BLDropMenu
{
    UIImageView *arrowView;//箭头图标
    UIView *backView;//背景View
    UITableView *tableView;
    
    NSArray *_titles;//选项数组
    CGFloat _height;//列表行高
}
/*
 初始化调用
 */
- (id)initWithFrame:(CGRect)frame andMenuType:(BLDropMenuType)type{
    self = [super initWithFrame:frame];
    if (self) {
        self.menuType=type;
        [self createMenuButtonWithFrame:frame];
    }
    return self;
}
/*
 初始化调用，默认向下伸展
 */
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self)
        [self createMenuButtonWithFrame:frame];
    return self;
}
/*
 设置frame
 */
- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self createMenuButtonWithFrame:frame];
}

/*
 定义样式
 */
- (void)createMenuButtonWithFrame:(CGRect)frame{
    [_menuButton removeFromSuperview];
    _menuButton = nil;
    _menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_menuButton setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    [_menuButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_menuButton setTitle:@"请选择" forState:UIControlStateNormal];
    [_menuButton addTarget:self action:@selector(menuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    _menuButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _menuButton.titleLabel.font=[UIFont systemFontOfSize:14.f];
    _menuButton.titleEdgeInsets=UIEdgeInsetsMake(0, 15, 0, 0);
    _menuButton.selected=NO;
    _menuButton.backgroundColor=[UIColor whiteColor];
    _menuButton.layer.borderColor=[UIColor lightGrayColor].CGColor;
    _menuButton.layer.borderWidth=0.5;
    [_menuButton.layer setMasksToBounds:YES];
    [_menuButton.layer setCornerRadius:5.0];
    [self addSubview:_menuButton];
    
    // 旋转箭头
    arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(_menuButton.frame.size.width -15, 0, 12, 7)];
    arrowView.center = CGPointMake(arrowView.center.x, _menuButton.bounds.size.height/2);
    if(_menuType==BLDropMenuUp)
        arrowView.image  = [UIImage imageNamed:@"bl_up"];
    else
        arrowView.image  = [UIImage imageNamed:@"bl_down"];
    [_menuButton addSubview:arrowView];
}
/*
 点击选择
 */
- (void)menuButtonClick:(UIButton *)button{
    [self.superview addSubview:backView];
    if(button.selected == NO)
        [self showMenu];
    else
        [self hideMenu];
}
/*
 设置样式
 */
- (void)setMenuTitles:(NSArray *)titles rowHeight:(CGFloat)height{
    if (self == nil)
        return;
    _titles=[titles copy];
    _height=height;
    
    backView=[[UIView alloc] init];
    if(_menuType==BLDropMenuUp)
        backView.frame = CGRectMake(self.frame.origin.x , self.frame.origin.y, self.bounds.size.width,  0);
    else
        backView.frame = CGRectMake(self.frame.origin.x , self.frame.origin.y+self.bounds.size.height, self.bounds.size.width, 0);
    backView.clipsToBounds=YES;
    backView.layer.masksToBounds=NO;
    backView.layer.borderColor=[UIColor lightTextColor].CGColor;
    backView.layer.borderWidth=0.5f;
    [backView.layer setMasksToBounds:YES];
    [backView.layer setCornerRadius:5.0];
    
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,backView.bounds.size.width, backView.bounds.size.height)];
    tableView.delegate= self;
    tableView.dataSource= self;
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    tableView.bounces= NO;
    [backView addSubview:tableView];
}
/*
 显示菜单
 */
- (void)showMenu{
    [backView.superview bringSubviewToFront:backView];
    if (_delegate && [_delegate respondsToSelector:@selector(menuWillShow:)])
        [_delegate menuWillShow:self];
    [UIView animateWithDuration:animateTimes animations:^{
        arrowView.transform = CGAffineTransformMakeRotation(M_PI);
        if(_menuType==BLDropMenuUp)
            backView.frame  = CGRectMake(backView.frame.origin.x, backView.frame.origin.y-_height *_titles.count, backView.bounds.size.width, _height *_titles.count);
        else
            backView.frame  = CGRectMake(backView.frame.origin.x, backView.frame.origin.y, backView.bounds.size.width, _height *_titles.count);
        tableView.frame = CGRectMake(0, 0, backView.bounds.size.width, backView.bounds.size.height);
    }completion:^(BOOL finished) {
        if (_delegate && [_delegate respondsToSelector:@selector(menuDidShow:)])
            [_delegate menuDidShow:self];
    }];
    _menuButton.selected = YES;
}
/*
 隐藏菜单
 */
- (void)hideMenu{
    if (_delegate && [_delegate respondsToSelector:@selector(menuWillHidden:)])
        [_delegate menuWillHidden:self];
    [UIView animateWithDuration:animateTimes animations:^{
        arrowView.transform = CGAffineTransformIdentity;
        if(_menuType==BLDropMenuUp)
            backView.frame  = CGRectMake(backView.frame.origin.x, self.frame.origin.y, backView.bounds.size.width, 0);
        else
            backView.frame = CGRectMake(backView.frame.origin.x, self.frame.origin.y+self.bounds.size.height, backView.bounds.size.width, 0);
        tableView.frame = CGRectMake(0, 0, backView.bounds.size.width, backView.bounds.size.height);
    }completion:^(BOOL finished) {
        if (_delegate && [_delegate respondsToSelector:@selector(menuDidHidden:)])
            [_delegate menuDidHidden:self];
    }];
    _menuButton.selected = NO;
}
#pragma mark
#pragma mark - UITableViewDataSource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_titles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor=[UIColor lightGrayColor];
        cell.textLabel.font=[UIFont systemFontOfSize:11.f];
        cell.textLabel.textColor =[UIColor blackColor];
        cell.selectionStyle= UITableViewCellSelectionStyleGray;
    }
    cell.textLabel.text =[_titles objectAtIndex:indexPath.row];
    return cell;
}
#pragma mark
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [_menuButton setTitle:cell.textLabel.text forState:UIControlStateNormal];
    if (_delegate && [_delegate respondsToSelector:@selector(dropMenu:selectedNumber:)])
        [_delegate dropMenu:self selectedNumber:indexPath.row];
    if(_selectedMenu)
        _selectedMenu(indexPath.row);
    [self hideMenu];
}

@end
