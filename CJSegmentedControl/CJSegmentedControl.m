//
//  CJSegmentedControl.h
//  CommonProject
//
//  Created by zhuChaojun的Mac on 2017/2/7.
//  Copyright © 2017年 zhucj. All rights reserved.
//

#import "CJSegmentedControl.h"

@interface _CJButton : UIButton



@end

@implementation _CJButton

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.nextResponder touchesBegan:touches withEvent:event];
}

-(void)layoutSubviews {
    [super layoutSubviews];
}

@end

/**************************************************************************************/
@interface CJSegmentedControl () {

    // 标题
    NSArray<NSString *> *_titles;
    // 图片名字
    NSArray<NSString *> *_imageNames;
    
    // 内容宽度
    CGFloat _contentWidth;
}

// 标题宽度
@property(nonatomic, strong) NSMutableArray<_CJButton *> *segmentAry;

// 记录上次点击的按钮
@property(nonatomic, weak) _CJButton *previousBtn;
// 分割线，如果有的话
@property(nonatomic, weak) UIView *indicatorV;


@end

@implementation CJSegmentedControl

-(instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame titles:nil];
}

-(instancetype)initWithFrame:(CGRect)frame titles:(NSArray<NSString *> *)titles{
    self = [super initWithFrame:frame];
    if (!self) return nil;
    _titles = titles;
    _segmentedContentType = CJSegmentedControlContentTypeText;
    [self configSegmentedControl]; 
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame images:(NSArray<NSString *> *)imageNames {
    self = [super initWithFrame:frame];
    if (!self) return nil;
    _titles = imageNames;
    _segmentedContentType = CJSegmentedControlContentTypeImage;
    
    [self configSegmentedControl];
    return self;
}


-(instancetype)initWithFrame:(CGRect)frame titlesAndImages:(NSDictionary<NSString *,NSString *> *)contents {
    self = [super initWithFrame:frame];
    if (!self) return nil;
    _imageNames = contents.allValues;
    _titles     = contents.allKeys;
    _segmentedContentType = CJSegmentedControlContentTypeTextAndImage;

    [self configSegmentedControl];
    return self;
}


-(void)configSegmentedControl {
    _contentWidth  = self.frame.size.width / _titles.count;
    
    _selectIndex   = 0;
    _segmentNormalColor = [UIColor whiteColor];
    _segmentSelectedColor = [UIColor lightGrayColor];
    _indicatorColor     = [UIColor purpleColor];
    _textNomalColor     = [UIColor blackColor];
    _textSelectedColor  = [UIColor whiteColor];
    _indicatorPosition  = CJSegmentedIndicatorPositionBottom;
    _indicatorStyle     = CJSegmentedIndicatorStyleAdjust;
    _separateEnable     = NO;
    _indicatorEnable    = YES;
    _indicatorHeight    = 2.0f;
    self.backgroundColor = _segmentSelectedColor;
    
}



#pragma mark --- systerm method
-(void)drawRect:(CGRect)rect {
    NSParameterAssert(_titles.count);
    if (_selectIndex >= _titles.count) {
        [NSException raise:NSRangeException format:@"selctIndex beyond titles count"];
    }
    
    for (int i = 0; i < _titles.count; i++) {
        _CJButton *btn  = [_CJButton buttonWithType:UIButtonTypeCustom];
        CGRect btnFrame = CGRectZero;
        if (_indicatorEnable) {
            if (_indicatorPosition == CJSegmentedIndicatorPositionBottom) {
                btnFrame = CGRectMake(i * _contentWidth , 0 , _contentWidth, CGRectGetHeight(self.frame));
            }else if (_indicatorPosition == CJSegmentedIndicatorPositionTop) {
                btnFrame = CGRectMake(i * _contentWidth , _indicatorHeight , _contentWidth, CGRectGetHeight(self.frame));
            }
        }else {
            btnFrame = CGRectMake(i * _contentWidth , 0 , _contentWidth, CGRectGetHeight(self.frame));
        }
        btn.frame = btnFrame;
        if (_segmentedContentType == CJSegmentedControlContentTypeText) {
            [btn setTitle:_titles[i] forState:UIControlStateNormal];
        }else if (_segmentedContentType == CJSegmentedControlContentTypeImage) {
            [btn setImage:[UIImage imageNamed:_titles[i]] forState:UIControlStateNormal];
        }else if (_segmentedContentType == CJSegmentedControlContentTypeTextAndImage) {
            [btn setTitle:_titles[i] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:_imageNames[i]] forState:UIControlStateNormal];
            [btn setImageEdgeInsets:UIEdgeInsetsMake(-btn.titleLabel.intrinsicContentSize.height, 0, 0, -btn.titleLabel.intrinsicContentSize.width)];
            [btn setTitleEdgeInsets:UIEdgeInsetsMake(btn.currentImage.size.height, -btn.currentImage.size.width, 0, 0)];
        }
        
        btn.backgroundColor = _segmentNormalColor;
        [btn setTitleColor:_textNomalColor forState:UIControlStateNormal];
        [self addSubview:btn];
        [self.segmentAry addObject:btn];
    }
    _previousBtn = self.segmentAry[_selectIndex];
    _previousBtn.backgroundColor = _segmentSelectedColor;
    [_previousBtn setTitleColor:_textSelectedColor forState:UIControlStateNormal];
    
    if (_indicatorEnable) {
        UIView *indicateV = [UIView new];
        indicateV.backgroundColor = _indicatorColor;
        [self addSubview:indicateV];
        _indicatorV = indicateV;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self handleIndicatorFrameDependentButton:_previousBtn];
    });

}




