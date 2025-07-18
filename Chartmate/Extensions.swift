//
//  Extensions.swift
//  Chartmate.ai
//
//  Created by Mac User on 20/06/24.
//

import Foundation
import UIKit

extension UIView {
    
    /** This helps to add VisualForamt Constraints by reducing Duplications in CODE*/
    func addConstraintsWithFormatString(formate: String, views: UIView...) {
        
        var viewsDictionary = [String: UIView]()
        
        for (index, view) in views.enumerated() {
            
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: formate, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
        
    }
    
    
    /**Sets border at bottom for the Views */
    func setBottomLineForView(borderColor: UIColor) {
        
        self.backgroundColor = UIColor.clear
        
        let borderLine = UIView()
        let height = 1.0
        borderLine.frame = CGRect(x: 0, y: Double(self.frame.height) - height, width: Double(self.frame.width), height: height)
        
        borderLine.backgroundColor = borderColor
        self.addSubview(borderLine)
    }
    
}


extension UIColor {
    
    /**This returns the RGB Color by taking Parameters Red, Green and Blue Values*/
    static func rgbColor(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        
        return UIColor.init(red: red/255, green: green/255, blue: blue/255, alpha: 1.0)
    }
    
    /**Gives Color from HEX Value, If there is more than 6 characters in HEX String, it returns "Magenta Color". If the HEX String is Correct, it returns it's Color*/
    static func colorFromHexValue(_ hex: String) -> UIColor {
        
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if hexString.hasPrefix("#") {
            
            hexString.remove(at: hexString.startIndex)
        }
        
        if hexString.count != 6 {
            
            return UIColor.magenta
        }
        
        var rgb: UInt32 = 0
        Scanner.init(string: hexString).scanHexInt32(&rgb)
        
        return UIColor.init(red: CGFloat((rgb & 0xFF0000) >> 16)/255,
                            green: CGFloat((rgb & 0x00FF00) >> 8)/255,
                            blue: CGFloat(rgb & 0x0000FF)/255,
                            alpha: 1.0)
    }
    
}


extension UIInputView: UIInputViewAudioFeedback {
    
    public var enableInputClicksWhenVisible: Bool {
        get {
            return true
        }
    }
    
    func playInputClick​() {
        UIDevice.current.playInputClick()
    }
    
}

extension String {
    
    var length : Int {
        get{
            return self.count
        }
    }
}



extension Notification.Name {
    
    static var textProxyForContainer = Notification.Name.init("HandleContainerText")
    
    static var textProxyNilNotification = Notification.Name.init("TextProxyNilNotification")
    
    // For notifying From Child View Controllers
    
    static var childVCInformation = Notification.Name.init("ChildVC Information")

}


//extension UIReturnKeyType {
//    
//    func get (rawValue: Int)-> String {
//        
//        switch self.rawValue {
//        case UIReturnKeyType.default.rawValue:
//            return "Return"
//        case UIReturnKeyType.continue.rawValue:
//            return "Continue"
//        case UIReturnKeyType.google.rawValue:
//            return "google"
//        case UIReturnKeyType.done.rawValue:
//            return "Done"
//        case UIReturnKeyType.search.rawValue:
//            return "Search"
//        case UIReturnKeyType.join.rawValue:
//            return "Join"
//        case UIReturnKeyType.next.rawValue:
//            return "Next"
//        case UIReturnKeyType.emergencyCall.rawValue:
//            return "Emg Call"
//        case UIReturnKeyType.route.rawValue:
//            return "Route"
//        case UIReturnKeyType.send.rawValue:
//            return "Send"
//        case UIReturnKeyType.yahoo.rawValue:
//            return "search"
//            
//        default:
//            return "Default"
//        }
//        
//    }
//    
//}

extension UIReturnKeyType {
    
