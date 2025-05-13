//
//  KeyboardDismissTapArea.swift
//  SAE2_fusion
//
//  Created by etudiant on 13/05/2025.
//

import SwiftUI

struct KeyboardDismissTapArea: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}
