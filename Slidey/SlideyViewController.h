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

@protocol HSCSliderValueHandler <NSObject>

- (void)userSetValue:(double)value;

@end

@protocol HSCSliderValuePrinter <NSObject>

- (NSString* _Nonnull)printValue:(double)value;

@end

@interface SlideyViewController : UIViewController {
    
}


@property (nonatomic, weak) id <HSCSliderValueHandler> _Nullable valueHandler;
@property (nonatomic, weak) id <HSCSliderValuePrinter> _Nullable valuePrinter;

@property (nonatomic, copy) NSString * _Nullable taskTitle;
@property (nonatomic, copy) NSString * _Nullable taskPrompt;
@property (nonatomic, copy) NSString * _Nullable units;

@property double endSpaceOffset;
@property double contentWidthOffset;
@property double maxValue;
@property double minValue;

@property (nonatomic, strong) UIImage* _Nullable lowValueImage;
@property (nonatomic, strong) UIImage* _Nullable sliderImage;
@property (nonatomic, strong) UIImage * _Nullable sliderColorRangeImage;


@property (nonatomic, weak) id<HSCMetricsRecorder> _Nullable metricsRecorder;
@property (nonnull, nonatomic, strong) id<HSCLogger> logger;

// subclasses should override the following
- (NSString * _Nonnull)metricsActivityIdentifier;

@end
