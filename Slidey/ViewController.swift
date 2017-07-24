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

class ViewController: UIViewController, HSCSliderValueHandler, HSCSliderValuePrinter {

    enum SliderTopic {
        case temperature
        case thickness
    }
    enum SliderMeasurementSystem {
        case english
        case metric
    }

    var slideyViewController: SlideyViewController? = nil

    let topic = SliderTopic.thickness
    let measurementSystem = SliderMeasurementSystem.english

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "slidey" {
            self.slideyViewController = segue.destination as? SlideyViewController

            if let slidey = self.slideyViewController {
                slidey.valueHandler = self
                slidey.valuePrinter = self

                // these could really just be constants hard-coded into Slidey, just need slider images to accommodate this
                slidey.trailingDeadOffset = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad) ? 125 : 75
                slidey.leadingDeadOffset = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad) ? 200 : 125

                // In a real application, we'd have configuration and value-printing handled by a delegate of some kind.
                // Here, a nested switch statement is OK. Ish.
                switch self.topic {
                case .temperature:
                    slidey.taskTitle = "How hot is your burner?"
                    slidey.taskPrompt = "Adjust the temperature manually."
                    slidey.lowValueImage = #imageLiteral(resourceName: "lowTemperatureIcon")
                    slidey.sliderColorRangeImage = UIImage(named: "temperatureColorRange")
                    slidey.units = "" // don't need to spell it out


                    switch self.measurementSystem {
                    case .english:
                        slidey.minValue = 65.0
                        slidey.maxValue = 500.0
                        slidey.sliderImage = #imageLiteral(resourceName: "temperatureSliderF")

                    case .metric:
                        slidey.minValue = 18.0
                        slidey.maxValue = 260.0
                        slidey.sliderImage = #imageLiteral(resourceName: "temperatureSliderC")
                    }

                case .thickness:
                    slidey.taskTitle = "How thick is your steak?"
                    slidey.taskPrompt = "Place your steak on a flat surface and measure the thickest part. It's important to measure accurately so your Cue can determine how long to cook your steak."
                    slidey.lowValueImage = #imageLiteral(resourceName: "thickness")
                    slidey.sliderColorRangeImage = UIImage(named: "thicknessColorRange")

                    switch self.measurementSystem {
                    case .english:
                        slidey.units = "inches"
                        slidey.minValue = 0.0
                        slidey.maxValue = 4.0
                        slidey.sliderImage = #imageLiteral(resourceName: "numberline")

                    case .metric:
                        slidey.units = "cm"
                        slidey.minValue = 0.5
                        slidey.maxValue = 10.0
                        slidey.sliderImage = #imageLiteral(resourceName: "thicknessSliderCM")
                    }
                }
            }
        }
    }

    func userSetValue(_ value: Double) {
        print("Setting value to \(value)")
    }

    func printValue(_ value: Double) -> String {
        switch self.topic {
        case .temperature:
            switch self.measurementSystem {
            case .english:
                return "\(lround(value))"

            case .metric:
                return "\(lround(value))"
            }

        case .thickness:
            switch self.measurementSystem {
            case .english:
                let ei = englishInches(value)
                self.slideyViewController!.units = ei == "1" ? "inch" : "inches"
                return ei

            case .metric:
                return "\(round( value * 10 ) / 10)"
            }
        }
    }
}



//#define END_SPACE_OFFSET_F ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 125 : 75)
//#define END_SPACE_OFFSET_C 0

//#define CONTENT_WIDTH_OFFSET_F ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 200 : 125)
//#define CONTENT_WIDTH_OFFSET_C ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 100 : 60)

//#define MIN_TEMP_F 65.0
//#define MAX_TEMP_F 500.0
