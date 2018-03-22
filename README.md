# BLDropMenu
仿网页下拉选择框

 //向上伸展
 
    BLDropMenu * dropUpMenu = [[BLDropMenu alloc] init];
    dropUpMenu.menuType=BLDropMenuUp;
    [dropUpMenu setFrame:CGRectMake(100, 200, 105, 30)];
    [dropUpMenu setMenuTitles:@[@"100金币",@"1000金币",@"10000金币"] rowHeight:30];
    dropUpMenu.delegate = self;
    [self.view addSubview:dropUpMenu];
    
    //向下伸展（换一种回调方式：不用委托，直接selectedMenu参数，两种回调方法，根据自已的实际情况调用即可）
    
    BLDropMenu * dropDownMenu = [[BLDropMenu alloc] initWithFrame:CGRectMake(100, 300, 105, 30) andMenuType:BLDropMenuDown];
    [dropDownMenu setMenuTitles:@[@"100金币",@"1000金币",@"10000金币"] rowHeight:30];
    dropDownMenu.selectedMenu = ^(NSInteger number) {
        NSLog(@"我选择了第%ld个...",number);
    };
    [self.view addSubview:dropDownMenu];
    
    
    #pragma mark
#pragma mark - BLDropMenuDelegate
//当菜单将要显示时调用
- (void)menuWillShow:(BLDropMenu *)menu{
    
}
//当菜单已经显示时调用
- (void)menuDidShow:(BLDropMenu *)menu{
    
}
//当菜单将要收起时调用
- (void)menuWillHidden:(BLDropMenu *)menu{
    
}
//当菜单已经收起时调用
- (void)menuDidHidden:(BLDropMenu *)menu{
    
}
//当选择某个选项时调用
- (void)dropMenu:(BLDropMenu *)menu selectedNumber:(NSInteger)number{
    NSLog(@"我选择了第%ld个...",number);
}
