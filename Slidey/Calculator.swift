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

    let _contentDistance: CGFloat
    let _pct_offset: CGFloat
    let _pct_denominator: CGFloat

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

        self._contentDistance = self.maxValue - self.minValue
        self._pct_offset = self.zeroBasis + self.leadingDeadZoneOffset
        self._pct_denominator = (self.contentLen - self.leadingDeadZoneOffset) - (self.contentLen - self.trailingDeadZoneOffset)

        super.init()
    }


    func valueForContentOffset(_ x: CGFloat) -> CGFloat {

        if self.leadingDeadZoneOffset > 0 && x - self.zeroBasis < self.leadingDeadZoneOffset {
            return -1
        }
        else if self.trailingDeadZoneOffset > 0 && x - self.zeroBasis >= self.trailingDeadZoneOffset {
            return -1
        }

        let value = self._contentDistance * self.percentOfValueRangeForContentOffset(x) + self.minValue
        return value > self.maxValue ? self.maxValue : value
    }

    func contentOffsetForValue(_ v: CGFloat) -> CGFloat {

        return (v - self.minValue) * self._pct_denominator / self._contentDistance + self._pct_offset
    }

    func positionIsValidValue(_ x: CGFloat) -> Bool {

        let targetValue = self.valueForContentOffset(x)

        return targetValue >= self.minValidValue && targetValue <= self.maxValidValue
    }


    func percentOfValueRangeForContentOffset(_ x: CGFloat) -> CGFloat {

        return (x - self._pct_offset) / self._pct_denominator
    }
}
