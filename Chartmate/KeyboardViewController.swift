//
//  KeyboardViewController.swift
//  Chartmate
//
//  Created by Mac User on 20/06/24.
//

import UIKit
import AudioToolbox

enum IPadKeyBoardType {
    case iPadPro
    case iPadMini
    case iPadAir
    case iPad
}

class CustomTappableView: UIView {
    weak var button: UIButton?

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        // Check if the point is within the bounds of the tappable area
        if self.point(inside: point, with: event) {
            // Forward the touch to the button
            return button
        }
        return super.hitTest(point, with: event)
    }
}


class KeyboardButton: UIButton {
    
    var defaultBackgroundColor: UIColor = .white
    var highlightBackgroundColor: UIColor = .lightGray
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = isHighlighted ? highlightBackgroundColor : defaultBackgroundColor
    }
    
}

// MARK: - Private Methods
private extension KeyboardButton {
    func commonInit() {
        layer.cornerRadius = 5.0
        layer.masksToBounds = false
        layer.shadowOffset = CGSize(width: 0, height: 1.0)
        layer.shadowRadius = 0.0
        layer.shadowOpacity = 0.35
    }
}


//class KeyboardButton: UIButton {
//
//    // Property for padding around the button (expandable hit area)
//    var touchAreaInsets: UIEdgeInsets = UIEdgeInsets(top: -5, left: -2.5, bottom: -5, right: -2.5)
//
//    var defaultBackgroundColor: UIColor = .white
//    var highlightBackgroundColor: UIColor = .lightGray
//
//    // Override point(inside:with:) to expand the touch area using touchAreaInsets
//    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
//        let expandedRect = self.bounds.inset(by: touchAreaInsets)
//        return expandedRect.contains(point)
//    }
//
//    // Rest of the button's customization
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        commonInit()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        commonInit()
//    }
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        backgroundColor = isHighlighted ? highlightBackgroundColor : defaultBackgroundColor
//    }
//
//    private func commonInit() {
//        // Custom button style initialization here
//        layer.cornerRadius = 5.0
//        layer.masksToBounds = false
//        layer.shadowOffset = CGSize(width: 0, height: 1.0)
//        layer.shadowRadius = 0.0
//        layer.shadowOpacity = 0.35
//    }
//
//    // Call the action when the button (or the expanded area) is tapped
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        super.touchesBegan(touches, with: event)
////        if isT {
//            // Trigger the button's action, same as for tap inside the button
//            didTapButton(sender: self)
////        }
//    }
//
//    // Define the action method
//    @objc func didTapButton(sender: UIButton) {
//        print("Tapped on button or outside area")
//    }
//}

class KeyboardViewController: UIInputViewController {
    
    var iPadKeyBoardType: IPadKeyBoardType = .iPad
    
    var capButton: KeyboardButton!
    var spacialCharButton: KeyboardButton!
    var numericButton: KeyboardButton!
    var deleteButton: KeyboardButton!
    var nextKeyboardButton: KeyboardButton!
    var returnButton: KeyboardButton!
    
    var iPadCap1Button: KeyboardButton!
    var iPadCap2Button: KeyboardButton!
    var iPadTabButton: KeyboardButton!
    var iPadDeleteButton: KeyboardButton!
    var iPadNumeric1Button: KeyboardButton!
    var iPadNumeric2Button: KeyboardButton!
    var iPadNextKeyboardButton: KeyboardButton!
    var iPadHideKeyboardButton: KeyboardButton!
    var iPadReturnButton: KeyboardButton!
    var iPadLanguageButton: KeyboardButton!
    var iPadSpacialChar1Button: KeyboardButton!
    var iPadSpacialChar2Button: KeyboardButton!
    
    var deleteTimer: Timer?
    var deleteKeyInitialPress: Bool = true
    
    var isCapitalsShowing = false
    var isAllTimeCapitalsShowing = false
    
    let screenWidth = UIScreen.main.bounds.width

//    {
//
//        didSet{
//            for view in mainStackView.arrangedSubviews {
//                view.removeFromSuperview()
//            }
//            if isCapitalsShowing {
//                self.addCapitalKeyboardButtons()
//            } else {
//                self.addKeyboardButtons()
//            }
//        }
//
//    }
//    var isAllTimeCapitalsShowing = false {
//
//        didSet{
//
//            if isAllTimeCapitalsShowing {
//                for view in mainStackView.arrangedSubviews {
//                    view.removeFromSuperview()
//                }
//                self.addCapitalKeyboardButtons()
//
//            }
//
//        }
//
//    }
    
    var areLettersShowing = true {
        
        didSet{
            
            if areLettersShowing {
                for view in mainStackView.arrangedSubviews {
                    view.removeFromSuperview()
                }
                self.addKeyboardButtons()
                
            } else {
                displayNumericKeys()
            }
            
        }
        
    }
    
    var areSpacialCharShowing = false {
        
        didSet {
            if !areSpacialCharShowing {
                for view in mainStackView.arrangedSubviews {
                    view.removeFromSuperview()
                }
                self.displayNumericKeys()
            } else {
                displaySpacialCharKeys()
            }
            
        }
        
    }

    
    var allTextButtons = [KeyboardButton]()
    
    var keyboardHeight: CGFloat = 210
    var KeyboardVCHeightConstraint: NSLayoutConstraint!
    var containerViewHeight: CGFloat = 60.0
    
    var userLexicon: UILexicon?
    
    var notificationDictionary = [String: Any]()
    
    
    var currentWord: String? {
        var lastWord: String?
        // 1
        if let stringBeforeCursor = textDocumentProxy.documentContextBeforeInput {
            // 2
            stringBeforeCursor.enumerateSubstrings(in: stringBeforeCursor.startIndex...,
                                                   options: .byWords)
            { word, _, _, _ in
                // 3
                if let word = word {
                    lastWord = word
                }
            }
        }
        return lastWord
    }
    
    var isNumberPadNeeded: Bool = false {
        
        didSet{
            
            if isNumberPadNeeded {
                // Show Number Pad
                self.showNumberPad()
            }else {
                // Show Default Keyboard
                for view in mainStackView.arrangedSubviews {
                    view.removeFromSuperview()
                }
                self.addKeyboardButtons()
            }
            
        }
        
    }
    
    private var primaryView: UIView!
    private var heightConstraint: NSLayoutConstraint!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.keyboardHeight = self.checkKeyBoardHeight()
        self.KeyboardVCHeightConstraint = NSLayoutConstraint(item: self.view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: keyboardHeight+containerViewHeight)
        self.view.addConstraint(self.KeyboardVCHeightConstraint)
    
        self.addKeyboardButtons()
//        self.setNextKeyboardVisible(needsInputModeSwitchKey)
        
        requestSupplementaryLexicon { lexicon in
            for entry in lexicon.entries {
                print("Word: \(entry.documentText), Shortcut: \(entry.userInput)")
            }
        }
        
        self.requestSupplementaryLexicon { (lexicon) in
            self.userLexicon = lexicon
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.view.removeConstraint(KeyboardVCHeightConstraint)
//        self.view.addConstraint(self.KeyboardVCHeightConstraint)
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        // Add custom view sizing constraints here
//        self.view.removeConstraint(KeyboardVCHeightConstraint)
//        self.view.addConstraint(self.KeyboardVCHeightConstraint)
    }
    
    override func textWillChange(_ textInput: UITextInput?) {
        // The app is about to change the document's contents. Perform any preparation here.
    }
    
    override func textDidChange(_ textInput: UITextInput?) {
        // The app has just changed the document's contents, the document context has been updated.
        self.setColor()
        //Sets return key title on keyboard...
        if let returnTitle = self.textDocumentProxy.returnKeyType {
            let type = UIReturnKeyType(rawValue: returnTitle.rawValue)
            guard let retTitle = type?.get(rawValue: (type?.rawValue)!) else {return}
            if IS_IPAD {
                self.iPadReturnButton.setTitle(retTitle, for: .normal)
            } else {
                self.returnButton.setTitle(retTitle, for: .normal)
            }
            
        }
        
    }
    
    func checkKeyBoardHeight() -> Double {
        checkLandscapeMode()
        var checkKeyboardHeight = 0.0
        if DeviceType.isPhone {
            if isLandscapeView {
                checkKeyboardHeight = 160
            } else {
                checkKeyboardHeight = 210
            }
        } else if DeviceType.isPad {
            // Expanded keyboard on larger iPads can be higher.
            if UIScreen.main.bounds.width > 820 {
                if isLandscapeView {
                    checkKeyboardHeight = 370
                } else {
                    checkKeyboardHeight = 310
                }
            } else {
                if isLandscapeView {
                    checkKeyboardHeight = 300
                } else {
                    checkKeyboardHeight = 250
                }
            }
        }
//         if DeviceType.isPad {
//          // Expanded keyboard on larger iPads can be higher.
//          if UIScreen.main.bounds.width > 768 {
//            if isLandscapeView {
//              keyboardHeight = 430
//            } else {
//              keyboardHeight = 360
//            }
//          } else {
//            if isLandscapeView {
//              keyboardHeight = 420
//            } else {
//              keyboardHeight = 340
//            }
//          }
//        }
        return checkKeyboardHeight
    }
    
    //Handles NextKeyBoard Button Appearance..
    func setNextKeyboardVisible(_ visible: Bool) {
        if IS_IPAD {
            iPadNextKeyboardButton.isHidden = !visible

        } else {
            nextKeyboardButton.isHidden = !visible
        }
    }
    
    func setColor() {
        let colorScheme = returnColorSheme()
        self.setColorScheme(colorScheme)
    }
    
    func returnColorSheme() -> KBColorScheme {
        let colorScheme: KBColorScheme
        if textDocumentProxy.keyboardAppearance == .dark {
            colorScheme = .dark
        } else {
            colorScheme = .light
        }
        return colorScheme
    }
    
