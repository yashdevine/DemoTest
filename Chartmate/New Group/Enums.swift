//
//  Enums.swift
//  Chartmate
//
//  Created by Mac User on 11/07/24.
//

import Foundation
import UIKit

enum DEConjugationState {
    case indicativePresent
    case indicativePreterite
    case indicativePerfect
}

/// What the conjugation state is for the case conjugate feature.
enum DECaseDeclensionState {
    case accusativeDefinite
    case accusativeIndefinite
    case accusativePersonal
    case accusativePossessive
    case accusativeDemonstrative
    case dativeDefinite
    case dativeIndefinite
    case dativePersonal
    case dativePossessive
    case dativeDemonstrative
    case genitiveDefinite
    case genitiveIndefinite
    case genitivePersonal
    case genitivePossessive
    case genitiveDemonstrative
}

/// Allows for switching the conjugation view to select from pronoun options based on noun genders.
enum DECaseVariantDeclensionState {
    case disabled
    case accusativePersonalSPS
    case accusativePersonalTPS
    case accusativePossessiveFPS
    case accusativePossessiveSPS
    case accusativePossessiveSPSInformal
    case accusativePossessiveSPSFormal
    case accusativePossessiveTPS
    case accusativePossessiveTPSMasculine
    case accusativePossessiveTPSFeminine
    case accusativePossessiveTPSNeutral
    case accusativePossessiveFPP
    case accusativePossessiveSPP
    case accusativePossessiveTPP
    case dativePersonalSPS
    case dativePersonalTPS
    case dativePossessiveFPS
    case dativePossessiveSPS
    case dativePossessiveSPSInformal
    case dativePossessiveSPSFormal
    case dativePossessiveTPS
    case dativePossessiveTPSMasculine
    case dativePossessiveTPSFeminine
    case dativePossessiveTPSNeutral
    case dativePossessiveFPP
    case dativePossessiveSPP
    case dativePossessiveTPP
    case genitivePersonalSPS
    case genitivePersonalTPS
    case genitivePossessiveFPS
    case genitivePossessiveSPS
    case genitivePossessiveSPSInformal
    case genitivePossessiveSPSFormal
    case genitivePossessiveTPS
    case genitivePossessiveTPSMasculine
    case genitivePossessiveTPSFeminine
    case genitivePossessiveTPSNeutral
    case genitivePossessiveFPP
    case genitivePossessiveSPP
    case genitivePossessiveTPP
}

enum AutoActionState {
    case complete
    case suggest
}

enum CommandState {
    case idle
    case selectCommand
    case translate
    case conjugate
    case selectVerbConjugation
    case selectCaseDeclension
    case plural
    case alreadyPlural
    case invalid
    case displayInformation
}

enum ShiftButtonState {
    case normal
    case shift
}
enum CapsLockButtonState {
    case normal
    case locked
}

enum KeyboardState {
    case letters
    case numbers
    case symbols
}


enum DeviceType {
    static let isPhone = UIDevice.current.userInterfaceIdiom == .phone
    static let isPad = UIDevice.current.userInterfaceIdiom == .pad
}

let isIPad = UIDevice.current.userInterfaceIdiom == .pad
let IS_IPHONE = !isIPad
let IS_IPAD = isIPad

var keyPopChar = UILabel()
var keyHoldPopChar = UILabel()
var keyPopLayer = CAShapeLayer()
var keyHoldPopLayer = CAShapeLayer()
var keysWithAlternates = [String]()
var alternateKeys = [String]()

var isLandscapeView = false

var keyboardState: KeyboardState = .letters
var letterKeyWidth = CGFloat(0)
var shiftButtonState: ShiftButtonState = .normal
var capsLockButtonState: CapsLockButtonState = .normal

var commandState: CommandState = .idle

var proxy: UITextDocumentProxy!
var deConjugationState: DEConjugationState = .indicativePresent
var deCaseDeclensionState: DECaseDeclensionState = .accusativeDefinite
var deCaseVariantDeclensionState: DECaseVariantDeclensionState = .disabled
var autoActionState: AutoActionState = .suggest

