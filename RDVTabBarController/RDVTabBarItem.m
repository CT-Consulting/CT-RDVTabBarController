// RDVTabBarItem.h
// RDVTabBarController
//
// Copyright (c) 2013 Robert Dimitrov
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "RDVTabBarItem.h"

@interface RDVTabBarItem () {
    NSString *_title;
}
/// The offset for the rectangle around the tab bar item's content.
@property (assign, nonatomic) UIEdgeInsets contentOffset;
/// The offset between image view and Title Label.
@property (assign, nonatomic) CGFloat imageTitleOffset;
/// The title attributes dictionary used for tab bar item's unselected state.
@property (strong, nonatomic, nullable) NSDictionary *unselectedTitleAttributes;
/// The title attributes dictionary used for tab bar item's selected state.
@property (strong, nonatomic, nullable) NSDictionary *selectedTitleAttributes;

@property (strong, nonatomic, nullable) UIImage *unselectedBackgroundImage;
@property (strong, nonatomic, nullable) UIImage *selectedBackgroundImage;
@property (strong, nonatomic, nullable) UIImage *unselectedImage;
@property (strong, nonatomic, nullable) UIImage *selectedImage;

@end

@implementation RDVTabBarItem

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInitialization];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInitialization];
    }
    return self;
}

- (id)init {
    return [self initWithFrame:CGRectZero];
}

- (void)commonInitialization {
    // Setup defaults
    [self setBackgroundColor:[UIColor clearColor]];
    _title = @"";
    self.contentOffset = UIEdgeInsetsMake(2, 2, 2, 2);
    self.imageTitleOffset = 6;
    [self setUnselectedTitleAttributes:@{ NSFontAttributeName: [UIFont systemFontOfSize:12],
                                          NSForegroundColorAttributeName: [UIColor blackColor] }
                    selectedAttributes:nil];
    self.badgeBackgroundColor = [UIColor redColor];
    self.badgeTextColor = [UIColor whiteColor];
    self.badgeTextFont = [UIFont systemFontOfSize:12];
    self.badgePositionAdjustment = UIOffsetZero;
    
    [self setupContentView];
}

#pragma mark - State

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    [self setupImageForState:selected];
    [self setupTitleWithValue:_title forState:selected];
}

- (void)setupImageForState:(BOOL)isSelected {
    self.imageView.image = isSelected ? [self selectedImage] : [self unselectedImage];
}

- (void)setupTitleWithValue:(nullable NSString *)title forState:(BOOL)isSelected {
    NSDictionary *attributes = isSelected ? [self selectedTitleAttributes] : [self unselectedTitleAttributes];
    self.titleLabel.attributedText = [[NSAttributedString alloc] initWithString:title ? : @""
                                                                     attributes:attributes];
}

#pragma mark - UI Elements

- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [UIImageView new];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.userInteractionEnabled = NO;
    }
    
    return _imageView;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [UILabel new];
        _titleLabel.numberOfLines = 0;
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _titleLabel.userInteractionEnabled = NO;
    }
    
    return _titleLabel;
}

- (void)setupContentView {
    UIStackView *contentView = [[UIStackView alloc] initWithArrangedSubviews:@[self.imageView, self.titleLabel]];
    contentView.axis = UILayoutConstraintAxisHorizontal;
    contentView.spacing = self.imageTitleOffset;
    contentView.alignment = UIStackViewAlignmentCenter;
    contentView.distribution = UIStackViewDistributionEqualSpacing;
    contentView.userInteractionEnabled = NO;
    [self addSubview:contentView];
    
    // setup Content View constraints
    contentView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:contentView
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1
                                                      constant:self.contentOffset.top]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                     attribute:NSLayoutAttributeBottom
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:contentView
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1
                                                      constant:self.contentOffset.bottom]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:contentView
                                                     attribute:NSLayoutAttributeLeading
                                                     relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeading
                                                    multiplier:1
                                                      constant:self.contentOffset.left]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                     attribute:NSLayoutAttributeTrailing
                                                     relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                        toItem:contentView
                                                     attribute:NSLayoutAttributeTrailing
                                                    multiplier:1
                                                      constant:self.contentOffset.right]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:contentView
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1
                                                      constant:0]];
    
    // setup Image View constraints
    [self.imageView addConstraint:[NSLayoutConstraint constraintWithItem:self.imageView
                                                               attribute:NSLayoutAttributeHeight
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:nil
                                                               attribute:nil
                                                              multiplier:1
                                                                constant:24]];
    
    [self.imageView addConstraint:[NSLayoutConstraint constraintWithItem:self.imageView
                                                               attribute:NSLayoutAttributeWidth
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:nil
                                                               attribute:nil
                                                              multiplier:1
                                                                constant:24]];
}

- (void)layoutSubviews {
     [self.titleLabel setNeedsUpdateConstraints];
     [super layoutSubviews];
 }