    //Set color scheme For keyboard appearance...
    func setColorScheme(_ colorScheme: KBColorScheme) {
        
        let themeColor = KBColors(colorScheme: colorScheme)
        if IS_IPAD {
            self.iPadTabButton.defaultBackgroundColor = themeColor.buttonHighlightColor
            self.iPadDeleteButton.defaultBackgroundColor = themeColor.buttonHighlightColor
            self.iPadCap1Button.defaultBackgroundColor = !isCapitalsShowing ? themeColor.buttonHighlightColor : themeColor.buttonBackgroundColor
            self.iPadCap2Button.defaultBackgroundColor = !isCapitalsShowing ? themeColor.buttonHighlightColor : themeColor.buttonBackgroundColor
            self.iPadSpacialChar1Button.defaultBackgroundColor = themeColor.buttonHighlightColor
            self.iPadSpacialChar2Button.defaultBackgroundColor = themeColor.buttonHighlightColor
            self.iPadNumeric1Button.defaultBackgroundColor = themeColor.buttonHighlightColor
            self.iPadNumeric2Button.defaultBackgroundColor = themeColor.buttonHighlightColor
            self.iPadNextKeyboardButton.defaultBackgroundColor = themeColor.buttonHighlightColor
            self.iPadHideKeyboardButton.defaultBackgroundColor = themeColor.buttonHighlightColor
            self.iPadReturnButton.defaultBackgroundColor = themeColor.buttonHighlightColor
            self.iPadLanguageButton.defaultBackgroundColor = themeColor.buttonHighlightColor
            
            self.iPadTabButton.highlightBackgroundColor = themeColor.buttonBackgroundColor
            self.iPadDeleteButton.highlightBackgroundColor = themeColor.buttonBackgroundColor
            self.iPadCap1Button.highlightBackgroundColor = themeColor.buttonBackgroundColor
            self.iPadCap2Button.highlightBackgroundColor = themeColor.buttonBackgroundColor
            self.iPadSpacialChar1Button.highlightBackgroundColor = themeColor.buttonBackgroundColor
            self.iPadSpacialChar2Button.highlightBackgroundColor = themeColor.buttonBackgroundColor
            self.iPadNextKeyboardButton.highlightBackgroundColor = themeColor.buttonBackgroundColor
            self.iPadReturnButton.highlightBackgroundColor = themeColor.buttonBackgroundColor
            self.iPadNumeric1Button.highlightBackgroundColor = themeColor.buttonBackgroundColor
            self.iPadNumeric2Button.highlightBackgroundColor = themeColor.buttonBackgroundColor
            self.iPadHideKeyboardButton.highlightBackgroundColor = themeColor.buttonBackgroundColor
            self.iPadLanguageButton.highlightBackgroundColor = themeColor.buttonBackgroundColor

            self.iPadTabButton.setTitleColor(themeColor.buttonTextColor, for: .normal)
            self.iPadDeleteButton.setTitleColor(themeColor.buttonTextColor, for: .normal)
            self.iPadCap1Button.setTitleColor(themeColor.buttonTextColor, for: .normal)
            self.iPadCap2Button.setTitleColor(themeColor.buttonTextColor, for: .normal)
            self.iPadSpacialChar1Button.setTitleColor(themeColor.buttonTextColor, for: .normal)
            self.iPadSpacialChar2Button.setTitleColor(themeColor.buttonTextColor, for: .normal)
            self.iPadNumeric1Button.setTitleColor(themeColor.buttonTextColor, for: .normal)
            self.iPadNumeric2Button.setTitleColor(themeColor.buttonTextColor, for: .normal)
            self.iPadNextKeyboardButton.setTitleColor(themeColor.buttonTextColor, for: .normal)
            self.iPadHideKeyboardButton.setTitleColor(themeColor.buttonTextColor, for: .normal)
            self.iPadLanguageButton.setTitleColor(themeColor.buttonTextColor, for: .normal)
            self.iPadReturnButton.setTitleColor(themeColor.buttonTextColor, for: .normal)
           
        } else {
            self.capButton.defaultBackgroundColor = themeColor.buttonHighlightColor
            self.spacialCharButton.defaultBackgroundColor = themeColor.buttonHighlightColor
            self.deleteButton.defaultBackgroundColor = themeColor.buttonHighlightColor
            self.numericButton.defaultBackgroundColor = themeColor.buttonHighlightColor
            self.nextKeyboardButton.defaultBackgroundColor = themeColor.buttonHighlightColor
            self.returnButton.defaultBackgroundColor = themeColor.buttonHighlightColor
            
            self.capButton.highlightBackgroundColor = themeColor.buttonBackgroundColor
            self.spacialCharButton.highlightBackgroundColor = themeColor.buttonBackgroundColor
            self.deleteButton.highlightBackgroundColor = themeColor.buttonBackgroundColor
            self.nextKeyboardButton.highlightBackgroundColor = themeColor.buttonBackgroundColor
            self.returnButton.highlightBackgroundColor = themeColor.buttonBackgroundColor
            self.numericButton.highlightBackgroundColor = themeColor.buttonBackgroundColor
            
            self.capButton.setTitleColor(themeColor.buttonTextColor, for: .normal)
            self.spacialCharButton.setTitleColor(themeColor.buttonTextColor, for: .normal)
            self.deleteButton.setTitleColor(themeColor.buttonTextColor, for: .normal)
            self.numericButton.setTitleColor(themeColor.buttonTextColor, for: .normal)
            self.nextKeyboardButton.setTitleColor(themeColor.buttonTextColor, for: .normal)
            self.returnButton.setTitleColor(themeColor.buttonTextColor, for: .normal)
            self.deleteButton.tintColor = themeColor.buttonTintColor
        }
        
        for button in allTextButtons {
            
            button.tintColor = themeColor.buttonTintColor
            button.defaultBackgroundColor = themeColor.buttonBackgroundColor
            button.highlightBackgroundColor = themeColor.buttonHighlightColor
            button.setTitleColor(themeColor.buttonTextColor, for: .normal)
            
        }
    
    }
    
    func numericRowServeiceKeysForiPad(midRow: UIView)->(UIStackView) {
    
        self.iPadDeleteButton = accessoryIPADButtons(title: "delete", img: nil, tag: 2)
        self.iPadDeleteButton.widthAnchor.constraint(equalToConstant: screenWidth/12 - 10).isActive = true
        self.iPadDeleteButton.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.right
        self.iPadDeleteButton.contentVerticalAlignment = UIControl.ContentVerticalAlignment.bottom
        self.iPadDeleteButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 10.0, right: 10.0)
        
        let iPadDeleteButtonView = serveiceKeysCustomTappableIPadView(button: self.iPadDeleteButton, position: .right)
        
        let numericRowSV = UIStackView(arrangedSubviews: [midRow, iPadDeleteButtonView])
        numericRowSV.distribution = .fillProportionally
        numericRowSV.spacing = 10
        return (numericRowSV)
    }
    
    func firstRowServeiceKeysForiPad(midRow: UIView)->(UIStackView) {
        self.iPadTabButton = accessoryIPADButtons(title: "tab", img: nil, tag: 1)
        if self.iPadKeyBoardType == .iPadPro {
            self.iPadTabButton.widthAnchor.constraint(equalToConstant: screenWidth/10.5).isActive = true
            
            self.iPadTabButton.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
            self.iPadTabButton.contentVerticalAlignment = UIControl.ContentVerticalAlignment.bottom
            self.iPadTabButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10.0, bottom: 10.0, right: 0)
        } else if self.iPadKeyBoardType == .iPadMini {
            self.iPadDeleteButton = accessoryIPADButtons(title: nil, img: UIImage(systemName: "delete.left"), tag: 2)
            self.iPadDeleteButton.widthAnchor.constraint(equalToConstant: screenWidth/11 - 10).isActive = true
        } else {
            self.iPadDeleteButton = accessoryIPADButtons(title: "delete", img: nil, tag: 2)
            self.iPadDeleteButton.widthAnchor.constraint(equalToConstant: screenWidth/12 - 10).isActive = true
            
            self.iPadTabButton.widthAnchor.constraint(equalToConstant: screenWidth/12 - 10).isActive = true
        }
        
        let iPadTabButtonView = serveiceKeysCustomTappableIPadView(button: self.iPadTabButton, position: .left)
//        let iPadDeleteButtonView = serveiceKeysCustomTappableIPadView(button: self.iPadDeleteButton, position: .right)
        
        var firstRow = [UIView]()
        if self.iPadKeyBoardType == .iPadPro {
            firstRow = [iPadTabButtonView, midRow]
        } else if self.iPadKeyBoardType == .iPadMini {
            firstRow = [midRow, self.iPadDeleteButton]
        } else {
            firstRow = [iPadTabButtonView, midRow, self.iPadDeleteButton]
        }
//        let firstRowSV = UIStackView(arrangedSubviews: [self.iPadTabButton, midRow])
//        let firstRowSV = UIStackView(arrangedSubviews: [self.iPadTabButton, midRow, self.iPadDeleteButton])
//        let firstRowSV = UIStackView(arrangedSubviews: self.iPadKeyBoardType == .iPadPro ? [self.iPadTabButton, midRow] : [self.iPadTabButton, midRow, self.iPadDeleteButton])
        let firstRowSV = UIStackView(arrangedSubviews: firstRow)
        firstRowSV.distribution = .fillProportionally
        firstRowSV.spacing = 10
        return (firstRowSV)
    }
    
    func secondRowServeiceKeysForiPad(midRow: UIView)->(UIStackView) {
        
        self.iPadLanguageButton = accessoryIPADButtons(title: "Language", img: nil, tag: 3)
        self.iPadLanguageButton.widthAnchor.constraint(equalToConstant: screenWidth/9.5).isActive = true
        
        if let returnTitle = self.textDocumentProxy.returnKeyType {
            let type = UIReturnKeyType(rawValue: returnTitle.rawValue)
            let retTitle = type?.get(rawValue: (type?.rawValue)!)
            self.iPadReturnButton = accessoryIPADButtons(title: retTitle, img: nil, tag: 4)
        } else {
            self.iPadReturnButton = accessoryIPADButtons(title: "return", img: nil, tag: 4)
        }
        self.iPadReturnButton.widthAnchor.constraint(equalToConstant: screenWidth/8).isActive = true
        if self.iPadKeyBoardType == .iPadPro {
            self.iPadReturnButton.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.right
            self.iPadReturnButton.contentVerticalAlignment = UIControl.ContentVerticalAlignment.bottom
            self.iPadReturnButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 10.0, right: 10.0)
            
            self.iPadLanguageButton.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
            self.iPadLanguageButton.contentVerticalAlignment = UIControl.ContentVerticalAlignment.bottom
            self.iPadLanguageButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10.0, bottom: 10.0, right: 0)
        }

        let iPadReturnButtonView = serveiceKeysCustomTappableIPadView(button: self.iPadReturnButton, position: .right)
        let iPadLanguageButtonView = serveiceKeysCustomTappableIPadView(button: self.iPadLanguageButton, position: .left)
        
        var secondRow = [UIView]()
        if self.iPadKeyBoardType == .iPadMini {
            secondRow = [midRow, iPadReturnButtonView]
        } else {
            secondRow = [iPadLanguageButtonView, midRow, iPadReturnButtonView]
//            secondRow = [self.iPadLanguageButton, midRow, self.iPadReturnButton]
        }