var centralKeyChars = ["W", "E", "R", "T", "Y", "U", "I", "O", "A", "S", "D", "F", "G", "H", "J", "K", "L", "Z", "X", "C", "V", "B", "N", "M", "w","e","r","t","y","u","i","o","a","s","d","f","g","h","j","k","l","z","x","c","v","b","n","m","2","3","4","5","6","7","8","9","/",":",";","(",")","$","&","@",".",",","?","!","'","]", "{", "}", "#", "%", "^", "*", "+","\\", "|", "~", "<", ">", "$", "£", "€"]
var leftKeyChars = ["Q","q","1","-","[","_"]
var rightKeyChars = ["P","p","0","\"","=","·"]

func setPhoneKeyPopCharSize(char: String) {
    letterKeyWidth = 30
    if keyboardState != .letters && !["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"].contains(char) {
        if isLandscapeView {
            keyPopChar.font = .systemFont(ofSize: letterKeyWidth / 2.25)
            keyHoldPopChar.font = .systemFont(ofSize: letterKeyWidth / 2.25)
        } else {
            keyPopChar.font = .systemFont(ofSize: letterKeyWidth / 1.15)
            keyHoldPopChar.font = .systemFont(ofSize: letterKeyWidth / 1.15)
        }
    } else if shiftButtonState == .shift || capsLockButtonState == .locked {
        if isLandscapeView {
            keyPopChar.font = .systemFont(ofSize: letterKeyWidth / 2.15)
            keyHoldPopChar.font = .systemFont(ofSize: letterKeyWidth / 2.15)
        } else {
            keyPopChar.font = .systemFont(ofSize: letterKeyWidth / 1)
            keyHoldPopChar.font = .systemFont(ofSize: letterKeyWidth / 1)
        }
    } else {
        if isLandscapeView {
            keyPopChar.font = .systemFont(ofSize: letterKeyWidth / 2)
            keyHoldPopChar.font = .systemFont(ofSize: letterKeyWidth / 2)
        } else {
            keyPopChar.font = .systemFont(ofSize: letterKeyWidth / 0.9)
            keyHoldPopChar.font = .systemFont(ofSize: letterKeyWidth / 0.9)
        }
    }
}


func setKeyPopCharSize(char: String) {
  if DeviceType.isPhone {
    setPhoneKeyPopCharSize(char: char)
  } else if DeviceType.isPad {
//        setPadKeyPopCharSize(char: char)
  }
}

var horizStart = CGFloat(0)
var vertStart = CGFloat(0)
var widthMultiplier = CGFloat(0)
var maxHeightMultiplier = CGFloat(0)
var maxHeight = CGFloat(0)
var heightBeforeTopCurves = CGFloat(0)
var maxWidthCurveControl = CGFloat(0)
var maxHeightCurveControl = CGFloat(0)
var minHeightCurveControl = CGFloat(0)


func setPopPathState(
    startX: CGFloat,
    startY: CGFloat,
    keyHeight: CGFloat,
    char: String,
    position: String
) {
    // Starting positions need to be updated.
    horizStart = startX; vertStart = startY + keyHeight
    if DeviceType.isPad {
        widthMultiplier = 0.2
        maxHeightMultiplier = 2.05
        if isLandscapeView {
            maxHeightMultiplier = 1.95
        }
    } else if DeviceType.isPhone && isLandscapeView {
        widthMultiplier = 0.2
        maxHeightMultiplier = 2.125
    } else if DeviceType.isPhone && [".", ",", "?", "!", "'"].contains(char) {
        widthMultiplier = 0.2
        maxHeightMultiplier = 2.125
    } else {
        widthMultiplier = 0.4
        maxHeightMultiplier = 2.125
    }
    // Non central characters have a call out that's twice the width in one direction.
    if position != "center" {
        widthMultiplier *= 2
    }
    maxHeight = vertStart - (keyHeight * maxHeightMultiplier)
    maxHeightCurveControl = vertStart - (keyHeight * (maxHeightMultiplier - 0.125))
    minHeightCurveControl = vertStart - (keyHeight * 0.005)
    
    if DeviceType.isPhone {
        heightBeforeTopCurves = vertStart - (keyHeight * 1.8)
    } else if DeviceType.isPad || (DeviceType.isPhone && isLandscapeView) {
        heightBeforeTopCurves = vertStart - (keyHeight * 1.6)
    }
}


