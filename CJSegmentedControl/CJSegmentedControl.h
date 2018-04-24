//
//  CJSegmentedControl.h
//  CommonProject
//
//  Created by zhuChaojun的Mac on 2017/2/7.
//  Copyright © 2017年 zhucj. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, CJSegmentedIndicatorPosition) {
    CJSegmentedIndicatorPositionBottom = 0, // default is bottom
    CJSegmentedIndicatorPositionTop    = (1 << 0)
};

typedef NS_ENUM(NSUInteger, CJSegmentedIndicatorStyle) {
    CJSegmentedIndicatorStyleFix    = 0, // default is fix
    CJSegmentedIndicatorStyleAdjust = (1 << 0)
};

typedef NS_ENUM(NSUInteger, CJSegmentedControlContentType) {
    CJSegmentedControlContentTypeText         = 0,
    CJSegmentedControlContentTypeImage        = 1<<0,
    CJSegmentedControlContentTypeTextAndImage = 1<<1
};

@interface CJSegmentedControl : UIControl

/// selcetindex ，default is 0.
@property (nonatomic, assign) NSInteger selectIndex;


/// font size , default is 15.
@property (nonatomic, assign) NSInteger fontSize;

/// text nomal color ,default is black.
@property(nonatomic, strong) UIColor *textNomalColor;

/// text selected color , default is white.
@property(nonatomic, strong) UIColor *textSelectedColor;

/// segment nomal color， default is white.
@property(nonatomic, strong) UIColor *segmentNormalColor;

/// segment selected color， default is lightgray.
@property(nonatomic, strong) UIColor *segmentSelectedColor;

/// if has separate，default is NO.
@property (nonatomic, assign, getter=isSeparateEnable) BOOL separateEnable;

/// separate color ， if separateEnable is set , we can set it ,default is black.
@property(nonatomic, strong) UIColor *separateColor;

/// separate width , default is 1.
@property (nonatomic, assign) CGFloat separateWidth;

/// separte height , default is same of segmented.
@property (nonatomic, assign) CGFloat separateHeight;

/// is has indicator ,default is yes.
@property (nonatomic, assign, getter=isIndicatorEnable) BOOL indicatorEnable;

/// indicator color ,default is purpue.
@property(nonatomic, strong) UIColor *indicatorColor;

/// indicator height , default is 2.
@property (nonatomic, assign) CGFloat indicatorHeight;

/// indicator style , default is fix.
@property (nonatomic, assign) CJSegmentedIndicatorStyle indicatorStyle;

/// indicator Position ， default is bottom.
@property (nonatomic, assign) CJSegmentedIndicatorPosition indicatorPosition;

/// segment content type 
@property (nonatomic, assign) CJSegmentedControlContentType segmentedContentType;

/**
 初始化

 @param frame frame
 @param titles 如果内容去不是text
 @return self
 */
-(instancetype)initWithFrame:(CGRect)frame titles:(NSArray<NSString *> *)titles;


/**
 初始化

 @param frame frame
 @param imageNames 如果内容全部是Image，传imageName
 @return self
 */
-(instancetype)initWithFrame:(CGRect)frame images:(NSArray<NSString *> *)imageNames;


/**
 初始化

 @param frame frame
 @param contents 文字和图片字典,其中key表示文字，value表示图片名字
 @return self
 */
-(instancetype)initWithFrame:(CGRect)frame titlesAndImages:(NSDictionary<NSString *,NSString *> *)contents;


/**
 改变正常和选中的状态

 @param index index--表示第几个item
 */
-(void)changeNormalAndSelectedState:(NSInteger)index;
@end
