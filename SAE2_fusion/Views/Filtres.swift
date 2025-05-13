//
//  Filtres.swift
//  SAE2
//
//  Created by etudiant on 24/04/2025.
//

import SwiftUI
import Foundation

struct Filtre {
    var type: String? = nil
    var montantMin: Float? = nil
    var montantMax: Float? = nil
    var dateMin: Date? = nil
    var dateMax: Date? = nil
}

extension Binding {
    init(_ source: Binding<Value?>, replacingNilWith defaultValue: Value) {
        self.init(
            get: { source.wrappedValue ?? defaultValue },
            set: { source.wrappedValue = $0 }
        )
    }
}

struct Filtres: View {
    @Binding var filtre: Filtre
    @Environment(\.dismiss) var dismiss
    
    @State private var typeSelection = 0
    @State private var montantMin: String = ""
    @State private var montantMax: String = ""
    @State private var dateMin: Date? = nil
    @State private var dateMax: Date? = nil
    
    var body: some View {
        ZStack {
            KeyboardDismissTapArea()
            NavigationStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Type")
                            .font(.headline)
                        
                        Picker("Type", selection: $typeSelection) {
                            Text("Tous").tag(0)
                            Text("Entrée").tag(1)
                            Text("Sortie").tag(2)
                        }
                        .pickerStyle(.segmented)
                        
                        Text("Montant")
                            .font(.headline)
                        
                        TextField("Montant minimum", text: $montantMin)
                            .keyboardType(.decimalPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        TextField("Montant maximum", text: $montantMax)
                            .keyboardType(.decimalPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Text("Dates")
                            .font(.headline)
                        
                        Toggle("Filtrer par date", isOn: Binding(
                            get: { dateMin != nil && dateMax != nil },
                            set: { active in
                                if active {
                                    dateMin = Date()
                                    dateMax = Date()
                                } else {
                                    dateMin = nil
                                    dateMax = nil
                                }
                            }
                        ))
                        
                        if dateMin != nil && dateMax != nil {
                            DatePicker("De", selection: Binding($dateMin, replacingNilWith: Date()), displayedComponents: .date)
                            DatePicker("À", selection: Binding($dateMax, replacingNilWith: Date()), displayedComponents: .date)
                        }
                        
                        Divider().padding(.vertical)
                        
                        Button("Appliquer le filtre") {
                            var newFiltre = Filtre()
                            if typeSelection == 1 { newFiltre.type = "entree" }
                            else if typeSelection == 2 { newFiltre.type = "sortie" }
                            if let min = Float(montantMin) { newFiltre.montantMin = min }
                            if let max = Float(montantMax) { newFiltre.montantMax = max }
                            newFiltre.dateMin = dateMin
                            newFiltre.dateMax = dateMax
                            filtre = newFiltre
                            dismiss()
                        }
                        .buttonStyle(.borderedProminent)
                        .frame(maxWidth: .infinity)
                        
                        Button("Réinitialiser") {
                            filtre = Filtre()
                            dismiss()
                        }
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity)
                        
                    }
                    .padding()
                }
                .navigationTitle("Filtres")
            }
        }
    }
}