//        let secondRowSV = UIStackView(arrangedSubviews: [self.iPadLanguageButton, midRow, self.iPadReturnButton])
        let secondRowSV = UIStackView(arrangedSubviews: secondRow)
        secondRowSV.distribution = .fillProportionally
        secondRowSV.spacing = 10
        return secondRowSV
    }
    
    func serveiceKeysForiPad(midRow: UIView)->(UIStackView, UIStackView) {
        let colorScheme = returnColorSheme()
        let themeColor = KBColors(colorScheme: colorScheme)
        
        
        if self.iPadKeyBoardType == .iPadPro {
            self.iPadCap1Button = accessoryIPADButtons(title: "shift", img: nil, tag: 5)
            self.iPadCap2Button = accessoryIPADButtons(title: "shift", img: nil, tag: 5)
            self.iPadCap1Button.widthAnchor.constraint(equalToConstant: screenWidth/7).isActive = true
            self.iPadCap2Button.widthAnchor.constraint(equalToConstant: screenWidth/7).isActive = true
            
            self.iPadSpacialChar1Button = accessoryIPADButtons(title: "redo", img: nil, tag: 10)
            self.iPadSpacialChar2Button = accessoryIPADButtons(title: areSpacialCharShowing ? "123" : "#+=", img: nil, tag: 10)
            self.iPadSpacialChar1Button.widthAnchor.constraint(equalToConstant: screenWidth/7).isActive = true
            self.iPadSpacialChar2Button.widthAnchor.constraint(equalToConstant: screenWidth/7).isActive = true
            
            self.iPadSpacialChar1Button.isUserInteractionEnabled = false
            self.iPadSpacialChar2Button.isUserInteractionEnabled = false
            self.iPadSpacialChar2Button.isHidden = true
            
            
            self.iPadCap1Button.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
            self.iPadCap1Button.contentVerticalAlignment = UIControl.ContentVerticalAlignment.bottom
            self.iPadCap1Button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10.0, bottom: 10.0, right: 0)
            
            self.iPadCap2Button.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.right
            self.iPadCap2Button.contentVerticalAlignment = UIControl.ContentVerticalAlignment.bottom
            self.iPadCap2Button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 10.0, right: 10.0)
            
            self.iPadSpacialChar1Button.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
            self.iPadSpacialChar1Button.contentVerticalAlignment = UIControl.ContentVerticalAlignment.bottom
            self.iPadSpacialChar1Button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10.0, bottom: 10.0, right: 0)
            
        } else if self.iPadKeyBoardType == .iPadMini {
            self.iPadCap1Button = accessoryIPADButtons(title: nil, img: UIImage(systemName: "shift"), tag: 5)
            self.iPadCap2Button = accessoryIPADButtons(title: nil, img: UIImage(systemName: "shift"), tag: 5)
            self.iPadCap1Button.widthAnchor.constraint(equalToConstant: screenWidth/11 - 10).isActive = true
            self.iPadCap2Button.widthAnchor.constraint(equalToConstant: screenWidth/10 - 7).isActive = true
            
            self.iPadSpacialChar1Button = accessoryIPADButtons(title: areSpacialCharShowing ? "123" : "#+=", img: nil, tag: 10)
            self.iPadSpacialChar2Button = accessoryIPADButtons(title: areSpacialCharShowing ? "123" : "#+=", img: nil, tag: 10)
            self.iPadSpacialChar1Button.widthAnchor.constraint(equalToConstant: screenWidth/11 - 10).isActive = true
            self.iPadSpacialChar2Button.widthAnchor.constraint(equalToConstant: screenWidth/10 - 7).isActive = true
            
        } else {
            self.iPadCap1Button = accessoryIPADButtons(title: "shift", img: nil, tag: 5)
            self.iPadCap2Button = accessoryIPADButtons(title: "shift", img: nil, tag: 5)
            self.iPadCap1Button.widthAnchor.constraint(equalToConstant: screenWidth/7).isActive = true
            self.iPadCap2Button.widthAnchor.constraint(equalToConstant: screenWidth/9).isActive = true
            
            self.iPadSpacialChar1Button = accessoryIPADButtons(title: areSpacialCharShowing ? "123" : "#+=", img: nil, tag: 10)
            self.iPadSpacialChar2Button = accessoryIPADButtons(title: areSpacialCharShowing ? "123" : "#+=", img: nil, tag: 10)
            self.iPadSpacialChar1Button.widthAnchor.constraint(equalToConstant: screenWidth/7).isActive = true
            self.iPadSpacialChar2Button.widthAnchor.constraint(equalToConstant: screenWidth/9).isActive = true
        }
        
        let iPadCap1ButtonView = serveiceKeysCustomTappableIPadView(button: self.iPadCap1Button, position: .left)
        let iPadSpacialChar1ButtonView = serveiceKeysCustomTappableIPadView(button: self.iPadSpacialChar1Button, position: .left)
        let iPadCap2ButtonView = serveiceKeysCustomTappableIPadView(button: self.iPadCap2Button, position: .right)
        let iPadSpacialChar2ButtonView = serveiceKeysCustomTappableIPadView(button: self.iPadSpacialChar2Button, position: .right)
        
        
        
        let thirdRowSV = UIStackView(arrangedSubviews: [areLettersShowing ? iPadCap1ButtonView : iPadSpacialChar1ButtonView, midRow, areLettersShowing ? iPadCap2ButtonView : iPadSpacialChar2ButtonView])
//        let thirdRowSV = UIStackView(arrangedSubviews: [areLettersShowing ? self.iPadCap1Button : self.iPadSpacialChar1Button, midRow, areLettersShowing ? self.iPadCap2Button : self.iPadSpacialChar2Button])
        thirdRowSV.distribution = .fillProportionally
        thirdRowSV.spacing = 10
        
        //Forth row
        self.iPadNextKeyboardButton = accessoryIPADButtons(title: nil, img: UIImage(systemName: "globe"), tag: 6)
        self.iPadNextKeyboardButton.widthAnchor.constraint(equalToConstant: screenWidth/8).isActive = true
        
        self.iPadNumeric1Button = accessoryIPADButtons(title: areLettersShowing ? ".?123" : "ABC", img: nil, tag: 7)
        self.iPadNumeric1Button.widthAnchor.constraint(equalToConstant: screenWidth/8).isActive = true

        self.iPadNumeric2Button = accessoryIPADButtons(title: areLettersShowing ? ".?123" : "ABC", img: nil, tag: 7)
        self.iPadNumeric2Button.widthAnchor.constraint(equalToConstant: screenWidth/8).isActive = true
        
        let spaceKey = accessoryIPADButtons(title: "", img: nil, tag: 8)
        spaceKey.setTitleColor(themeColor.buttonTextColor, for: .normal)
        
        self.iPadHideKeyboardButton = accessoryIPADButtons(title: nil, img: UIImage(systemName: "keyboard.chevron.compact.down"), tag: 9)
        self.iPadHideKeyboardButton.widthAnchor.constraint(equalToConstant: screenWidth/8).isActive = true
        
        if self.iPadKeyBoardType == .iPadPro {
            
            self.iPadNumeric1Button.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
            self.iPadNumeric1Button.contentVerticalAlignment = UIControl.ContentVerticalAlignment.bottom
            self.iPadNumeric1Button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10.0, bottom: 10.0, right: 0)
            
            self.iPadNumeric2Button.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.right
            self.iPadNumeric2Button.contentVerticalAlignment = UIControl.ContentVerticalAlignment.bottom
            self.iPadNumeric2Button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 10.0, right: 10.0)
            
            self.iPadNextKeyboardButton.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
            self.iPadNextKeyboardButton.contentVerticalAlignment = UIControl.ContentVerticalAlignment.bottom
            self.iPadNextKeyboardButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10.0, bottom: 10.0, right: 0)
            
            self.iPadHideKeyboardButton.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.right
            self.iPadHideKeyboardButton.contentVerticalAlignment = UIControl.ContentVerticalAlignment.bottom
            self.iPadHideKeyboardButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 10.0, right: 10.0)
            
        }
        
        let iPadNextKeyboardButtonView = serveiceKeysCustomTappableIPadView(button: self.iPadNextKeyboardButton, position: .left)
        let iPadNumeric1ButtonView = serveiceKeysCustomTappableIPadView(button: self.iPadNumeric1Button, position: .center)
        let spaceKeyView = serveiceKeysCustomTappableIPadView(button: spaceKey, position: .center)
        let iPadNumeric2ButtonView = serveiceKeysCustomTappableIPadView(button: self.iPadNumeric2Button, position: .center)
        let iPadHideKeyboardButtonView = serveiceKeysCustomTappableIPadView(button: self.iPadHideKeyboardButton, position: .right)
        
        let fourthRowSV: UIStackView
        if needsInputModeSwitchKey {
            fourthRowSV = UIStackView(arrangedSubviews: [iPadNextKeyboardButtonView, iPadNumeric1ButtonView, spaceKeyView, iPadNumeric2ButtonView, iPadHideKeyboardButtonView])
        } else {
            fourthRowSV = UIStackView(arrangedSubviews: [iPadNumeric1ButtonView, spaceKeyView, iPadNumeric2ButtonView, iPadHideKeyboardButtonView])
        }