-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point  = [touch locationInView:self];
    _selectIndex   = point.x / _contentWidth;
    if (point.x == self.frame.size.width) _selectIndex--;
    
    [self changeNormalAndSelectedState:_selectIndex];
   
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}


-(void)changeNormalAndSelectedState:(NSInteger)index {
    _CJButton *currentBtn = self.segmentAry[index];
    if (_previousBtn == currentBtn) return;
    [UIView animateWithDuration:0.3f animations:^{
        [self handleIndicatorFrameDependentButton:currentBtn];
        
        currentBtn.backgroundColor = _segmentSelectedColor;
        [currentBtn setTitleColor:_textSelectedColor forState:UIControlStateNormal];
        
        _previousBtn.backgroundColor = _segmentNormalColor;
        [_previousBtn setTitleColor:_textNomalColor forState:UIControlStateNormal];
    }];
    
    _previousBtn = currentBtn;
}
#pragma mark --- private method
-(void)handleIndicatorFrameDependentButton:(_CJButton *)button {
    if (_indicatorStyle == CJSegmentedIndicatorStyleFix) {
        if (_indicatorPosition == CJSegmentedIndicatorPositionBottom) {
            _indicatorV.frame   = CGRectMake(CGRectGetMinX(button.frame), CGRectGetMaxY(button.frame)-_indicatorHeight, _contentWidth, _indicatorHeight);
            
        }else if (_indicatorPosition == CJSegmentedIndicatorPositionTop) {
            _indicatorV.frame   = CGRectMake(CGRectGetMinX(button.frame), 0, _contentWidth, _indicatorHeight);
            
        }
        return;
    }
    
    if (_segmentedContentType == CJSegmentedControlContentTypeText ||
        _segmentedContentType == CJSegmentedControlContentTypeTextAndImage) {
        
        if (_indicatorPosition == CJSegmentedIndicatorPositionBottom) {
            _indicatorV.frame   = CGRectMake(CGRectGetMinX(button.titleLabel.frame) + CGRectGetMinX(button.frame), CGRectGetMaxY(button.frame)-_indicatorHeight, CGRectGetWidth(button.titleLabel.frame), _indicatorHeight);
            
        }else if (_indicatorPosition == CJSegmentedIndicatorPositionTop) {
            _indicatorV.frame   = CGRectMake(CGRectGetMinX(button.titleLabel.frame) + CGRectGetMinX(button.frame), 0, CGRectGetWidth(button.titleLabel.frame), _indicatorHeight);
            
        }
        
    }else if (_segmentedContentType == CJSegmentedControlContentTypeImage) {
        
        if (_indicatorPosition == CJSegmentedIndicatorPositionBottom) {
            _indicatorV.frame   = CGRectMake(CGRectGetMinX(button.imageView.frame) + CGRectGetMinX(button.frame), CGRectGetMaxY(button.frame)-_indicatorHeight, CGRectGetWidth(button.imageView.frame), _indicatorHeight);
            
        }else if (_indicatorPosition == CJSegmentedIndicatorPositionTop) {
            _indicatorV.frame   = CGRectMake(CGRectGetMinX(button.imageView.frame) + CGRectGetMinX(button.frame), 0, CGRectGetWidth(button.imageView.frame), _indicatorHeight);
            
        }
        
    }
   
}

-(void)setSegmentSelectedColor:(UIColor *)segmentSelectedColor {
    _segmentSelectedColor = segmentSelectedColor;
    self.backgroundColor = segmentSelectedColor;
}


#pragma mark --- lazy
-(NSMutableArray *)segmentAry {
    if (!_segmentAry) {
        _segmentAry = [NSMutableArray array];
    }
    return _segmentAry;
}


@end
