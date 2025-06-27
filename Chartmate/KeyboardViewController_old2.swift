import UIKit

import KeyboardKit

//class KeyboardViewController: UIInputViewController,  {
//    var nextKeyboardButton: UIButton!
//    var collectionView: UICollectionView!
//    var keyboardStackView: UIStackView!
//    var isEmojiMode = false
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//    }
//
//}

class KeyboardViewController: KeyboardInputViewController {

    override func viewDidLoad() {
        
        /// 💡 Setup a demo-specific action handler.
        ///
        /// The demo handler has custom code for tapping and
        /// long pressing image actions.
        services.actionHandler = DemoActionHandler(
            controller: self,
            keyboardContext: state.keyboardContext,
            keyboardBehavior: services.keyboardBehavior,
            autocompleteContext: state.autocompleteContext,
            feedbackContext: state.feedbackContext,
            spaceDragGestureHandler: services.spaceDragGestureHandler)
        
        /// 💡 Setup a fake autocomplete service.
        ///
        /// The Pro demo uses real, on-device autocompletion.
        services.autocompleteService = FakeAutocompleteService(
            context: state.autocompleteContext
        )
        
        /// 💡 Setup a demo-specific callout action provider.
        ///
        /// The demo provider adds "keyboard" callout action
        /// buttons to the "k" key.
        services.calloutActionProvider = Callouts.StandardActionProvider(
            keyboardContext: state.keyboardContext,
            baseProvider: DemoCalloutActionProvider())
        
        /// 💡 Setup a demo-specific layout provider.
        ///
        /// The demo provider adds a "next locale" button if
        /// needed, as well as a rocket emoji button.
        services.layoutProvider = DemoLayoutProvider()
        
        /// 💡 Setup a demo-specific style provider.
        ///
        /// The demo provider styles the rocket emoji button
        /// and has some commented out code that you can try.
        services.styleProvider = DemoStyleProvider(
            keyboardContext: state.keyboardContext)
        

        /// 💡 Setup a custom keyboard locale.
        ///
        /// Without KeyboardKit Pro, changing locale will by
        /// default only affects localized texts.
        state.keyboardContext.setLocale(.english)

        /// 💡 Add more locales to the keyboard.
        ///
        /// The demo layout provider will add a "next locale"
        /// button if you have more than one locale.
        state.keyboardContext.localePresentationLocale = .current
        state.keyboardContext.locales = [] // KeyboardLocale.all.locales
        
        /// 💡 Setup a custom dictation key replacement.
        ///
        /// Since dictation is not available by default, the
        /// dictation button is removed if we don't set this.
        state.keyboardContext.keyboardDictationReplacement = .character("😀")
        
        /// 💡 Configure the space long press behavior.
        ///
        /// The locale context menu will only open up if the
        /// keyboard has multiple locales.
        state.keyboardContext.spaceLongPressBehavior = .moveInputCursor
        // state.keyboardContext.spaceLongPressBehavior = .openLocaleContextMenu
        
        /// 💡 Setup haptic and audio feedback.
        ///
        /// The code below enables audio and haptic feedback,
        /// then sets up custom audio for the rocket button.
        let feedback = state.feedbackContext
        feedback.audioConfiguration = .enabled
        feedback.hapticConfiguration = .enabled
        feedback.registerCustomFeedback(.haptic(.selection, for: .repeat, on: .rocket))
        feedback.registerCustomFeedback(.audio(.rocketFuse, for: .press, on: .rocket))
        feedback.registerCustomFeedback(.audio(.rocketLaunch, for: .release, on: .rocket))
        
        /// 💡 Call super to perform the base initialization.
        super.viewDidLoad()
    }

    override func viewWillSetupKeyboard() {
        super.viewWillSetupKeyboard()
        setup { [weak self] controller in // <-- Use [weak self] or [unowned self] if you need self here.
            SystemKeyboard(
                state: controller.state,
                services: controller.services,
                buttonContent: { $0.view },
                buttonView: { $0.view },
                emojiKeyboard: { $0.view },
                toolbar: { $0.view }
            )
        }
    }
    
    override class func didChangeValue(forKey key: String, withSetMutation mutationKind: NSKeyValueSetMutationKind, using objects: Set<AnyHashable>) {
        print(key)
    }
}