//        let fourthRowSV = UIStackView(arrangedSubviews: [self.iPadNextKeyboardButton, self.iPadNumeric1Button, spaceKey, self.iPadNumeric2Button, self.iPadHideKeyboardButton])
        fourthRowSV.distribution = .fillProportionally
        fourthRowSV.spacing = 10
        
        return (thirdRowSV,fourthRowSV)
    }
    
    func serveiceKeysCustomTappableIPadView(button: KeyboardButton, position: Position) -> CustomTappableView {
        let wrapperView = CustomTappableView()
        wrapperView.translatesAutoresizingMaskIntoConstraints = false
        wrapperView.backgroundColor = UIColor(red: 203/255.0, green: 206/255.0, blue: 211/255.0, alpha: 1.0)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        wrapperView.addSubview(button)
        
        var leadingAnchor: CGFloat = 0
        var trailingAnchor: CGFloat = 0
        
        if position == .left {
            leadingAnchor = iPadKeyBoardType == .iPadPro ? 3.5 : 5
        } else if position == .right {
            trailingAnchor = iPadKeyBoardType == .iPadPro ? 3.5 : 5
        }
        
        // Add constraints for the button inside the wrapper view
        NSLayoutConstraint.activate([
            
            button.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor, constant: leadingAnchor),
            button.trailingAnchor.constraint(equalTo: wrapperView.trailingAnchor, constant: -trailingAnchor),
            button.topAnchor.constraint(equalTo: wrapperView.topAnchor, constant: (iPadKeyBoardType == .iPadPro ? 3.5 : 5)),
            button.bottomAnchor.constraint(equalTo: wrapperView.bottomAnchor, constant: (iPadKeyBoardType == .iPadPro ? -3.5 : -5))
        ])
        
        // Assign the button to the wrapper view's property
        wrapperView.button = button
        
        return wrapperView
    }
    
    var mainStackView: UIStackView!
    
    func serveiceKeys(midRow: UIView)->(UIStackView, UIStackView) {
        let colorScheme = returnColorSheme()
        let themeColor = KBColors(colorScheme: colorScheme)
        
        self.capButton = accessoryButtons(title: nil, img: UIImage(systemName: "shift"), tag: 1)
        self.deleteButton = accessoryButtons(title: nil, img: UIImage(systemName: "delete.left"), tag: 2)
        
        self.spacialCharButton = accessoryButtons(title: areSpacialCharShowing ? "123" : "#+=", img: nil, tag: 10)
        
        let capButtonView = serveiceKeysCustomTappableView(button: self.capButton, position: .left)
        let deleteButtonView = serveiceKeysCustomTappableView(button: self.deleteButton, position: .right)
        let spacialCharButtonView = serveiceKeysCustomTappableView(button: self.spacialCharButton, position: .left)
        
        let thirdRowSV = UIStackView(arrangedSubviews: [areLettersShowing ? capButtonView : spacialCharButtonView, midRow, deleteButtonView])
//        let thirdRowSV = UIStackView(arrangedSubviews: [areLettersShowing ? self.capButton : self.spacialCharButton,midRow,self.deleteButton])
        thirdRowSV.distribution = .fillProportionally
        thirdRowSV.spacing = 15
        
//        thirdRowSV.isLayoutMarginsRelativeArrangement = true
//        thirdRowSV.layoutMargins = UIEdgeInsets(top: 5, left: 2.5, bottom: 5, right: 2.5)
        
        self.numericButton = accessoryButtons(title: areLettersShowing ? "123" : "ABC", img: nil, tag: 3)
        self.nextKeyboardButton = accessoryButtons(title: nil, img: #imageLiteral(resourceName: "globe"), tag: 4)
        let spaceKey = accessoryButtons(title: "space", img: nil, tag: 6)
        spaceKey.setTitleColor(themeColor.buttonTextColor, for: .normal)
        
        if let returnTitle = self.textDocumentProxy.returnKeyType {
            let type = UIReturnKeyType(rawValue: returnTitle.rawValue)
            let retTitle = type?.get(rawValue: (type?.rawValue)!)
            self.returnButton = accessoryButtons(title: retTitle, img: nil, tag: 7)
        } else {
            self.returnButton = accessoryButtons(title: "return", img: nil, tag: 7)
        }
        
        let numericButtonView = serveiceKeysCustomTappableView(button: self.numericButton, position: .left)
        let nextKeyboardButtonView = serveiceKeysCustomTappableView(button: self.nextKeyboardButton, position: .center)
        let returnButtonView = serveiceKeysCustomTappableView(button: self.returnButton, position: .right)
        let spaceKeyView = serveiceKeysCustomTappableView(button: spaceKey, position: .center)
        
        let fourthRowSV: UIStackView
        if needsInputModeSwitchKey {
            fourthRowSV = UIStackView(arrangedSubviews: [numericButtonView, nextKeyboardButtonView, spaceKeyView, returnButtonView])
        } else {
            fourthRowSV = UIStackView(arrangedSubviews: [numericButtonView, spaceKeyView, returnButtonView])
        }
//        let fourthRowSV = UIStackView(arrangedSubviews: [self.numericButton, self.nextKeyboardButton, spaceKey, self.returnButton])
        fourthRowSV.distribution = .fillProportionally
        fourthRowSV.spacing = 5

        // Set layout margins
//        fourthRowSV.isLayoutMarginsRelativeArrangement = true
//        fourthRowSV.layoutMargins = UIEdgeInsets(top: 5, left: 2.5, bottom: 5, right: 2.5)
        
        
        return (thirdRowSV,fourthRowSV)
    }
    
    enum Position {
        case left
        case center
        case right
    }
    
    func serveiceKeysCustomTappableView(button: KeyboardButton, position: Position) -> CustomTappableView {
        let wrapperView = CustomTappableView()
        wrapperView.translatesAutoresizingMaskIntoConstraints = false
        wrapperView.backgroundColor = UIColor(red: 203/255.0, green: 206/255.0, blue: 211/255.0, alpha: 1.0)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        wrapperView.addSubview(button)
        
        var leadingAnchor: CGFloat = 0
        var trailingAnchor: CGFloat = 0
        
        if position == .left {
            leadingAnchor = 2.5
        } else if position == .right {
            trailingAnchor = 2.5
        }
        
        // Add constraints for the button inside the wrapper view
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor, constant: leadingAnchor),
            button.trailingAnchor.constraint(equalTo: wrapperView.trailingAnchor, constant: -trailingAnchor),
            button.topAnchor.constraint(equalTo: wrapperView.topAnchor, constant: 5),
            button.bottomAnchor.constraint(equalTo: wrapperView.bottomAnchor, constant: -5)
        ])
        
        // Assign the button to the wrapper view's property
        wrapperView.button = button
        
        return wrapperView
    }
    
    
    //Sound for key press
    func playSpaceKeySound(soundID: Int) {
        let systemSoundID: SystemSoundID = SystemSoundID(soundID)
        //            1155 For backword key
        //            1156 For other key
        AudioServicesPlaySystemSound(systemSoundID)
    }
    
    
    func createCustomTappableView(title: String, backgroundColorName: String = "939393") -> CustomTappableView {
        // Create the wrapper view
        let wrapperView = CustomTappableView()
        wrapperView.translatesAutoresizingMaskIntoConstraints = false
//        wrapperView.backgroundColor = UIColor(named: backgroundColorName)
        wrapperView.backgroundColor = UIColor(red: 203/255.0, green: 206/255.0, blue: 211/255.0, alpha: 1.0)
        
        // Create the button with the provided title
        let button = createButtonWithTitle(title: title)
        button.translatesAutoresizingMaskIntoConstraints = false
        wrapperView.addSubview(button)
        
        // Add constraints for the button inside the wrapper view
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor, constant: IS_IPAD ? (iPadKeyBoardType == .iPadPro ? 3.5 : 5) : 2.5),
            button.trailingAnchor.constraint(equalTo: wrapperView.trailingAnchor, constant: IS_IPAD ? (iPadKeyBoardType == .iPadPro ? -3.5 : -5) : -2.5),
            button.topAnchor.constraint(equalTo: wrapperView.topAnchor, constant: IS_IPAD ? (iPadKeyBoardType == .iPadPro ? 3.5 : 5) : 5),
            button.bottomAnchor.constraint(equalTo: wrapperView.bottomAnchor, constant: IS_IPAD ? (iPadKeyBoardType == .iPadPro ? -3.5 : -5) : -5)
        ])
        
        // Assign the button to the wrapper view's property
        wrapperView.button = button
        
        return wrapperView
    }
    
    // Adding Keys on UIView with UIStack View..
    func addRowsOnKeyboard(kbKeys: [String]) -> UIView {
        let RowStackView = UIStackView.init()
        RowStackView.spacing = 0 //5
//        RowStackView.spacing = IS_IPAD ? (iPadKeyBoardType == .iPadPro ? 7 : 10) : 0 //5
        RowStackView.axis = .horizontal
        RowStackView.alignment = .fill
        RowStackView.distribution = .fillEqually
        for (index, key) in kbKeys.enumerated() {
            
            if IS_IPAD && self.iPadKeyBoardType == .iPadPro && kbKeys.first == "`" && self.areLettersShowing {
                let subRow = ["~", "!", "@", "#", "$", "%", "^", "&", "*", "(", ")", "_", "+"]
                RowStackView.addArrangedSubview(createCustomTappableViewForIPAD(title: key, subTitle: subRow[index]))
//                RowStackView.addArrangedSubview(self.createButtonWithTwoTitleForIPAD(title: key, subTitle: subRow[index]))
            } else if IS_IPAD && self.iPadKeyBoardType == .iPadPro && kbKeys.first == "q" && self.areLettersShowing && ((key == "[") || (key == "]") || (key == "\\")) {
                let subRow = ["{", "}", "|"]
                RowStackView.addArrangedSubview(self.createCustomTappableViewForIPAD(title: key, subTitle: subRow[index - 10]))
//                RowStackView.addArrangedSubview(self.createButtonWithTwoTitleForIPAD(title: key, subTitle: subRow[index - 10]))
            } else if IS_IPAD && self.iPadKeyBoardType == .iPadPro && kbKeys.first == "a" && self.areLettersShowing && ((key == ";") || (key == "'")) {
                let subRow = [":", "\""]
                RowStackView.addArrangedSubview(self.createCustomTappableViewForIPAD(title: key, subTitle: subRow[index - 9]))
//                RowStackView.addArrangedSubview(self.createButtonWithTwoTitleForIPAD(title: key, subTitle: subRow[index - 9]))
            } else if IS_IPAD && self.iPadKeyBoardType == .iPadPro && kbKeys.first == "z" && self.areLettersShowing && ((key == ",") || (key == ".") || (key == "/")) {
                let subRow = ["<", ">", "?"]
                RowStackView.addArrangedSubview(self.createCustomTappableViewForIPAD(title: key, subTitle: subRow[index - 7]))
//                RowStackView.addArrangedSubview(self.createButtonWithTwoTitleForIPAD(title: key, subTitle: subRow[index - 7]))
            } else if IS_IPAD && ((self.iPadKeyBoardType == .iPad) || (self.iPadKeyBoardType == .iPadMini))  && ((kbKeys.first == "q") || (kbKeys.first == "Q")) {
                let subRow = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]
                RowStackView.addArrangedSubview(self.createCustomTappableViewForIPAD(title: key, subTitle: subRow[index]))
//                RowStackView.addArrangedSubview(self.createButtonWithTwoTitleForIPAD(title: key, subTitle: subRow[index]))
            } else if IS_IPAD && ((self.iPadKeyBoardType == .iPad) || (self.iPadKeyBoardType == .iPadMini))  && ((kbKeys.first == "a") || (kbKeys.first == "A")) {
                let subRow = ["@", "#", "$", "&", "*", "(", ")", "'", "\""]
                RowStackView.addArrangedSubview(self.createCustomTappableViewForIPAD(title: key, subTitle: subRow[index]))
//                RowStackView.addArrangedSubview(self.createButtonWithTwoTitleForIPAD(title: key, subTitle: subRow[index]))
            } else if IS_IPAD && ((self.iPadKeyBoardType == .iPad) || (self.iPadKeyBoardType == .iPadMini))  && ((kbKeys.first == "z") || (kbKeys.first == "Z")) {
                let subRow = ["%", "-", "+", "=", "/", ";", ":", ",", "."]
                RowStackView.addArrangedSubview(self.createCustomTappableViewForIPAD(title: key, subTitle: subRow[index]))
//                RowStackView.addArrangedSubview(self.createButtonWithTwoTitleForIPAD(title: key, subTitle: subRow[index]))
            } else if IS_IPAD && ((self.iPadKeyBoardType == .iPad) || (self.iPadKeyBoardType == .iPadMini))  && (kbKeys.first == "@") {
                let subRow = ["$", "£", "€", "_", "^", "[", "]", "{", "}"]
                RowStackView.addArrangedSubview(self.createCustomTappableViewForIPAD(title: key, subTitle: subRow[index]))
//                RowStackView.addArrangedSubview(self.createButtonWithTwoTitleForIPAD(title: key, subTitle: subRow[index]))
            } else if IS_IPAD && ((self.iPadKeyBoardType == .iPad) || (self.iPadKeyBoardType == .iPadMini))  && (kbKeys.first == "%") {
                let subRow = ["§", "|", "~", "...", "\\", "<", ">", "!", "?"]
                RowStackView.addArrangedSubview(self.createCustomTappableViewForIPAD(title: key, subTitle: subRow[index]))
//                RowStackView.addArrangedSubview(self.createButtonWithTwoTitleForIPAD(title: key, subTitle: subRow[index]))
            } else {
                let wrapperView = createCustomTappableView(title: key)
                RowStackView.addArrangedSubview(wrapperView)
            }
        }