func centerKeyPopPath(
    startX: CGFloat,
    startY: CGFloat,
    keyWidth: CGFloat,
    keyHeight: CGFloat,
    char: String
) -> UIBezierPath {
    setPopPathState(
        startX: startX, startY: startY, keyHeight: keyHeight, char: char, position: "center"
    )
    
    // Path is clockwise from bottom left.
    let path = UIBezierPath(); path.move(to: CGPoint(x: horizStart + (15 * 0.075), y: vertStart))
    
    // Curve up past bottom left, path up, and curve out to the left.
    path.addCurve(
        to: CGPoint(x: horizStart, y: vertStart - (keyHeight * 0.075)),
        controlPoint1: CGPoint(x: horizStart + (keyWidth * 0.075), y: minHeightCurveControl),
        controlPoint2: CGPoint(x: horizStart, y: minHeightCurveControl)
    )
    path.addLine(to: CGPoint(x: horizStart, y: vertStart - (keyHeight * 0.85)))
    path.addCurve(
        to: CGPoint(x: horizStart - (keyWidth * widthMultiplier), y: vertStart - (keyHeight * 1.2)),
        controlPoint1: CGPoint(x: horizStart, y: vertStart - (keyHeight * 0.9)),
        controlPoint2: CGPoint(x: horizStart - (keyWidth * widthMultiplier), y: vertStart - (keyHeight * 1.05))
    )
    
    // Path up and curve right past the top left.
    path.addLine(to: CGPoint(x: horizStart - (keyWidth * widthMultiplier), y: heightBeforeTopCurves))
    path.addCurve(
        to: CGPoint(x: horizStart + (keyWidth * 0.075), y: maxHeight),
        controlPoint1: CGPoint(x: horizStart - (keyWidth * widthMultiplier), y: maxHeightCurveControl),
        controlPoint2: CGPoint(x: horizStart - (keyWidth * 0.25), y: maxHeight)
    )
    
    // Path right, curve down past the top right, and path down.
    path.addLine(to: CGPoint(x: horizStart + (keyWidth * 0.925), y: maxHeight))
    path.addCurve(
        to: CGPoint(x: horizStart + (keyWidth * (1 + widthMultiplier)), y: heightBeforeTopCurves),
        controlPoint1: CGPoint(x: horizStart + (keyWidth * 1.25), y: maxHeight),
        controlPoint2: CGPoint(x: horizStart + (keyWidth * (1 + widthMultiplier)), y: maxHeightCurveControl)
    )
    path.addLine(to: CGPoint(x: horizStart + (keyWidth * (1 + widthMultiplier)), y: vertStart - (keyHeight * 1.2)))
    
    // Curve in to the left, go down, and curve down past bottom left.
    path.addCurve(
        to: CGPoint(x: horizStart + keyWidth, y: vertStart - (keyHeight * 0.85)),
        controlPoint1: CGPoint(x: horizStart + (keyWidth * (1 + widthMultiplier)), y: vertStart - (keyHeight * 1.05)),
        controlPoint2: CGPoint(x: horizStart + keyWidth, y: vertStart - (keyHeight * 0.9))
    )
    path.addLine(to: CGPoint(x: horizStart + keyWidth, y: vertStart - (keyHeight * 0.075)))
    path.addCurve(
        to: CGPoint(x: horizStart + (keyWidth * 0.925), y: vertStart),
        controlPoint1: CGPoint(x: horizStart + keyWidth, y: minHeightCurveControl),
        controlPoint2: CGPoint(x: horizStart + (keyWidth * 0.925), y: minHeightCurveControl)
    )
    
    path.close()
    return path
}


