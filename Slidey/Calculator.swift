//
//  Calculator.swift
//  Slidey
//
//  Created by Michael Rockhold on 7/23/17.
//  Copyright © 2017 Hestan Smart Cooking. All rights reserved.
//

import Foundation

@objc class Calculator: NSObject {

    let frameLen: CGFloat
    let contentLen: CGFloat
    let trailingDeadOffset: CGFloat
    let leadingDeadOffset: CGFloat

    let minValue: CGFloat
    let maxValue: CGFloat

    let minValidValue: CGFloat
    let maxValidValue: CGFloat

    @objc init(contentLen: CGFloat, frameLen: CGFloat,
               trailingDeadOffset: CGFloat,
               leadingDeadOffset: CGFloat,
               minValue: CGFloat,
               maxValue: CGFloat,
               minValidValue: CGFloat,
               maxValidValue: CGFloat) {

        self.contentLen = contentLen
        self.frameLen = frameLen
        self.trailingDeadOffset = trailingDeadOffset
        self.leadingDeadOffset = leadingDeadOffset

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


    func percentageOfScrollWithinValueRange(_ x: CGFloat) -> CGFloat {

        return (x - self.trailingDeadOffset + self.frameLen / 2) / (self.contentLen - self.leadingDeadOffset);
    }
}