    func get(rawValue: Int) -> String {
        
        switch self.rawValue {
        case UIReturnKeyType.default.rawValue:
            return "Return"
        case UIReturnKeyType.continue.rawValue:
            return "Continue"
        case UIReturnKeyType.google.rawValue:
            return "Google"
        case UIReturnKeyType.done.rawValue:
            return "Done"
        case UIReturnKeyType.search.rawValue:
            return "Search"
        case UIReturnKeyType.join.rawValue:
            return "Join"
        case UIReturnKeyType.next.rawValue:
            return "Next"
        case UIReturnKeyType.emergencyCall.rawValue:
            return "Emergency Call"
        case UIReturnKeyType.route.rawValue:
            return "Route"
        case UIReturnKeyType.send.rawValue:
            return "Send"
        case UIReturnKeyType.yahoo.rawValue:
            return "Yahoo"
        case UIReturnKeyType.go.rawValue:
            return "Go"
        default:
            return "Default"
        }
    }
}



extension UIViewController {
    
//    /**Adds View controoler as a child view controller, on current View  */
//    func addViewControllerAsChildViewController(childViewController: UIViewController) {
//
//        addChildViewController(childViewController)
//        view.addSubview(childViewController.view)
//        childViewController.view.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height-225)
//        childViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        childViewController.didMove(toParentViewController: self)
//
//    }
//
//    /**Removes View controoler from  child view controller, on current View  */
//    func removeViewControllerAsChildViewController(childViewController: UIViewController) {
//
//        childViewController.willMove(toParentViewController: nil)
//        childViewController.view.removeFromSuperview()
//        childViewController.removeFromParentViewController()
//
//    }
    
    
}

public extension UIDevice {

    static let modelName: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }

        func mapToDevice(identifier: String) -> String { // swiftlint:disable:this cyclomatic_complexity
            #if os(iOS)
            switch identifier {
            case "iPod5,1":                                       return "iPod touch (5th generation)"
            case "iPod7,1":                                       return "iPod touch (6th generation)"
            case "iPod9,1":                                       return "iPod touch (7th generation)"
            case "iPhone3,1", "iPhone3,2", "iPhone3,3":           return "iPhone 4"
            case "iPhone4,1":                                     return "iPhone 4s"
            case "iPhone5,1", "iPhone5,2":                        return "iPhone 5"
            case "iPhone5,3", "iPhone5,4":                        return "iPhone 5c"
            case "iPhone6,1", "iPhone6,2":                        return "iPhone 5s"
            case "iPhone7,2":                                     return "iPhone 6"
            case "iPhone7,1":                                     return "iPhone 6 Plus"
            case "iPhone8,1":                                     return "iPhone 6s"
            case "iPhone8,2":                                     return "iPhone 6s Plus"
            case "iPhone9,1", "iPhone9,3":                        return "iPhone 7"
            case "iPhone9,2", "iPhone9,4":                        return "iPhone 7 Plus"
            case "iPhone10,1", "iPhone10,4":                      return "iPhone 8"
            case "iPhone10,2", "iPhone10,5":                      return "iPhone 8 Plus"
            case "iPhone10,3", "iPhone10,6":                      return "iPhone X"
            case "iPhone11,2":                                    return "iPhone XS"
            case "iPhone11,4", "iPhone11,6":                      return "iPhone XS Max"
            case "iPhone11,8":                                    return "iPhone XR"
            case "iPhone12,1":                                    return "iPhone 11"
            case "iPhone12,3":                                    return "iPhone 11 Pro"
            case "iPhone12,5":                                    return "iPhone 11 Pro Max"
            case "iPhone13,1":                                    return "iPhone 12 mini"
            case "iPhone13,2":                                    return "iPhone 12"
            case "iPhone13,3":                                    return "iPhone 12 Pro"
            case "iPhone13,4":                                    return "iPhone 12 Pro Max"
            case "iPhone14,4":                                    return "iPhone 13 mini"
            case "iPhone14,5":                                    return "iPhone 13"
            case "iPhone14,2":                                    return "iPhone 13 Pro"
            case "iPhone14,3":                                    return "iPhone 13 Pro Max"
            case "iPhone14,7":                                    return "iPhone 14"
            case "iPhone14,8":                                    return "iPhone 14 Plus"
            case "iPhone15,2":                                    return "iPhone 14 Pro"
            case "iPhone15,3":                                    return "iPhone 14 Pro Max"
            case "iPhone15,4":                                    return "iPhone 15"
            case "iPhone15,5":                                    return "iPhone 15 Plus"
            case "iPhone16,1":                                    return "iPhone 15 Pro"
            case "iPhone16,2":                                    return "iPhone 15 Pro Max"
            case "iPhone8,4":                                     return "iPhone SE"
            case "iPhone12,8":                                    return "iPhone SE (2nd generation)"
            case "iPhone14,6":                                    return "iPhone SE (3rd generation)"
            case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":      return "iPad 2"
            case "iPad3,1", "iPad3,2", "iPad3,3":                 return "iPad (3rd generation)"
            case "iPad3,4", "iPad3,5", "iPad3,6":                 return "iPad (4th generation)"
            case "iPad6,11", "iPad6,12":                          return "iPad (5th generation)"
            case "iPad7,5", "iPad7,6":                            return "iPad (6th generation)"
            case "iPad7,11", "iPad7,12":                          return "iPad (7th generation)"
            case "iPad11,6", "iPad11,7":                          return "iPad (8th generation)"
            case "iPad12,1", "iPad12,2":                          return "iPad (9th generation)"
            case "iPad13,18", "iPad13,19":                        return "iPad (10th generation)"
            case "iPad4,1", "iPad4,2", "iPad4,3":                 return "iPad Air"
            case "iPad5,3", "iPad5,4":                            return "iPad Air 2"
            case "iPad11,3", "iPad11,4":                          return "iPad Air (3rd generation)"
            case "iPad13,1", "iPad13,2":                          return "iPad Air (4th generation)"
            case "iPad13,16", "iPad13,17":                        return "iPad Air (5th generation)"
            case "iPad14,8", "iPad14,9":                          return "iPad Air (11-inch) (M2)"
            case "iPad14,10", "iPad14,11":                        return "iPad Air (13-inch) (M2)"
            case "iPad2,5", "iPad2,6", "iPad2,7":                 return "iPad mini"
            case "iPad4,4", "iPad4,5", "iPad4,6":                 return "iPad mini 2"
            case "iPad4,7", "iPad4,8", "iPad4,9":                 return "iPad mini 3"
            case "iPad5,1", "iPad5,2":                            return "iPad mini 4"
            case "iPad11,1", "iPad11,2":                          return "iPad mini (5th generation)"
            case "iPad14,1", "iPad14,2":                          return "iPad mini (6th generation)"
            case "iPad6,3", "iPad6,4":                            return "iPad Pro (9.7-inch)"
            case "iPad7,3", "iPad7,4":                            return "iPad Pro (10.5-inch)"
            case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":      return "iPad Pro (11-inch) (1st generation)"
            case "iPad8,9", "iPad8,10":                           return "iPad Pro (11-inch) (2nd generation)"
            case "iPad13,4", "iPad13,5", "iPad13,6", "iPad13,7":  return "iPad Pro (11-inch) (3rd generation)"
            case "iPad14,3", "iPad14,4":                          return "iPad Pro (11-inch) (4th generation)"
            case "iPad16,3", "iPad16,4":                          return "iPad Pro (11-inch) (M4)"
            case "iPad6,7", "iPad6,8":                            return "iPad Pro (12.9-inch) (1st generation)"
            case "iPad7,1", "iPad7,2":                            return "iPad Pro (12.9-inch) (2nd generation)"
            case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":      return "iPad Pro (12.9-inch) (3rd generation)"
            case "iPad8,11", "iPad8,12":                          return "iPad Pro (12.9-inch) (4th generation)"
            case "iPad13,8", "iPad13,9", "iPad13,10", "iPad13,11":return "iPad Pro (12.9-inch) (5th generation)"
            case "iPad14,5", "iPad14,6":                          return "iPad Pro (12.9-inch) (6th generation)"
            case "iPad16,5", "iPad16,6":                          return "iPad Pro (13-inch) (M4)"
            case "AppleTV5,3":                                    return "Apple TV"
            case "AppleTV6,2":                                    return "Apple TV 4K"
            case "AudioAccessory1,1":                             return "HomePod"
            case "AudioAccessory5,1":                             return "HomePod mini"
            case "i386", "x86_64", "arm64":                       return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))"
            default:                                              return identifier
            }
            #elseif os(tvOS)
            switch identifier {
            case "AppleTV5,3": return "Apple TV 4"
            case "AppleTV6,2", "AppleTV11,1", "AppleTV14,1": return "Apple TV 4K"
            case "i386", "x86_64": return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "tvOS"))"
            default: return identifier
            }
            #elseif os(visionOS)
            switch identifier {
            case "RealityDevice14,1": return "Apple Vision Pro"
            default: return identifier
            }
            #endif
        }

        return mapToDevice(identifier: identifier)
    }()

}


// Usage

