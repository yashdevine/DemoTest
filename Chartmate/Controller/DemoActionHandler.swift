//
//  DemoActionHandler.swift
//  Chartmate
//
//  Created by Mac User on 01/07/24.
//

//import KeyboardKit
import UIKit

/// This action handler inherits the standard one, and makes
/// demo-specific adjustments to the standard handling.
///
/// You can play around with the class and customize it more,
/// to see how it affects the demo keyboard.
///
/// The ``KeyboardViewController`` shows how you can replace
/// the standard handler with this custom one.
//class DemoActionHandler: KeyboardAction.StandardHandler {
//
//
//    // MARK: - Overrides
//    
//    override func action(
//        for gesture: Gestures.KeyboardGesture,
//        on action: KeyboardAction
//    ) -> KeyboardAction.GestureAction? {
//        let standard = super.action(for: gesture, on: action)
//        switch gesture {
//        case .longPress: return longPressAction(for: action) ?? standard
//        case .release: return releaseAction(for: action) ?? standard
//        default: return standard
//        }
//    }
//    
//    
//    // MARK: - Custom actions
//    
//    func longPressAction(
//        for action: KeyboardAction
//    ) -> KeyboardAction.GestureAction? {
//        switch action {
//        case .image(_, _, let imageName): { [weak self] _ in self?.saveImage(named: imageName) }
//        default: nil
//        }
//    }
//    
//    func releaseAction(
//        for action: KeyboardAction
//    ) -> KeyboardAction.GestureAction? {
//        switch action {
//        case .image(_, _, let imageName): { [weak self] _ in self?.copyImage(named: imageName) }
//        default: nil
//        }
//    }
//    
//    
//    // MARK: - Functions
//    
//    func alert(_ message: String) {
//        print("Implement alert functionality if you want.")
//    }
//    
//    func copyImage(named imageName: String) {
//        guard let image = UIImage(named: imageName) else { return }
//        guard keyboardContext.hasFullAccess else { return alert("You must enable full access to copy images.") }
//        guard image.copyToPasteboard() else { return alert("The image could not be copied.") }
//        alert("Copied to pasteboard!")
//    }
//    
//    func saveImage(named imageName: String) {
//        guard let image = UIImage(named: imageName) else { return }
//        guard keyboardContext.hasFullAccess else { return alert("You must enable full access to save images.") }
//        image.saveToPhotos(completion: handleImageDidSave)
//        alert("Saved to photos!")
//    }
//}
//
//private extension DemoActionHandler {
//    
//    func handleImageDidSave(withError error: Error?) {
//        if error == nil { alert("Saved!") }
//        else { alert("Failed!") }
//    }
//}
//
//private extension UIImage {
//    
//    func copyToPasteboard(_ pasteboard: UIPasteboard = .general) -> Bool {
//        guard let data = pngData() else { return false }
//        pasteboard.setData(data, forPasteboardType: "public.png")
//        return true
//    }
//}
//
//private extension UIImage {
//    
//    func saveToPhotos(completion: @escaping (Error?) -> Void) {
//        ImageService.default.saveImageToPhotos(self, completion: completion)
//    }
//}
//
//
///// This class is used as target by the extension above.
//private class ImageService: NSObject {
//    
//    public typealias Completion = (Error?) -> Void
//
//    public static private(set) var `default` = ImageService()
//    
//    private var completions = [Completion]()
//    
//    public func saveImageToPhotos(_ image: UIImage, completion: @escaping (Error?) -> Void) {
//        completions.append(completion)
//        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveImageToPhotosDidComplete), nil)
//    }
//    
//    @objc func saveImageToPhotosDidComplete(_ image: UIImage, error: NSError?, contextInfo: UnsafeRawPointer) {
//        guard completions.count > 0 else { return }
//        completions.removeFirst()(error)
//    }
//}