//        for key in kbKeys {
//            if IS_IPAD && self.iPadKeyBoardType == .iPadPro && kbKeys.first == "`" {
//                RowStackView.addArrangedSubview(createButtonWithTwoTitleForIPAD(title: key, subTitle: ""))
//            } else {
//                RowStackView.addArrangedSubview(createButtonWithTitle(title: key))
//            }
//        }
        let keysView = UIView()
        keysView.backgroundColor = .clear
        keysView.addSubview(RowStackView)
        if ((kbKeys.first == "a") || (kbKeys.first == "A")) && IS_IPHONE {
            RowStackView.translatesAutoresizingMaskIntoConstraints = false
            let buttonWidth = (UIScreen.main.bounds.width / 10 - 2)
            NSLayoutConstraint.activate([
                RowStackView.leadingAnchor.constraint(equalTo: keysView.leadingAnchor, constant: buttonWidth/2),
                RowStackView.trailingAnchor.constraint(equalTo: keysView.trailingAnchor, constant: -(buttonWidth/2)),
                RowStackView.topAnchor.constraint(equalTo: keysView.topAnchor),
                RowStackView.bottomAnchor.constraint(equalTo: keysView.bottomAnchor)
            ])
        } else if (kbKeys.first == "…") && IS_IPAD && (iPadKeyBoardType == .iPadPro) {
            RowStackView.translatesAutoresizingMaskIntoConstraints = false
            let buttonWidth = (UIScreen.main.bounds.width / 14 - 2)
            NSLayoutConstraint.activate([
                RowStackView.leadingAnchor.constraint(equalTo: keysView.leadingAnchor, constant: buttonWidth),
                RowStackView.trailingAnchor.constraint(equalTo: keysView.trailingAnchor, constant: -(screenWidth/7 + 10)),
                RowStackView.topAnchor.constraint(equalTo: keysView.topAnchor),
                RowStackView.bottomAnchor.constraint(equalTo: keysView.bottomAnchor)
            ])
        } else if ((kbKeys.first == "a") || (kbKeys.first == "A") || (kbKeys.first == "@") || (kbKeys.first == "$")) && IS_IPAD && (self.iPadKeyBoardType == .iPadMini) {
            RowStackView.translatesAutoresizingMaskIntoConstraints = false
            let buttonWidth = (UIScreen.main.bounds.width / 10)
            NSLayoutConstraint.activate([
                RowStackView.leadingAnchor.constraint(equalTo: keysView.leadingAnchor, constant: buttonWidth/2 - 10),
                RowStackView.trailingAnchor.constraint(equalTo: keysView.trailingAnchor, constant: 0),
                RowStackView.topAnchor.constraint(equalTo: keysView.topAnchor),
                RowStackView.bottomAnchor.constraint(equalTo: keysView.bottomAnchor)
            ])
        } else {
            keysView.addConstraintsWithFormatString(formate: "H:|[v0]|", views: RowStackView)
            keysView.addConstraintsWithFormatString(formate: "V:|[v0]|", views: RowStackView)
        }
       
        return keysView
    }

    // Creates Buttons on Keyboard...
    func createButtonWithTwoTitleForIPAD(title: String, subTitle: String) -> KeyboardButton {
        
        let button = KeyboardButton(type: .system)
        if self.iPadKeyBoardType == .iPadPro && IS_IPAD {
            button.setTitle("\(subTitle)\n\(title)", for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        } else if self.iPadKeyBoardType == .iPadMini && IS_IPAD {
            let attributedText = attributedText(withString: "\(subTitle)\n\(title)", boldString: "\(subTitle)", font: UIFont.systemFont(ofSize: 24, weight: .regular))
            DispatchQueue.main.async {
                button.setAttributedTitle(attributedText, for: .normal)
            }
        } else if self.iPadKeyBoardType == .iPad && IS_IPAD {
            let attributedText = attributedText(withString: "\(subTitle)\n\(title)", boldString: "\(subTitle)", font: UIFont.systemFont(ofSize: 24, weight: .regular))
            DispatchQueue.main.async {
                button.setAttributedTitle(attributedText, for: .normal)
            }
        }
        else {
            button.setTitle("\(subTitle)\n\(title)", for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        }
        button.sizeToFit()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.textAlignment = .center
        button.addTarget(self, action: #selector(didTapButtonForTwoTitle(sender:)), for: .touchUpInside)
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(didTapButtonLongPressedForTwoTitle(gesture:)))
        longPressRecognizer.minimumPressDuration = 0.35
        button.addGestureRecognizer(longPressRecognizer)
        
        // Add swipe gesture recognizer for swipe down action
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(buttonSwipedDown(gesture:)))
        swipeDown.direction = .down
        button.addGestureRecognizer(swipeDown)
        
        allTextButtons.append(button)
        
        return button
    }
    
    func attributedText(withString string: String, boldString: String, font: UIFont) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: string, attributes: [NSAttributedString.Key.font: font])
        let boldFontAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .regular)]
        let range = (string.lowercased() as NSString).range(of: boldString.lowercased())
        attributedString.addAttributes(boldFontAttribute, range: range)
        attributedString.addAttributes([NSAttributedString.Key.foregroundColor : UIColor(red: 60/255, green: 60/255, blue: 67/255, alpha: 0.3)], range: range)
        return attributedString
    }
    
    func createCustomTappableViewForIPAD(title: String, subTitle: String) -> CustomTappableView {
        // Create the wrapper view
        let wrapperView = CustomTappableView()
        wrapperView.translatesAutoresizingMaskIntoConstraints = false
//        wrapperView.backgroundColor = UIColor(named: backgroundColorName)
        wrapperView.backgroundColor = UIColor(red: 203/255.0, green: 206/255.0, blue: 211/255.0, alpha: 1.0)
        
        // Create the button with the provided title
        let button = createButtonWithTwoTitleForIPAD(title: title, subTitle: subTitle)
//        let button = createButtonWithTitle(title: title)
        button.translatesAutoresizingMaskIntoConstraints = false
        wrapperView.addSubview(button)
        
        // Add constraints for the button inside the wrapper view
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor, constant: IS_IPAD ? (iPadKeyBoardType == .iPadPro ? 3.5 : 5) : 2.5),
            button.trailingAnchor.constraint(equalTo: wrapperView.trailingAnchor, constant: IS_IPAD ? (iPadKeyBoardType == .iPadPro ? -3.5 : -5) : -2.5),
            button.topAnchor.constraint(equalTo: wrapperView.topAnchor, constant: IS_IPAD ? (iPadKeyBoardType == .iPadPro ? 3.5 : 5) : 5),
            button.bottomAnchor.constraint(equalTo: wrapperView.bottomAnchor, constant: IS_IPAD ? (iPadKeyBoardType == .iPadPro ? -3.5 : -5) : -5)
        ])
        
        // Assign the button to the wrapper view's property
        wrapperView.button = button
        
        return wrapperView
    }
    
    
    func createButtonWithTitle(title: String) -> KeyboardButton {
        
        let button = KeyboardButton(type: .system)
        button.setTitle(title, for: .normal)
        button.sizeToFit()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 22, weight: .regular)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.textAlignment = .center
        
        if IS_IPAD {
            button.addTarget(self, action: #selector(didTapButton(sender:)), for: .touchUpInside)
        } else {
            let keyHoldPop = UILongPressGestureRecognizer(
              target: self,
              action: #selector(genHoldPopUpView(sender:))
            )
            keyHoldPop.minimumPressDuration = 0.125
            
            button.addTarget(self, action: #selector(genPopUpView), for: .touchDown)
            
            button.addGestureRecognizer(keyHoldPop)
        }
        allTextButtons.append(button)
        
        return button
    }
    
    @objc func handleTap() {
        print("View tapped!")
    }
    
    @objc func genHoldPopUpView(sender: UILongPressGestureRecognizer) {
      // Derive which button was pressed and get its alternates.
      guard let key: UIButton = sender.view as? UIButton else { return }
      let charPressed = key.titleLabel?.text ?? ""
      let displayChar = key.titleLabel?.text ?? ""

      // Timer is short as the alternates view gets canceled by sender.state.changed.
//        _ = Timer.scheduledTimer(withTimeInterval: 0.00001, repeats: false) { [self] _ in
//          if self.keysWithAlternates.contains(charPressed) {
//          self.setAlternatesView(sender: sender)
//              self.keyHoldPopLayer.removeFromSuperlayer()
//              self.keyHoldPopChar.removeFromSuperview()
//        }
//      }

      switch sender.state {
      case .began:
        genKeyPop(key: key, layer: keyHoldPopLayer, char: charPressed, displayChar: displayChar)
        view.layer.addSublayer(keyHoldPopLayer)
        view.addSubview(keyHoldPopChar)

      case .ended:
        // Remove the key hold pop up and execute key only if the alternates view isn't present.
        keyHoldPopLayer.removeFromSuperlayer()
        keyHoldPopChar.removeFromSuperview()
//        if !keysWithAlternates.contains(charPressed) {
//          executeKeyActions(key)
//        } else if view.viewWithTag(1001) == nil {
//          executeKeyActions(key)
//        }
        keyUntouched(key)

      default:
        break
      }
    }
    
    @objc func keyUntouched(_ sender: UIButton) {
        sender.backgroundColor = .white
    }
    
    @objc func genPopUpView(key: UIButton) {
        let charPressed = key.titleLabel?.text ?? ""
        //      let displayChar = key.layer.value(forKey: "keyToDisplay") as? String ?? ""
        let displayChar = key.titleLabel?.text ?? ""
        genKeyPop(key: key, layer: keyPopLayer, char: charPressed, displayChar: displayChar)
        
        view.layer.addSublayer(keyPopLayer)
        view.addSubview(keyPopChar)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.125) { [self] in
            self.inputView?.playInputClick​()
            let button = key
            guard let title = button.titleLabel?.text else { return }
            let proxy = self.textDocumentProxy
            proxy.insertText(title)
            
            print("Before Cursor Text", proxy.documentContextBeforeInput ?? "")
            print("After Cursor Text", proxy.documentContextAfterInput ?? "")
            keyPopLayer.removeFromSuperlayer()
            keyPopChar.removeFromSuperview()
        }
    }
    
    func genKeyPop(key: UIButton, layer: CAShapeLayer, char: String, displayChar: String) {
      setKeyPopCharSize(char: char)

      let popLbls = [keyPopChar, keyHoldPopChar]
        for lbl in popLbls {
            lbl.text = displayChar
            lbl.backgroundColor = .clear
            lbl.textAlignment = .center
            lbl.textColor = .black
            lbl.sizeToFit()
        }

      getKeyPopPath(key: key, layer: layer, char: char, displayChar: displayChar)
    }
    
    
    func getKeyPopPath(key: UIButton, layer: CAShapeLayer, char: String, displayChar: String) {
        // Get the frame in respect to the superview.
        if let frame = key.superview?.convert(key.frame, to: nil) {
            var labelVertPosition = frame.origin.y - key.frame.height / 1.75
            // non-capital characters should be higher for portrait phone views.
            if displayChar == char, DeviceType.isPhone, !isLandscapeView,
               !["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"].contains(char) {
                labelVertPosition = frame.origin.y - key.frame.height / 1.6
            } else if DeviceType.isPad,
                      isLandscapeView {
                labelVertPosition = frame.origin.y - key.frame.height / 2
            }
            
            if centralKeyChars.contains(char) {
                layer.path = centerKeyPopPath(
                    startX: frame.origin.x, startY: frame.origin.y,
                    keyWidth: key.frame.width, keyHeight: key.frame.height, char: char
                ).cgPath
                keyPopChar.center = CGPoint(x: frame.origin.x + key.frame.width * 0.5, y: labelVertPosition)
                keyHoldPopChar.center = CGPoint(x: frame.origin.x + key.frame.width * 0.5, y: labelVertPosition)
            
            } else if leftKeyChars.contains(char) {
                layer.path = leftKeyPopPath(
                    startX: frame.origin.x, startY: frame.origin.y,
                    keyWidth: key.frame.width, keyHeight: key.frame.height, char: char
                ).cgPath
                keyPopChar.center = CGPoint(x: frame.origin.x + key.frame.width * 0.85, y: labelVertPosition)
                keyHoldPopChar.center = CGPoint(x: frame.origin.x + key.frame.width * 0.85, y: labelVertPosition)
                if DeviceType.isPad || (DeviceType.isPhone && isLandscapeView) {
                    keyPopChar.center = CGPoint(x: frame.origin.x + key.frame.width * 0.65, y: labelVertPosition)
                    keyHoldPopChar.center = CGPoint(x: frame.origin.x + key.frame.width * 0.65, y: labelVertPosition)
                }
            } else if rightKeyChars.contains(char) {
                layer.path = rightKeyPopPath(
                    startX: frame.origin.x, startY: frame.origin.y,
                    keyWidth: key.frame.width, keyHeight: key.frame.height, char: char
                ).cgPath
                keyPopChar.center = CGPoint(x: frame.origin.x + key.frame.width * 0.15, y: labelVertPosition)
                keyHoldPopChar.center = CGPoint(x: frame.origin.x + key.frame.width * 0.15, y: labelVertPosition)
                if DeviceType.isPad || (DeviceType.isPhone && isLandscapeView) {
                    keyPopChar.center = CGPoint(x: frame.origin.x + key.frame.width * 0.35, y: labelVertPosition)
                    keyHoldPopChar.center = CGPoint(x: frame.origin.x + key.frame.width * 0.35, y: labelVertPosition)
                }
            }
            
            layer.strokeColor = UIColor.black.withAlphaComponent(0.2).cgColor
            layer.fillColor = UIColor(.white).cgColor
            layer.lineWidth = 1.0
        }
    }
    
    func executeKeyActions(_ sender: UIButton) {
//        self.inputView?.playInputClick​()
        let button = sender
        guard let title = button.titleLabel?.text else { return }
        let proxy = self.textDocumentProxy
        proxy.insertText(title)
        print("Before Cursor Text", proxy.documentContextBeforeInput ?? "")
        print("After Cursor Text", proxy.documentContextAfterInput ?? "")
    }
    
    @objc func buttonSwipedDown(gesture: UILongPressGestureRecognizer) {
        print("Button was swiped down")
        guard let button: UIButton = gesture.view as? UIButton else { return }
        guard let title = button.titleLabel?.text else { return }
        let proxy = self.textDocumentProxy
        if let lastCharacter = title.first {
            proxy.insertText(String(lastCharacter))
        }
    }
    
    @objc func didTapButtonForTwoTitle(sender: UIButton) {
        print("Button was tapped")
        let button = sender
        guard let title = button.titleLabel?.text else { return }
        let proxy = self.textDocumentProxy
        self.inputView?.playInputClick​()
//        proxy.insertText(title.last)
        if let lastCharacter = title.last {
            proxy.insertText(String(lastCharacter))
        }
        if self.areLettersShowing && self.isCapitalsShowing && !self.isAllTimeCapitalsShowing {
            self.isCapitalsShowing = false
            for view in self.mainStackView.arrangedSubviews {
                view.removeFromSuperview()
            }
            self.addKeyboardButtons()
        }
    }
    
    @objc func didTapButtonLongPressedForTwoTitle(gesture: UILongPressGestureRecognizer) {
        guard let button: UIButton = gesture.view as? UIButton else { return }
        guard let title = button.titleLabel?.text else { return }
        let proxy = self.textDocumentProxy
        let popUpView: UIView
        if let existingPopUpView = view.viewWithTag(1001) {
            popUpView = existingPopUpView
        } else {
            popUpView = createPopUpViewForIpadPro(for: button)
            popUpView.tag = 1001 // Assign a unique tag for identification
            popUpView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(popUpView)
            NSLayoutConstraint.activate([
                popUpView.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -4),
                popUpView.centerXAnchor.constraint(equalTo: button.centerXAnchor),
                popUpView.widthAnchor.constraint(equalToConstant: button.frame.width), // Fixed width
                popUpView.heightAnchor.constraint(equalToConstant: button.frame.height - 10) // Fixed height
            ])
        }
        if gesture.state == .began {
            print("Button is being held")
            popUpView.alpha = 1
            self.inputView?.playInputClick​()
        } else if gesture.state == .ended {
            print("Button long press ended")
            popUpView.alpha = 0
            popUpView.removeFromSuperview()
            if let lastCharacter = title.first {
                proxy.insertText(String(lastCharacter))
            }
        }
    }
    
    @objc func didTapButton(sender: UIButton) {
        print("Tapped")
        let button = sender
        guard let title = button.titleLabel?.text else { return }
        let proxy = self.textDocumentProxy
        self.inputView?.playInputClick​()
        proxy.insertText(title)
//        print("Before Cursor Text", proxy.documentContextBeforeInput ?? "")
//        print("After Cursor Text", proxy.documentContextAfterInput ?? "")
        if self.areLettersShowing && self.isCapitalsShowing && !self.isAllTimeCapitalsShowing {
            self.isCapitalsShowing = false
            for view in self.mainStackView.arrangedSubviews {
                view.removeFromSuperview()
            }
            self.addKeyboardButtons()
            
//            self.capButton.setImage(UIImage(systemName: "shift"), for: .normal)
//
//            let colorScheme = self.returnColorSheme()
//            let themeColor = KBColors(colorScheme: colorScheme)
//
//            self.capButton.tintColor = themeColor.buttonTextColor
        }
        
    }

    
    // Accesory Buttons On Keyboard...
    func accessoryIPADButtons(title: String?, img: UIImage?, tag: Int) -> KeyboardButton {
        
        let button = KeyboardButton.init(type: .system)

        if let buttonTitle = title {
            button.setTitle(buttonTitle, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        }
        
        if let buttonImage = img {
            button.setImage(buttonImage.withRenderingMode(.alwaysTemplate), for: .normal)
            button.tintColor = UIColor.black
        }
       
        button.sizeToFit()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tag = tag
        
        //For Tab...
        if button.tag == 1 {
            button.addTarget(self, action: #selector(handleTabCase(sender:)), for: .touchUpInside)
            return button
        }
        
        //For BackDelete Key // Install Once Only..
        if button.tag == 2 {
            button.addTarget(self, action: #selector(deleteKeyPressed), for: .touchDown)
            button.addTarget(self, action: #selector(deleteKeyReleased), for: [.touchUpInside, .touchUpOutside])
        }
        
        //For Language Key
        if button.tag == 3 {
            button.addTarget(self, action: #selector(handleLanguageCase), for: .touchUpInside)
        }
       
        //Handle return Button...//Usually depends on Texyfiled'd return Type...
        if button.tag == 4 {
            button.addTarget(self, action: #selector(handleReturnKey(sender:)), for: .touchUpInside)
            return button
        }
        
        //For Capitals...
        if button.tag == 5 {
            let singleTap = UITapGestureRecognizer(target: self, action: #selector(handleSingleCapitalsAndLowerCase(sender:)))
            singleTap.numberOfTapsRequired = 1
            button.addGestureRecognizer(singleTap)
        
            let doubleTap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleCapitalsAndLowerCase(sender:)))
            doubleTap.numberOfTapsRequired = 2
            button.addGestureRecognizer(doubleTap)
            
//            button.addTarget(self, action: #selector(handleSingleCapitalsAndLowerCase(sender:)), for: .touchUpInside)
            singleTap.require(toFail: doubleTap)
            return button
        }
        
        //Next Keyboard Button... Globe Button Usually...
        if button.tag == 6 {
            button.addTarget(self, action: #selector(handleInputModeList(from:with:)), for: .allTouchEvents)
            return button
        }
        
        //Switch to and From Letters & Numeric Keys
        if button.tag == 7 {
            button.addTarget(self, action: #selector(handleSwitchingNumericsAndLetters(sender:)), for: .touchUpInside)
            return button
        }
        
        //White Space Button...
        if button.tag == 8 {
            button.addTarget(self, action: #selector(insertWhiteSpace), for: .touchUpInside)
            return button
        }
        
        //For keyboard hide...
        if button.tag == 9 {
            button.addTarget(self, action: #selector(handleHideKeyboardCase(sender:)), for: .touchUpInside)
            return button
        }
        
        //Spacial char button
        if button.tag == 10 {
            button.addTarget(self, action: #selector(handleSpacialChars(sender:)), for: .touchUpInside)
            return button
        }
        
        return button
        
    }
    
    func accessoryButtons(title: String?, img: UIImage?, tag: Int) -> KeyboardButton {
        
        let button = KeyboardButton.init(type: .system)
        
        if let buttonTitle = title {
            button.setTitle(buttonTitle, for: .normal)
//            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        }
        
        if let buttonImage = img {
            button.setImage(buttonImage.withRenderingMode(.alwaysTemplate), for: .normal)
            button.tintColor = UIColor.black
        }
       
        button.sizeToFit()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tag = tag
        
        //For Capitals...
        if button.tag == 1 {
            let singleTap = UITapGestureRecognizer(target: self, action: #selector(handleSingleCapitalsAndLowerCase(sender:)))
            singleTap.numberOfTapsRequired = 1
            button.addGestureRecognizer(singleTap)
        
            let doubleTap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleCapitalsAndLowerCase(sender:)))
            doubleTap.numberOfTapsRequired = 2
            button.addGestureRecognizer(doubleTap)
            
//            button.addTarget(self, action: #selector(handleSingleCapitalsAndLowerCase(sender:)), for: .touchUpInside)
            singleTap.require(toFail: doubleTap)
            
            button.widthAnchor.constraint(equalToConstant: 42.5).isActive = true
            return button
        }
        //For BackDelete Key // Install Once Only..
        if button.tag == 2 {
//            let longPrssRcngr = UILongPressGestureRecognizer.init(target: self, action: #selector(onLongPressOfBackSpaceKey(longGestr:)))
//
//            //if !(button.gestureRecognizers?.contains(longPrssRcngr))! {
//            longPrssRcngr.minimumPressDuration = 0.2
//            longPrssRcngr.numberOfTouchesRequired = 1
//            longPrssRcngr.allowableMovement = 0.0
//            button.addGestureRecognizer(longPrssRcngr)
//            //}
            button.widthAnchor.constraint(equalToConstant: 42.5).isActive = true
            button.addTarget(self, action: #selector(deleteKeyPressed), for: .touchDown)
            button.addTarget(self, action: #selector(deleteKeyReleased), for: [.touchUpInside, .touchUpOutside])
        }
        //Switch to and From Letters & Numeric Keys
        if button.tag == 3 {
            button.addTarget(self, action: #selector(handleSwitchingNumericsAndLetters(sender:)), for: .touchUpInside)
            button.widthAnchor.constraint(equalToConstant: 50).isActive = true

            return button
        }
        //Next Keyboard Button... Globe Button Usually...
        if button.tag == 4 {
            button.addTarget(self, action: #selector(handleInputModeList(from:with:)), for: .allTouchEvents)
            button.widthAnchor.constraint(equalToConstant: 50).isActive = true

            return button
        }
        
        //White Space Button...
        if button.tag == 6 {
            button.addTarget(self, action: #selector(insertWhiteSpace), for: .touchUpInside)
//            button.widthAnchor.constraint(equalToConstant: 100).isActive = true
            return button
        }
        //Handle return Button...//Usually depends on Texyfiled'd return Type...
        if button.tag == 7 {
            button.addTarget(self, action: #selector(handleReturnKey(sender:)), for: .touchUpInside)
            button.widthAnchor.constraint(equalToConstant: 100).isActive = true
            return button
        }
        //Spacial char button
        if button.tag == 10 {
            button.addTarget(self, action: #selector(handleSpacialChars(sender:)), for: .touchUpInside)
            button.widthAnchor.constraint(equalToConstant: 42.5).isActive = true
            return button
        }
        //Else Case... For Others
//        button.addTarget(self, action: #selector(manualAction(sender:)), for: .touchUpInside)
        return button
        
    }
    
    @objc func deleteKeyPressed() {
        if deleteKeyInitialPress {
            deleteSingleCharacter()
            deleteKeyInitialPress = false
        }
        deleteTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(startContinuousDelete), userInfo: nil, repeats: false)
    }
    
    @objc func deleteKeyReleased() {
        deleteTimer?.invalidate()
        deleteTimer = nil
        deleteKeyInitialPress = true
    }
    
    @objc func startContinuousDelete() {
        deleteTimer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(deleteSingleCharacter), userInfo: nil, repeats: true)
    }
    
    @objc func deleteSingleCharacter() {
        self.playSpaceKeySound(soundID: 1155)
        self.textDocumentProxy.deleteBackward()
    }
    
    @objc func deleteSingleWord() {
        self.playSpaceKeySound(soundID: 1155)
        self.textDocumentProxy.deleteBackward()
    }
    
    @objc func onLongPressOfBackSpaceKey(longGestr: UILongPressGestureRecognizer) {
        
        switch longGestr.state {
        case .began:
            self.textDocumentProxy.deleteBackward()
        case .ended:
            print("Ended")
            return
        default:
            self.textDocumentProxy.deleteBackward()
            //deleteLastWord()
        }
        
    }
    
    @objc func handleTabCase(sender: UIButton) {
        self.textDocumentProxy.insertText("\t")
    }
    
    @objc func handleLanguageCase(sender: UIButton) {
        
    }
    
    @objc func handleHideKeyboardCase(sender: UIButton) {
        dismissKeyboard()
    }
    
    @objc func handleSingleCapitalsAndLowerCase(sender: UIButton) {
        isCapitalsShowing = !isCapitalsShowing
        self.isAllTimeCapitalsShowing = false
        self.playSpaceKeySound(soundID: 1156)
        
        if isCapitalsShowing {
            self.addCapitalKeyboardButtons()
        } else {
            for view in mainStackView.arrangedSubviews {
                view.removeFromSuperview()
            }
            self.addKeyboardButtons()
        }
        let colorScheme = returnColorSheme()
        let themeColor = KBColors(colorScheme: colorScheme)
        if !IS_IPAD {
            self.capButton.setImage(UIImage(systemName: !isCapitalsShowing ? "shift" : "shift.fill"), for: .normal)
            self.capButton.tintColor = themeColor.buttonTextColor
        } else if self.iPadKeyBoardType == .iPadMini {
            self.iPadCap1Button.setImage(UIImage(systemName: !isCapitalsShowing ? "shift" : "shift.fill"), for: .normal)
            self.iPadCap2Button.setImage(UIImage(systemName: !isCapitalsShowing ? "shift" : "shift.fill"), for: .normal)
        }
        
    }
    
    @objc func handleDoubleCapitalsAndLowerCase(sender: UIButton) {
        self.playSpaceKeySound(soundID: 1156)
        for view in mainStackView.arrangedSubviews {
            view.removeFromSuperview()
        }
        
        self.isCapitalsShowing = true
        self.isAllTimeCapitalsShowing = true
        self.addCapitalKeyboardButtons()
        let colorScheme = returnColorSheme()
        let themeColor = KBColors(colorScheme: colorScheme)
        if IS_IPAD {
            if self.iPadKeyBoardType == .iPadMini {
               self.iPadCap1Button.setImage(UIImage(systemName: "capslock.fill"), for: .normal)
               self.iPadCap2Button.setImage(UIImage(systemName: "capslock.fill"), for: .normal)
            } else {
                self.iPadCap1Button.setTitle("caps lock", for: .normal)
                self.iPadCap2Button.setTitle("caps lock", for: .normal)
            }
            self.iPadCap1Button.tintColor = themeColor.buttonTextColor
            self.iPadCap2Button.tintColor = themeColor.buttonTextColor
        } else {
            self.capButton.setImage(UIImage(systemName: "capslock.fill"), for: .normal)
            self.capButton.tintColor = themeColor.buttonTextColor
        }
    }
    
    @objc func handleSpacialChars(sender: UIButton) {
        areSpacialCharShowing = !areSpacialCharShowing
        self.playSpaceKeySound(soundID: 1156)
    }
    
    @objc func handleSwitchingNumericsAndLetters(sender: UIButton) {
        isCapitalsShowing = false
        areSpacialCharShowing = false
        areLettersShowing = !areLettersShowing
        self.playSpaceKeySound(soundID: 1156)
        print("Switching To and From Numeric and Alphabets")
    }
    
    @objc func insertWhiteSpace() {
        attemptToReplaceCurrentWord()
        let proxy = self.textDocumentProxy
        proxy.insertText(" ")
        self.playSpaceKeySound(soundID: 1156)
        print("white space")
    }
    
    @objc func handleReturnKey(sender: UIButton) {
//        if let _ = self.textDocumentProxy.documentContextBeforeInput {
             self.textDocumentProxy.insertText("\n")
//        }
       
       // print("Return Type is handled here...")
    }
    
    
    @objc func manualAction(sender: UIButton) {
        let proxy = self.textDocumentProxy
        proxy.deleteBackward()
        self.playSpaceKeySound(soundID: 1155)
        print("Else Case... Remaining Keys")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func showNumberPad() {
        
        for view in mainStackView.arrangedSubviews {
            view.removeFromSuperview()
        }
        let firstRow = [".","0"]
        let secRow = ["1","2","3"]
        let thirdRow = ["4","5","6"]
        let fourthRow = ["7","8","9"]
        self.deleteButton = accessoryButtons(title: nil, img: #imageLiteral(resourceName: "backspace"), tag: 2)
        let first = addRowsOnKeyboard(kbKeys: firstRow)
        let second = addRowsOnKeyboard(kbKeys: secRow)
        let third = addRowsOnKeyboard(kbKeys: thirdRow)
        let fourth = addRowsOnKeyboard(kbKeys: fourthRow)
        let fsv = UIStackView(arrangedSubviews: [first, deleteButton])
        fsv.alignment = .fill
        fsv.distribution = .fill
        fsv.spacing = 5
        deleteButton.widthAnchor.constraint(equalTo: fsv.widthAnchor, multiplier: 1.0/3.0, constant: -5.0).isActive = true
        mainStackView.addArrangedSubview(fourth)
        mainStackView.addArrangedSubview(third)
        mainStackView.addArrangedSubview(second)
        mainStackView.addArrangedSubview(fsv)
        
        self.setColor()
        
    }
    
    func displayNumericKeys() {
        for view in mainStackView.arrangedSubviews {
            view.removeFromSuperview()
        }
        if IS_IPAD {
            if iPadKeyBoardType == .iPadPro {
                
                let numericRowKeysView = addRowsOnKeyboard(kbKeys: ["`", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "<", ">"])
                let numericRowView = numericRowServeiceKeysForiPad(midRow: numericRowKeysView)
                
                let firstRowKeysView = addRowsOnKeyboard(kbKeys: ["[", "]", "{", "}", "#", "%", "^", "*", "+", "=", "\\", "|", "~"])
                let firstRowView = firstRowServeiceKeysForiPad(midRow: firstRowKeysView)
                
                let secondRowKeysView = addRowsOnKeyboard(kbKeys: ["-", "/", ":", ";", "(", ")", "€", "&", "@", "£", "€"])
                let secondRowView = secondRowServeiceKeysForiPad(midRow: secondRowKeysView)
                
                let thirdRowkeysView = addRowsOnKeyboard(kbKeys: ["…", ".", ",", "?", "!", "'", "\"", "_", "$"])
                let (thirdRowSV,fourthRowSV) = serveiceKeysForiPad(midRow: thirdRowkeysView)
                mainStackView.addArrangedSubview(numericRowView)
                mainStackView.addArrangedSubview(firstRowView)
                mainStackView.addArrangedSubview(secondRowView)
                mainStackView.addArrangedSubview(thirdRowSV)
                mainStackView.addArrangedSubview(fourthRowSV)
               
            } else {
                let numsKeysView = addRowsOnKeyboard(kbKeys: ["1","2","3","4","5","6","7","8","9","0"])
                let nums = firstRowServeiceKeysForiPad(midRow: numsKeysView)
                
                let secondRowKeysView = addRowsOnKeyboard(kbKeys: ["@", "#", "$", "&", "*", "(", ")", "'", "\""])
                let secondRowView = secondRowServeiceKeysForiPad(midRow: secondRowKeysView)
                
                let thirdRowkeysView = addRowsOnKeyboard(kbKeys: ["%", "-", "+", "=", "/", ";", ":", ",", "."])
                let (thirdRowSV,fourthRowSV) = serveiceKeysForiPad(midRow: thirdRowkeysView)
                mainStackView.addArrangedSubview(nums)
                mainStackView.addArrangedSubview(secondRowView)
                mainStackView.addArrangedSubview(thirdRowSV)
                mainStackView.addArrangedSubview(fourthRowSV)
            }
        } else {
            let nums = ["1","2","3","4","5","6","7","8","9","0"]
            let splChars1 = ["-","/",":",";","(",")","$","&","@","\""]
            let splChars2 = [".",",","?","!","'"]
            let numsRow = self.addRowsOnKeyboard(kbKeys: nums)
            let splChars1Row = self.addRowsOnKeyboard(kbKeys: splChars1)
            let splChars2Row = self.addRowsOnKeyboard(kbKeys: splChars2)
            let (thirdRowSV,fourthRowSV) = serveiceKeys(midRow: splChars2Row)
            mainStackView.addArrangedSubview(numsRow)
            mainStackView.addArrangedSubview(splChars1Row)
            mainStackView.addArrangedSubview(thirdRowSV)
            mainStackView.addArrangedSubview(fourthRowSV)
        }
        
        self.setNextKeyboardVisible(needsInputModeSwitchKey)
        self.setColor()
        
    }
    
    
    func displaySpacialCharKeys() {
        for view in mainStackView.arrangedSubviews {
            view.removeFromSuperview()
        }
        if IS_IPAD {
            
                let numsKeysView = addRowsOnKeyboard(kbKeys: ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"])
                let nums = firstRowServeiceKeysForiPad(midRow: numsKeysView)
                
                let secondRowKeysView = addRowsOnKeyboard(kbKeys: ["$", "£", "€", "_", "^", "[", "]", "{", "}"])
                let secondRowView = secondRowServeiceKeysForiPad(midRow: secondRowKeysView)
                
                let thirdRowkeysView = addRowsOnKeyboard(kbKeys: ["§", "|", "~", "...", "\\", "<", ">", "!", "?"])
                let (thirdRowSV,fourthRowSV) = serveiceKeysForiPad(midRow: thirdRowkeysView)
                
                mainStackView.addArrangedSubview(nums)
                mainStackView.addArrangedSubview(secondRowView)
                mainStackView.addArrangedSubview(thirdRowSV)
                mainStackView.addArrangedSubview(fourthRowSV)
        } else {
            let splChars = ["[", "]", "{", "}", "#", "%", "^", "*", "+", "="]
            let splChars1 = ["_", "\\", "|", "~", "<", ">", "$", "£", "€", "·"]
            let splChars2 = [".", ",", "?", "!", "'"]

            let splCharsRow = self.addRowsOnKeyboard(kbKeys: splChars)
            let splChars1Row = self.addRowsOnKeyboard(kbKeys: splChars1)
            let splChars2Row = self.addRowsOnKeyboard(kbKeys: splChars2)
            let (thirdRowSV,fourthRowSV) = serveiceKeys(midRow: splChars2Row)
            mainStackView.addArrangedSubview(splCharsRow)
            mainStackView.addArrangedSubview(splChars1Row)
            mainStackView.addArrangedSubview(thirdRowSV)
            mainStackView.addArrangedSubview(fourthRowSV)
        }
        
        self.setNextKeyboardVisible(needsInputModeSwitchKey)
        self.setColor()
    }
    
    private func addKeyboardButtons() {
        if IS_IPAD {
            if iPadKeyBoardType == .iPadPro {
                
                let numericRowKeysView = addRowsOnKeyboard(kbKeys: ["`", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "-", "="])
                let numericRowView = numericRowServeiceKeysForiPad(midRow: numericRowKeysView)
                
                let firstRowKeysView = addRowsOnKeyboard(kbKeys: ["q", "w", "e", "r", "t", "y", "u", "i", "o", "p", "[", "]", "\\"])
                let firstRowView = firstRowServeiceKeysForiPad(midRow: firstRowKeysView)
                
                let secondRowKeysView = addRowsOnKeyboard(kbKeys: ["a", "s", "d", "f", "g", "h", "j", "k", "l", ";", "'"])
                let secondRowView = secondRowServeiceKeysForiPad(midRow: secondRowKeysView)
                
                let thirdRowkeysView = addRowsOnKeyboard(kbKeys: ["z", "x", "c", "v", "b", "n", "m", ",", ".", "/"])
                let (thirdRowSV,fourthRowSV) = serveiceKeysForiPad(midRow: thirdRowkeysView)
                
                self.mainStackView = UIStackView(arrangedSubviews: [numericRowView, firstRowView,secondRowView,thirdRowSV,fourthRowSV])
                mainStackView.axis = .vertical
                mainStackView.spacing = 0 //7.0
                mainStackView.distribution = .fillEqually
                mainStackView.alignment = .fill
                mainStackView.translatesAutoresizingMaskIntoConstraints = false
                view.addSubview(mainStackView)
                

                
                mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
                mainStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10).isActive = true
                mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
                //        mainStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
                mainStackView.heightAnchor.constraint(equalToConstant: keyboardHeight).isActive = true
            } else {
                let firstRowKeysView = addRowsOnKeyboard(kbKeys: ["q", "w", "e", "r", "t", "y", "u", "i", "o", "p"])
                let firstRowView = firstRowServeiceKeysForiPad(midRow: firstRowKeysView)
                
                let secondRowKeysView = addRowsOnKeyboard(kbKeys: ["a", "s", "d", "f", "g", "h", "j", "k", "l"])
                let secondRowView = secondRowServeiceKeysForiPad(midRow: secondRowKeysView)

                let thirdRowkeysView = addRowsOnKeyboard(kbKeys: ["z", "x", "c", "v", "b", "n", "m", ",", "."])
                let (thirdRowSV,fourthRowSV) = serveiceKeysForiPad(midRow: thirdRowkeysView)
                self.mainStackView = UIStackView(arrangedSubviews: [firstRowView,secondRowView,thirdRowSV,fourthRowSV])
                mainStackView.axis = .vertical
                mainStackView.spacing = 0 //10
                mainStackView.distribution = .fillEqually
                mainStackView.alignment = .fill
                mainStackView.translatesAutoresizingMaskIntoConstraints = false
                view.addSubview(mainStackView)

                mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
                mainStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10).isActive = true
                mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        //        mainStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
                mainStackView.heightAnchor.constraint(equalToConstant: keyboardHeight).isActive = true
            }
            
            self.setNextKeyboardVisible(needsInputModeSwitchKey)
            self.setColor()
            
        } else {
            let firstRowView = addRowsOnKeyboard(kbKeys: ["q","w","e","r","t","y","u","i","o","p"])
            let secondRowView = addRowsOnKeyboard(kbKeys: ["a","s","d","f","g","h","j","k","l"])
            let thirdRowkeysView = addRowsOnKeyboard(kbKeys: ["z","x","c","v","b","n","m"])
            let (thirdRowSV,fourthRowSV) = serveiceKeys(midRow: thirdRowkeysView)
    //        firstRowView.heightAnchor.constraint(equalToConstant: 50).isActive = true
            self.mainStackView = UIStackView(arrangedSubviews: [firstRowView,secondRowView,thirdRowSV,fourthRowSV])
            mainStackView.axis = .vertical
            mainStackView.spacing = 0 //10
            mainStackView.distribution = .fillEqually
            mainStackView.alignment = .fill
            mainStackView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(mainStackView)

            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 2).isActive = true
            mainStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -2).isActive = true
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -2).isActive = true
    //        mainStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
            mainStackView.heightAnchor.constraint(equalToConstant: keyboardHeight).isActive = true
            self.setNextKeyboardVisible(needsInputModeSwitchKey)
            self.setColor()
        }

    }
    
    private func addCapitalKeyboardButtons() {
        for view in mainStackView.arrangedSubviews {
            view.removeFromSuperview()
        }
        if IS_IPAD {
            if iPadKeyBoardType == .iPadPro {
                
                let numericRowKeysView = addRowsOnKeyboard(kbKeys: ["~", "!", "@", "#", "$", "%", "^", "&", "*", "(", ")", "_", "+"])
                let numericRowView = numericRowServeiceKeysForiPad(midRow: numericRowKeysView)
                
                let firstRowKeysView = addRowsOnKeyboard(kbKeys: ["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P", "{", "}", "|"])
                let firstRowView = firstRowServeiceKeysForiPad(midRow: firstRowKeysView)
                
                let secondRowKeysView = addRowsOnKeyboard(kbKeys: ["A", "S", "D", "F", "G", "H", "J", "K", "L", ":", "\""])
                let secondRowView = secondRowServeiceKeysForiPad(midRow: secondRowKeysView)
                
                let thirdRowkeysView = addRowsOnKeyboard(kbKeys: ["Z", "X", "C", "V", "B", "N", "M", "<", ">", "?"])
                let (thirdRowSV,fourthRowSV) = serveiceKeysForiPad(midRow: thirdRowkeysView)
                mainStackView.addArrangedSubview(numericRowView)
                mainStackView.addArrangedSubview(firstRowView)
                mainStackView.addArrangedSubview(secondRowView)
                mainStackView.addArrangedSubview(thirdRowSV)
                mainStackView.addArrangedSubview(fourthRowSV)
               
            } else {
                let firstRowKeysView = addRowsOnKeyboard(kbKeys: ["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P"])
                let firstRowView = firstRowServeiceKeysForiPad(midRow: firstRowKeysView)
                let secondRowKeysView = addRowsOnKeyboard(kbKeys: ["A", "S", "D", "F", "G", "H", "J", "K", "L"])
                let secondRowView = secondRowServeiceKeysForiPad(midRow: secondRowKeysView)
                let thirdRowkeysView = addRowsOnKeyboard(kbKeys: ["Z", "X", "C", "V", "B", "N", "M", "!", "?"])
                let (thirdRowSV,fourthRowSV) = serveiceKeysForiPad(midRow: thirdRowkeysView)
                mainStackView.addArrangedSubview(firstRowView)
                mainStackView.addArrangedSubview(secondRowView)
                mainStackView.addArrangedSubview(thirdRowSV)
                mainStackView.addArrangedSubview(fourthRowSV)
            }
        } else {
            let firstRowView = addRowsOnKeyboard(kbKeys: ["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P"])
            let secondRowView = addRowsOnKeyboard(kbKeys: ["A", "S", "D", "F", "G", "H", "J", "K", "L"])
            let thirdRowkeysView = addRowsOnKeyboard(kbKeys: ["Z", "X", "C", "V", "B", "N", "M"])
            let (thirdRowSV,fourthRowSV) = serveiceKeys(midRow: thirdRowkeysView)
            mainStackView.addArrangedSubview(firstRowView)
            mainStackView.addArrangedSubview(secondRowView)
            mainStackView.addArrangedSubview(thirdRowSV)
            mainStackView.addArrangedSubview(fourthRowSV)
        }
        self.setNextKeyboardVisible(needsInputModeSwitchKey)
        self.setColor()
    }
    
}

private extension KeyboardViewController {
    func attemptToReplaceCurrentWord() {
        // 1
        guard let entries = userLexicon?.entries,
            let currentWord = currentWord?.lowercased() else {
                return
        }
        
        // 2
        let replacementEntries = entries.filter {
            $0.userInput.lowercased() == currentWord
        }
        
        if let replacement = replacementEntries.first {
            // 3
            for _ in 0..<currentWord.count {
                textDocumentProxy.deleteBackward()
            }
            
            // 4
            textDocumentProxy.insertText(replacement.documentText)
        }
    }
}
