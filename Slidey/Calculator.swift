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


    func targetValueForScrollviewPosition(_ x: CGFloat) -> CGFloat {

        if x - self.zeroBasis < self.leadingDeadZoneOffset {
            return -1
        }
        else if self.trailingDeadZoneOffset > 0 && x - self.zeroBasis >= (self.contentLen - self.trailingDeadZoneOffset) {
            return -1
        }

        let targetValue = (self.maxValue - self.minValue) * self.percentageOfScrollWithinValueRange(x) + self.minValue;

        return targetValue > self.maxValue ? self.maxValue : targetValue
    }

    func scrollViewPositionForTargetValue(_ v: CGFloat) -> CGFloat {

        return (v - self.minValue) * (self.contentLen - self.leadingDeadZoneOffset - self.trailingDeadZoneOffset) / (self.maxValue - self.minValue) + self.zeroBasis + self.leadingDeadZoneOffset;
    }

    func positionIsValidValue(_ x: CGFloat) -> Bool {

        let targetValue = self.targetValueForScrollviewPosition(x)

        return targetValue >= self.minValidValue && targetValue <= self.maxValidValue
    }


    func percentageOfScrollWithinValueRange(_ x: CGFloat) -> CGFloat {

        return (x - self.zeroBasis - self.leadingDeadZoneOffset) / (self.contentLen - self.leadingDeadZoneOffset - self.trailingDeadZoneOffset)
    }
}
