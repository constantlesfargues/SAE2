//
//  UIApplication+Keyboard.swift
//  SAE2_fusion
//
//  Created by etudiant on 13/05/2025.
//

import SwiftUI

extension UIApplication {
    func dismissKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