#pragma mark - UIViewRendering

- (void)drawRect:(CGRect)rect {
    CGSize frameSize = self.frame.size;
    UIImage *backgroundImage = self.isSelected ? [self selectedBackgroundImage] : [self unselectedBackgroundImage];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    [backgroundImage drawInRect:self.bounds];
    
    // Draw badges
    if ([self badgeValue]) {
        CGSize badgeSize = CGSizeZero;
        
        badgeSize = [_badgeValue boundingRectWithSize:CGSizeMake(frameSize.width, self.badgeTextFont.pointSize + 6)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:@{ NSFontAttributeName: self.badgeTextFont }
                                              context:nil].size;
        
        CGFloat textOffset = 2.0f;
        
        if (badgeSize.width < badgeSize.height) {
            badgeSize = CGSizeMake(badgeSize.height, badgeSize.height);
        }
        
        CGRect badgeBackgroundFrame = CGRectMake(textOffset + [self badgePositionAdjustment].horizontal,
                                                 textOffset + [self badgePositionAdjustment].vertical,
                                                 badgeSize.width + 2 * textOffset,
                                                 badgeSize.height + 2 * textOffset);
        
        if ([self badgeBackgroundColor]) {
            CGContextSetFillColorWithColor(context, [[self badgeBackgroundColor] CGColor]);
            CGContextFillEllipseInRect(context, badgeBackgroundFrame);
            
        } else if ([self badgeBackgroundImage]) {
            [[self badgeBackgroundImage] drawInRect:badgeBackgroundFrame];
        }
        
        CGContextSetFillColorWithColor(context, [[self badgeTextColor] CGColor]);
        
        NSMutableParagraphStyle *badgeTextStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
        [badgeTextStyle setLineBreakMode:NSLineBreakByWordWrapping];
        [badgeTextStyle setAlignment:NSTextAlignmentCenter];
        
        NSDictionary *badgeTextAttributes = @{
            NSFontAttributeName: [self badgeTextFont],
            NSForegroundColorAttributeName: [self badgeTextColor],
            NSParagraphStyleAttributeName: badgeTextStyle,
        };
        
        [[self badgeValue] drawInRect:CGRectMake(CGRectGetMinX(badgeBackgroundFrame) + textOffset,
                                                 CGRectGetMinY(badgeBackgroundFrame) + textOffset,
                                                 badgeSize.width, badgeSize.height)
                       withAttributes:badgeTextAttributes];
    }
    
    CGContextRestoreGState(context);
}

- (void)setTitle:(NSString *)title {
    _title = title;
    
    [self setupTitleWithValue:title forState:self.isSelected];
}

#pragma mark - Title configuration

- (void)setUnselectedTitleAttributes:(nullable NSDictionary *)unselectedAttributes
                  selectedAttributes:(nullable NSDictionary *)selectedAttributes {
    
    self.unselectedTitleAttributes = [unselectedAttributes copy];
    self.selectedTitleAttributes = selectedAttributes ? [selectedAttributes copy] : [unselectedAttributes copy];
    
    [self setupTitleWithValue:_title forState:self.state];
}

#pragma mark - Image configuration

- (UIImage *)finishedSelectedImage {
    return [self selectedImage];
}

- (UIImage *)finishedUnselectedImage {
    return [self unselectedImage];
}

- (void)setFinishedSelectedImage:(UIImage *)selectedImage withFinishedUnselectedImage:(UIImage *)unselectedImage {
    if (selectedImage && (selectedImage != [self selectedImage])) {
        [self setSelectedImage:selectedImage];
    }
    
    if (unselectedImage && (unselectedImage != [self unselectedImage])) {
        [self setUnselectedImage:unselectedImage];
    }
    
    [self setupImageForState:self.isSelected];
}

- (void)setBadgeValue:(NSString *)badgeValue {
    _badgeValue = badgeValue;
    
    [self setNeedsDisplay];
}

#pragma mark - Background configuration

- (UIImage *)backgroundSelectedImage {
    return [self selectedBackgroundImage];
}

- (UIImage *)backgroundUnselectedImage {
    return [self unselectedBackgroundImage];
}

- (void)setBackgroundSelectedImage:(UIImage *)selectedImage withUnselectedImage:(UIImage *)unselectedImage {
    if (selectedImage && (selectedImage != [self selectedBackgroundImage])) {
        [self setSelectedBackgroundImage:selectedImage];
    }
    
    if (unselectedImage && (unselectedImage != [self unselectedBackgroundImage])) {
        [self setUnselectedBackgroundImage:unselectedImage];
    }
}

#pragma mark - Accessibility

- (NSString *)accessibilityLabel {
    return @"tabbarItem";
}

- (BOOL)isAccessibilityElement {
    return YES;
}

@end
