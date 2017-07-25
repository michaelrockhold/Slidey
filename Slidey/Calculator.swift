//
//  Calculator.swift
//  Slidey
//
//  Created by Michael Rockhold on 7/23/17.
//  Copyright © 2017 Hestan Smart Cooking. All rights reserved.
//

import Foundation

enum TargetValueClass {
    case LeadingDeadZone
    case MeasureableValue
    case SmallInvalidValue
    case ValidValue
    case LargeInvalidValue
    case TrailingDeadZone
}

@objc class Calculator: NSObject {

    @objc let zeroBasis: CGFloat
    let contentLen: CGFloat

    let minValue: CGFloat
    let maxValue: CGFloat

    let minValidValue: CGFloat
    let maxValidValue: CGFloat

    let leadingDeadZoneOffset: CGFloat
    let trailingDeadZoneOffset: CGFloat

    @objc init(contentLen: CGFloat,
               zeroBasis: CGFloat,
               minValue: CGFloat,
               maxValue: CGFloat,
               minValidValue: CGFloat,
               maxValidValue: CGFloat,
               leadingDeadZoneOffset: CGFloat,
               trailingDeadZoneOffset: CGFloat) {

        self.contentLen = contentLen
        self.zeroBasis = zeroBasis

        self.minValue = minValue
        self.maxValue = maxValue

        self.minValidValue = minValidValue
        self.maxValidValue = maxValidValue

        self.leadingDeadZoneOffset = leadingDeadZoneOffset
        self.trailingDeadZoneOffset = trailingDeadZoneOffset

        super.init()
    }


    func valueForContentOffset(_ x: CGFloat) -> CGFloat {

        if self.leadingDeadZoneOffset > 0 && x - self.zeroBasis < self.leadingDeadZoneOffset {
            return -1
        }
        else if self.trailingDeadZoneOffset > 0 && x - self.zeroBasis >= self.trailingDeadZoneOffset {
            return -1
        }

        let targetValue = (self.maxValue - self.minValue) * self.percentOfValueRangeForContentOffset(x) + self.minValue;

        return targetValue > self.maxValue ? self.maxValue : targetValue
    }

    func contentOffsetForValue(_ v: CGFloat) -> CGFloat {

        return (v - self.minValue) * (self.contentLen - self.leadingDeadZoneOffset - self.trailingDeadZoneOffset) / (self.maxValue - self.minValue) + self.zeroBasis + self.leadingDeadZoneOffset;
    }

    func positionIsValidValue(_ x: CGFloat) -> Bool {

        let targetValue = self.valueForContentOffset(x)

        return targetValue >= self.minValidValue && targetValue <= self.maxValidValue
    }


    func percentOfValueRangeForContentOffset(_ x: CGFloat) -> CGFloat {

        let numerator = x - self.zeroBasis - self.leadingDeadZoneOffset
        let denominator = (self.contentLen - self.leadingDeadZoneOffset) - (self.contentLen - self.trailingDeadZoneOffset)

        return numerator / denominator
    }
}
