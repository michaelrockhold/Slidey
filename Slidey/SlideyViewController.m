//
//  SlideyViewController.m
//  Hestan
//
//  Copyright © 2017 Hestan Smart Cooking. All rights reserved.
//

#import "Slidey-Bridging-Header.h"
#import "SlideyViewController.h"

@interface SlideyViewController () <UIScrollViewDelegate>

@property (nonatomic, weak) IBOutlet UIImageView *sliderImageView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *sliderImageWidthConstraint;
@property (weak, nonatomic) IBOutlet UIScrollView *sliderScrollView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *promptLabel;

@property (weak, nonatomic) IBOutlet UILabel *targetValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *unitsLabel;
@property (weak, nonatomic) IBOutlet UIView *sliderContentView;
@property (weak, nonatomic) IBOutlet UIView *sliderColorBackgroundView;
@property (weak, nonatomic) IBOutlet UIImageView *lowValueImageView;
@property (weak, nonatomic) IBOutlet UIImageView *arrowMaskImageView;


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

    self.titleLabel.text = self.taskTitle;
    self.promptLabel.text = self.taskPrompt;
    self.unitsLabel.text = self.units;

    self.lowValueImageView.image = self.lowValueImage;
    self.sliderImageView.image = self.sliderImage;
    self.sliderImageWidthConstraint.constant = self.sliderImageView.image.size.width;

    // [self.dataWarehouse recordUITrackingEvent:[[UITrackingData alloc] initWithType:UITrackingEventType_VIEW_MANUAL_TEMP]];

    self.targetValueLabel.hidden = YES;
    self.unitsLabel.hidden = YES;
    self.lowValueImageView.hidden = NO;

    [self.metricsRecorder startActivity:[self metricsActivityIdentifier]];
}


-(void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];
    
    [self.sliderScrollView setContentOffset:CGPointMake(-self.sliderScrollView.frame.size.width / 2 + self.arrowMaskImageView.frame.size.height, 0)];
}


-(void)viewDidLayoutSubviews {
    
    self.sliderScrollView.contentSize = CGSizeMake(self.sliderContentView.frame.size.width - self.arrowMaskImageView.frame.size.height * 2, self.sliderContentView.frame.size.height);
    self.sliderScrollView.contentInset = UIEdgeInsetsMake(0.0, self.sliderScrollView.frame.size.width / 2 - self.arrowMaskImageView.frame.size.height, 0.0, self.sliderScrollView.frame.size.width / 2 + self.arrowMaskImageView.frame.size.height);
}

- (NSString *)metricsActivityIdentifier {
    return @"Slidey";
}

-(void)setUnits:(NSString *)units {
    _units = [units copy];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.unitsLabel.text = _units;
    });
}

-(void)setValueFromScrollview {

    [self.valueHandler userSetValue:[self targetValueForScrollviewPosition]];
}


- (UIColor*)colorForPercentage:(float)percentage {
    
    if (percentage < 0) {
        percentage = 0;
    } else if (percentage >= 1) {
        percentage = 0.99999;
    }
    
    CFDataRef pixelData = CGDataProviderCopyData(CGImageGetDataProvider(self.sliderColorRangeImage.CGImage));
    const UInt8* data = CFDataGetBytePtr(pixelData);
    int pixelInfo = (int)(self.sliderColorRangeImage.size.width * percentage ) * 4; // 4 bytes per pixel
    
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
        
        [self setValueFromScrollview];
    }
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    [self setValueFromScrollview];
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (self.sliderScrollView.contentOffset.x - self.arrowMaskImageView.frame.size.height * 2 <= -self.sliderScrollView.frame.size.width / 2) {
        
        self.targetValueLabel.hidden = YES;
        self.unitsLabel.hidden = YES;
        self.lowValueImageView.hidden = NO;

    } else {
        
        self.targetValueLabel.hidden = NO;
        self.unitsLabel.hidden = NO;
        self.lowValueImageView.hidden = YES;
        self.targetValueLabel.text = [self.valuePrinter printValue:[self targetValueForScrollviewPosition]];
    }
    
    float percent = [self percentageOfScrollWithinValueRange];
    UIColor* colour = [self colorForPercentage:percent];
    self.sliderColorBackgroundView.backgroundColor = colour;
    self.targetValueLabel.textColor = colour;
    self.unitsLabel.textColor = colour;

}


-(double)targetValueForScrollviewPosition {

    float targetValue = (self.maxValue - self.minValue) * [self percentageOfScrollWithinValueRange] + self.minValue;
    
    if (targetValue > self.maxValue) {
        
        targetValue = self.maxValue;
    }
    
    return targetValue;
}


-(float) percentageOfScrollWithinValueRange {
    
    return (self.sliderScrollView.contentOffset.x - self.endSpaceOffset + self.sliderScrollView.frame.size.width / 2) / (self.sliderScrollView.contentSize.width - self.contentWidthOffset);
}

@end
