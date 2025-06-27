//
//  DemoCalloutActionProvider.swift
//  Keyboard
//
//  Created by Daniel Saidi on 2021-02-11.
//  Copyright © 2021-2024 Daniel Saidi. All rights reserved.
//

//import KeyboardKit
import UIKit

/// This provider inherits the standard provider, then makes
/// demo-specific adjustments to the standard actions.
///
/// The provider will return "keyboard" as character actions
/// when long pressing the "k" key.
///
/// You can play around with the class and customize it more,
/// to see how it affects the demo keyboard.
///
/// The ``KeyboardViewController`` shows how you can replace
/// the standard provider with this custom one. 
//class DemoCalloutActionProvider: Callouts.BaseActionProvider {
//    
//    override func calloutActionString(for char: String) -> String {
//        switch char {
//        case "k": String("keyboard".reversed())
//        default: super.calloutActionString(for: char)
//        }
//    }
//}