func rightKeyPopPath(
    startX: CGFloat,
    startY: CGFloat,
    keyWidth: CGFloat,
    keyHeight: CGFloat,
    char: String
) -> UIBezierPath {
    setPopPathState(
        startX: startX, startY: startY, keyHeight: keyHeight, char: char, position: "right"
    )
    
    // Path is clockwise from bottom left.
    let path = UIBezierPath(); path.move(to: CGPoint(x: horizStart + (keyWidth * 0.075), y: vertStart))
    
    // Curve up past bottom left, path up, and curve out to the left.
    path.addCurve(
        to: CGPoint(x: horizStart, y: vertStart - (keyHeight * 0.075)),
        controlPoint1: CGPoint(x: horizStart + (keyWidth * 0.075), y: minHeightCurveControl),
        controlPoint2: CGPoint(x: horizStart, y: minHeightCurveControl)
    )
    path.addLine(to: CGPoint(x: horizStart, y: vertStart - (keyHeight * 0.5)))
    path.addCurve(
        to: CGPoint(x: horizStart - (keyWidth * widthMultiplier), y: vertStart - (keyHeight * 1.3)),
        controlPoint1: CGPoint(x: horizStart, y: vertStart - (keyHeight * 0.9)),
        controlPoint2: CGPoint(x: horizStart - (keyWidth * widthMultiplier), y: vertStart - (keyHeight * 1.05))
    )
    
    // Path up and curve right past the top left.
    path.addLine(to: CGPoint(x: horizStart - (keyWidth * widthMultiplier), y: heightBeforeTopCurves))
    path.addCurve(
        to: CGPoint(x: horizStart - (keyWidth * widthMultiplier * 0.35), y: maxHeight),
        controlPoint1: CGPoint(x: horizStart - (keyWidth * widthMultiplier), y: maxHeightCurveControl),
        controlPoint2: CGPoint(x: horizStart - (keyWidth * widthMultiplier * 0.75), y: maxHeight)
    )
    
    // Path right, curve down past the top right, and path down.
    path.addLine(to: CGPoint(x: horizStart + (keyWidth * 0.5), y: maxHeight))
    path.addCurve(
        to: CGPoint(x: horizStart + keyWidth, y: heightBeforeTopCurves),
        controlPoint1: CGPoint(x: horizStart + (keyWidth * 0.95), y: maxHeight),
        controlPoint2: CGPoint(x: horizStart + keyWidth, y: maxHeightCurveControl)
    )
    path.addLine(to: CGPoint(x: horizStart + keyWidth, y: vertStart - (keyHeight * 0.075)))
    
    // Curve down past bottom left.
    path.addCurve(
        to: CGPoint(x: horizStart + (keyWidth * 0.925), y: vertStart),
        controlPoint1: CGPoint(x: horizStart + keyWidth, y: minHeightCurveControl),
        controlPoint2: CGPoint(x: horizStart + (keyWidth * 0.925), y: minHeightCurveControl)
    )
    
    path.close()
    return path
}


