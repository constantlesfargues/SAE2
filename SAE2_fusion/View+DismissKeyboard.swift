//
//  View+DismissKeyboard.swift
//  SAE2_fusion
//
//  Created by etudiant on 13/05/2025.
//

import SwiftUI

extension View {
    func dismissKeyboardOnTap() -> some View {
        self.onTapGesture {
            UIApplication.shared.sendAction(
                #selector(UIResponder.resignFirstResponder),
                to: nil, from: nil, for: nil
            )
        }
    }
}
