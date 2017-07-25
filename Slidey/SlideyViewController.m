//
//  SlideyViewController.m
//  Hestan
//
//  Copyright © 2017 Hestan Smart Cooking. All rights reserved.
//

#import "Slidey-Bridging-Header.h"
#import "SlideyViewController.h"
#import "Slidey-Swift.h"

@interface SlideyViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) Calculator* _Nullable calculator;

@property (nonatomic, weak) IBOutlet UIImageView *sliderImageView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *sliderImageWidthConstraint;
@property (weak, nonatomic) IBOutlet UIScrollView *sliderScrollView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *promptLabel;

@property (weak, nonatomic) IBOutlet UILabel *targetValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *unitsLabel;
@property (weak, nonatomic) IBOutlet UIView *sliderContentView;
@property (weak, nonatomic) IBOutlet UIView *sliderColorBackgroundView;

@property (weak, nonatomic) IBOutlet UIView *sliderValidRangeColorView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *validColourViewLeadingConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *validColourViewWidthConstraint;

@property (weak, nonatomic) IBOutlet UIImageView *lowValueImageView;
@property (weak, nonatomic) IBOutlet UIImageView *arrowMaskImageView;

@property (nonatomic) float halfArrowWidth;

// Set as hidden via storyboard.  Make visible to aid with debugging.
@property (weak, nonatomic) IBOutlet UILabel *actualTargetValueLabel;

@end

@implementation SlideyViewController {

}

#pragma mark - View Lifecycle

- (void)viewDidLoad {

    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;
}


-(void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];

    self.titleLabel.text = self.valueHandler.taskTitle;
    self.promptLabel.text = self.valueHandler.taskPrompt;

    self.lowValueImageView.image = self.valueHandler.lowValueImage;
    self.sliderImageView.image = self.valueHandler.sliderImage;
    self.sliderImageWidthConstraint.constant = self.sliderImageView.image.size.width;

    self.targetValueLabel.hidden = YES;
    self.unitsLabel.hidden = YES;
    self.lowValueImageView.hidden = NO;

    self.halfArrowWidth = self.arrowMaskImageView.frame.size.height;

    [self.valueHandler.metricsRecorder startActivity:[self metricsActivityIdentifier]];
    // [self.dataWarehouse recordUITrackingEvent:[[UITrackingData alloc] initWithType:UITrackingEventType_VIEW_MANUAL_TEMP]];
}


-(void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];

    self.sliderScrollView.contentSize = CGSizeMake(self.sliderContentView.frame.size.width - self.halfArrowWidth * 2,
                                                   self.sliderContentView.frame.size.height);

    CGFloat left = self.sliderScrollView.frame.size.width / 2 - self.halfArrowWidth;
    CGFloat right = self.sliderScrollView.frame.size.width / 2 + self.halfArrowWidth;
    self.sliderScrollView.contentInset = UIEdgeInsetsMake(0.0, left, 0.0, right);

    self.calculator = [self.valueHandler makeNewCalculator:self.sliderScrollView.contentSize.width
                                                 zeroBasis:-self.sliderScrollView.frame.size.width / 2 + self.halfArrowWidth ];

    CGFloat minValidOffset = [self.calculator scrollViewPositionForTargetValue:self.valueHandler.minValidValue];
    CGFloat maxValidOffset = [self.calculator scrollViewPositionForTargetValue:self.valueHandler.maxValidValue];

    self.validColourViewLeadingConstraint.constant = minValidOffset;
    self.validColourViewWidthConstraint.constant = maxValidOffset - minValidOffset;

    [self.sliderScrollView setContentOffset:CGPointMake(self.calculator.zeroBasis, 0)];
}


- (NSString *)metricsActivityIdentifier {
    return @"Slidey";
}


-(void)sendValueFromScrollview {

    [self.valueHandler userSetValue:[self.calculator targetValueForScrollviewPosition:self.sliderScrollView.contentOffset.x]];
}


- (UIColor*)colorForPercentage:(float)percentage {

    if (percentage < 0) {
        percentage = 0;
    } else if (percentage >= 1) {
        percentage = 0.99999;
    }

    CFDataRef pixelData = CGDataProviderCopyData(CGImageGetDataProvider(self.valueHandler.sliderColorRangeImage.CGImage));
    const UInt8* data = CFDataGetBytePtr(pixelData);
    int pixelInfo = (int)(self.valueHandler.sliderColorRangeImage.size.width * percentage ) * 4; // 4 bytes per pixel

    UInt8 red = data[pixelInfo];
    UInt8 green = data[pixelInfo + 1];
    UInt8 blue = data[pixelInfo + 2];
    UInt8 alpha = data[pixelInfo +3];
    CFRelease(pixelData);

    return [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:alpha/255.0f];
}


#pragma mark - Scrollview Delegate

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {

    if (!decelerate) {

        [self sendValueFromScrollview];
    }
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

    [self sendValueFromScrollview];
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView {

    CGFloat value = [self.calculator targetValueForScrollviewPosition:scrollView.contentOffset.x];

    if (value < 0.0) {

        self.targetValueLabel.hidden = YES;
        self.unitsLabel.hidden = YES;
        self.lowValueImageView.hidden = NO;
    } else {

        self.targetValueLabel.hidden = NO;
        self.unitsLabel.hidden = NO;
        self.lowValueImageView.hidden = YES;

        NSArray<NSString*>* valueStrs = [self.valueHandler formatValue:value];
        self.targetValueLabel.text = valueStrs[0];
        self.unitsLabel.text = valueStrs[1];
    }

    float percent = [self.calculator percentageOfScrollWithinValueRange:scrollView.contentOffset.x];

    UIColor* colour = [self colorForPercentage:percent];
    self.sliderColorBackgroundView.backgroundColor = colour;
    self.targetValueLabel.textColor = colour;
    self.unitsLabel.textColor = colour;
}

@end
