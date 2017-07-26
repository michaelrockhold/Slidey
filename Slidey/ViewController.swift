//
//  ViewController.swift
//  Slidey
//
//  Created by Michael Rockhold on 7/19/17.
//  Copyright © 2017 Hestan Smart Cooking. All rights reserved.
//

import UIKit

func englishInches(_ value: Double) -> String {
    var intpart: Double
    var fractionpart: Double
    (intpart,fractionpart) = modf(value)

    var fraction = "error"
    switch Int(fractionpart*1000) {
    case 0...62:
        fraction = ""
    case 63...187:
        fraction = "⅛"
    case 188...312:
        fraction = "¼"
    case 313...437:
        fraction = "⅜"
    case 438...562:
        fraction = "½"
    case 563...687:
        fraction = "⅝"
    case 688...812:
        fraction = "¾"
    case 813...937:
        fraction = "⅞"
    case 938...1000:
        fraction = ""
        intpart = intpart + 1
    default:
        fraction = "error"
    }

    let ints = Int(intpart)
    var intStr = "\(ints)"

    if ints == 0 && fraction != "" {
        intStr = ""
    }

    return "\(intStr)\(fraction)"
}

class ViewController: UIViewController, HSCSliderValueHandler {

    // MARK: HSCSliderValueHandler implementation

    var taskTitle: String?
    var taskPrompt: String?

    var lowValueImage: UIImage?
    var sliderImage: UIImage?
    var sliderColorRangeImage: UIImage?

    var metricsRecorder: HSCMetricsRecorder?
    var logger: HSCLogger? = nil

    // MARK: geometry and metrics
    var maxValue: CGFloat = 0.0
    var minValue: CGFloat = 0.0

    var minValidValue: CGFloat = 0.0
    var maxValidValue: CGFloat = 0.0

    var leadingDeadZoneOffset: CGFloat = 0.0
    var trailingDeadZoneOffset: CGFloat = 0.0

    var tickIncrement: CGFloat = 0.0

    // MARK: Other stuff

    enum SliderTopic {
        case temperature
        case thickness
    }
    enum SliderMeasurementSystem {
        case english
        case metric
        case test
    }

    
    var slideyViewController: SlideyViewController? = nil


    let topic = SliderTopic.thickness
    let measurementSystem = SliderMeasurementSystem.english


    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {

        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {

        super.viewDidLoad()

        // Configure all the SlideyViewController parameters

        self.leadingDeadZoneOffset = 17.33
        self.trailingDeadZoneOffset = 16.67

        // In a real application, we'd have configuration and value-printing handled by a delegate of some kind.
        // Here, a nested switch statement is OK. Ish.
        switch self.topic {
        case .temperature:
            self.taskTitle = "How hot is your burner?"
            self.taskPrompt = "Adjust the temperature manually."
            self.lowValueImage = #imageLiteral(resourceName: "lowTemperatureIcon")
            self.sliderColorRangeImage = UIImage(named: "temperatureColorRange")


            switch self.measurementSystem {
            case .english:
                self.minValue = 65.0
                self.maxValue = 500.0
                self.sliderImage = #imageLiteral(resourceName: "temperatureSliderF")

            case .metric:
                self.minValue = 18.0
                self.maxValue = 260.0
                self.sliderImage = #imageLiteral(resourceName: "temperatureSliderC")

            case .test:
                self.leadingDeadZoneOffset = 800 / 3
                self.trailingDeadZoneOffset = 5600.1 / 3

                self.minValue = 0.0
                self.maxValue = 120.0
                self.minValidValue = 25.0
                self.maxValidValue = 97.0

                self.sliderImage = #imageLiteral(resourceName: "numberline")
            }

        case .thickness:
            self.taskTitle = "How thick is your steak?"
            self.taskPrompt = "Place your steak on a flat surface and measure the thickest part. It's important to measure accurately so your Cue can determine how long to cook your steak."
            self.lowValueImage = #imageLiteral(resourceName: "thickness")
            self.sliderColorRangeImage = UIImage(named: "thicknessColorRange")

            switch self.measurementSystem {
            case .english:
                self.leadingDeadZoneOffset = 8
                self.trailingDeadZoneOffset = 8

                self.minValue = 0.25
                self.maxValue = 4.0
                self.minValidValue = 0.25
                self.maxValidValue = 3.0
                self.tickIncrement = 0.25
                self.sliderImage = #imageLiteral(resourceName: "thicknessSliderIN")

            case .metric:
                self.leadingDeadZoneOffset = 800 / 3
                self.trailingDeadZoneOffset = 5600.1 / 3

                self.minValue = 1.0
                self.maxValue = 10
                self.minValidValue = 25.0
                self.maxValidValue = 97.0

                //self.sliderImage = thicknessSliderCM

            case .test:
                self.leadingDeadZoneOffset = 800 / 3
                self.trailingDeadZoneOffset = 5600.1 / 3

                self.minValue = 0.0
                self.maxValue = 120.0
                self.minValidValue = 25.0
                self.maxValidValue = 97.0

                self.tickIncrement = 0.5

                self.sliderImage = #imageLiteral(resourceName: "numberline")
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "slidey" {
            self.slideyViewController = segue.destination as? SlideyViewController

            if let slidey = self.slideyViewController {
                slidey.valueHandler = self
            }
        }
    }

    func makeNewCalculator(_ contentLen: CGFloat, zeroBasis: CGFloat) -> Calculator {

        return Calculator(contentLen: contentLen,
                          zeroBasis: zeroBasis,
                          minValue: self.minValue,
                          maxValue: self.maxValue,
                          minValidValue: self.minValidValue,
                          maxValidValue: self.maxValidValue,
                          leadingDeadZoneOffset: self.leadingDeadZoneOffset,
                          trailingDeadZoneOffset: self.trailingDeadZoneOffset)
    }


    func userSetValue(_ value: Double) {
        print("Setting value to \(value)")
    }

    func formatValue(_ value: Double) -> [String] {
        switch self.topic {
        case .temperature:
            switch self.measurementSystem {
            case .english:
                return ["\(lround(value))", ""]

            case .metric:
                return ["\(lround(value))", ""]

            case .test:
                let numbers = "\(round( value * 10 ) / 10)"
                return [numbers, numbers == "1.0" ? "unuo" : "unuecoj"]
            }

        case .thickness:
            switch self.measurementSystem {
            case .english:
                let ei = englishInches(value)
                return [ei, ei == "1" ? "inch" : "inches"]

            case .metric:
                return ["\(round( value * 10 ) / 10)", "cm"]

            case .test:
                let numbers = "\(round( value * 10 ) / 10)"
                return [numbers, numbers == "1.0" ? "unuo" : "unuecoj"]
            }
        }
    }
}