func leftKeyPopPath(
    startX: CGFloat,
    startY: CGFloat,
    keyWidth: CGFloat,
    keyHeight: CGFloat,
    char: String
) -> UIBezierPath {
    setPopPathState(
        startX: startX, startY: startY, keyHeight: keyHeight, char: char, position: "left"
    )
    
    // Path is clockwise from bottom left.
    let path = UIBezierPath()
    path.move(to: CGPoint(x: horizStart + (keyWidth * 0.075), y: vertStart))
    
    // Curve up past bottom left, path up, and curve right past the top left.
    path.addCurve(
        to: CGPoint(x: horizStart, y: vertStart - (keyHeight * 0.075)),
        controlPoint1: CGPoint(x: horizStart + (keyWidth * 0.075), y: minHeightCurveControl),
        controlPoint2: CGPoint(x: horizStart, y: minHeightCurveControl)
    )
    path.addLine(to: CGPoint(x: horizStart, y: heightBeforeTopCurves))
    path.addCurve(
        to: CGPoint(x: horizStart + (keyWidth * 0.35), y: maxHeight),
        controlPoint1: CGPoint(x: horizStart, y: maxHeightCurveControl),
        controlPoint2: CGPoint(x: horizStart + (keyWidth * 0.2), y: maxHeight)
    )
    
    // Path right, curve down past the top right, and path down.
    path.addLine(to: CGPoint(x: horizStart + (keyWidth * (1 + widthMultiplier * 0.35)), y: maxHeight))
    path.addCurve(
        to: CGPoint(x: horizStart + (keyWidth * (1 + widthMultiplier)), y: heightBeforeTopCurves * 1.15),
        controlPoint1: CGPoint(x: horizStart + (keyWidth * (1 + widthMultiplier * 0.75)), y: maxHeight),
        controlPoint2: CGPoint(x: horizStart + (keyWidth * (1 + widthMultiplier)), y: maxHeightCurveControl)
    )
    path.addLine(to: CGPoint(x: horizStart + (keyWidth * (1 + widthMultiplier)), y: vertStart - (keyHeight * 1.3)))
    
    // Curve in to the left, go down, and curve down past bottom left.
    path.addCurve(
        to: CGPoint(x: horizStart + keyWidth, y: vertStart - (keyHeight * 0.5)),
        controlPoint1: CGPoint(x: horizStart + (keyWidth * (1 + widthMultiplier)), y: vertStart - (keyHeight * 1.05)),
        controlPoint2: CGPoint(x: horizStart + keyWidth, y: vertStart - (keyHeight * 0.9))
    )
    path.addLine(to: CGPoint(x: horizStart + keyWidth, y: vertStart - (keyHeight * 0.075)))
    path.addCurve(
        to: CGPoint(x: horizStart + (keyWidth * 0.925), y: vertStart),
        controlPoint1: CGPoint(x: horizStart + keyWidth, y: minHeightCurveControl),
        controlPoint2: CGPoint(x: horizStart + (keyWidth * 0.925), y: minHeightCurveControl)
    )
    
    path.close()
    return path
}


func checkLandscapeMode() {
  if UIScreen.main.bounds.height < UIScreen.main.bounds.width {
    isLandscapeView = true
  } else {
    isLandscapeView = false
  }
}

func createPopUpViewForIpadPro(for button: UIButton) -> UIView {
    button.superview?.layoutIfNeeded()
    let popUpView = UIView()
    popUpView.backgroundColor = .white
    popUpView.layer.cornerRadius = 8
    popUpView.layer.borderWidth = 1
    popUpView.layer.borderColor = UIColor.lightGray.cgColor
    popUpView.alpha = 0 // Start hidden
    
    let subView = UIView()
    subView.backgroundColor = UIColor(red: 0/255, green: 110/255, blue: 249/255, alpha: 1.0)
    subView.layer.cornerRadius = 4
    popUpView.addSubview(subView)
    
    subView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
        subView.leadingAnchor.constraint(equalTo: popUpView.leadingAnchor, constant: 4),
        subView.trailingAnchor.constraint(equalTo: popUpView.trailingAnchor, constant: -4),
        subView.topAnchor.constraint(equalTo: popUpView.topAnchor, constant: 4),
        subView.bottomAnchor.constraint(equalTo: popUpView.bottomAnchor, constant: -4)
    ])
    
    let label = UILabel()
//    label.text = button.title(for: .normal)
    label.text = button.titleLabel?.text
    label.font = button.titleLabel?.font
    label.textAlignment = .center
    label.textColor = .white
    popUpView.addSubview(label)
    
    label.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
        label.centerXAnchor.constraint(equalTo: popUpView.centerXAnchor),
        label.centerYAnchor.constraint(equalTo: popUpView.centerYAnchor),
        label.leadingAnchor.constraint(greaterThanOrEqualTo: popUpView.leadingAnchor, constant: 8),
        label.trailingAnchor.constraint(lessThanOrEqualTo: popUpView.trailingAnchor, constant: -8),
        label.topAnchor.constraint(greaterThanOrEqualTo: popUpView.topAnchor, constant: 8),
        label.bottomAnchor.constraint(lessThanOrEqualTo: popUpView.bottomAnchor, constant: -8)
    ])
    return popUpView
}
