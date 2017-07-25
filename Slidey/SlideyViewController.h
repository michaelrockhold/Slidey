//
//  SlideyViewController.h
//  Hestan
//
//  Copyright © 2017 Hestan Smart Cooking. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HSCMetricsRecorder <NSObject> // satisfied by [ExternalMetrics getInstance]

- (void)startActivity:(NSString *_Nonnull)activityName;

@end

@protocol HSCLogger <NSObject>

- (void)logInfo:(NSString * _Nonnull)info; // like HSLogInfo

@end

@class Calculator;

@protocol HSCSliderValueHandler <NSObject>

@property (nonatomic, copy) NSString * _Nullable taskTitle;
@property (nonatomic, copy) NSString * _Nullable taskPrompt;

@property (nonatomic, strong) UIImage* _Nullable lowValueImage;
@property (nonatomic, strong) UIImage* _Nullable sliderImage;
@property (nonatomic, strong) UIImage * _Nullable sliderColorRangeImage;

@property (nonatomic) CGFloat minValidValue;
@property (nonatomic) CGFloat maxValidValue;

@property (nonatomic, weak) id<HSCMetricsRecorder> _Nullable metricsRecorder;
@property (nonatomic, strong) id<HSCLogger> _Nullable logger;

- (void)userSetValue:(double)value;

- (NSArray<NSString*>* _Nonnull)formatValue:(double)value;

- (Calculator * _Nonnull )makeNewCalculator:(CGFloat)contentLen zeroBasis:(CGFloat)zeroBasis;

@end


@interface SlideyViewController : UIViewController {
}


@property (nonatomic, weak) id <HSCSliderValueHandler> _Nullable valueHandler;

// subclasses should override the following
- (NSString * _Nonnull)metricsActivityIdentifier;

@end
