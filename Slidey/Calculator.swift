//
//  Calculator.swift
//  Slidey
//
//  Created by Michael Rockhold on 7/23/17.
//  Copyright © 2017 Hestan Smart Cooking. All rights reserved.
//

import Foundation

@objc class Calculator: NSObject {

    @objc let zeroBasis: CGFloat
    let contentLen: CGFloat

    let minValue: CGFloat
    let maxValue: CGFloat

    let minValidValue: CGFloat
    let maxValidValue: CGFloat

    @objc init(contentLen: CGFloat,
               zeroBasis: CGFloat,
               minValue: CGFloat,
               maxValue: CGFloat,
               minValidValue: CGFloat,
               maxValidValue: CGFloat) {

        self.contentLen = contentLen
        self.zeroBasis = zeroBasis

        self.minValue = minValue
        self.maxValue = maxValue

        self.minValidValue = minValidValue
        self.maxValidValue = maxValidValue

        super.init()
    }


    func targetValueForScrollviewPosition(_ x: CGFloat) -> CGFloat {

        let targetValue = (self.maxValue - self.minValue) * self.percentageOfScrollWithinValueRange(x) + self.minValue;

        return targetValue > self.maxValue ? self.maxValue : targetValue
    }

    func positionIsValidValue(_ x: CGFloat) -> Bool {

        let targetValue = self.targetValueForScrollviewPosition(x)

        return targetValue >= self.minValidValue && targetValue <= self.maxValidValue
    }


    func percentageOfScrollWithinValueRange(_ x: CGFloat) -> CGFloat {

        return (x - self.zeroBasis) / self.contentLen
    }
}
