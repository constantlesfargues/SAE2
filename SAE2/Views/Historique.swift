//
//  Historique.swift
//  SAE2
//
//  Created by etudiant on 24/04/2025.
//

import SwiftUI

struct Historique: View {
    
    @State var isShowingNewScreen = false
    
    var body: some View {
        NavigationStack {
            List(AppDelegate.fluxs) { flux in
                Section("Votre historique") {
                    NavigationLink(destination: Text(flux.enChaine())) {
                        VStack(alignment: .leading) {
                            Text(flux.nomFlux)
                                .font(.headline)
                            Text("\(flux.montantFlux, specifier: "%.2f") € - \(flux.typeFlux)")
                                .font(.subheadline)
                        }
                    }
                }
                Section("Test1") {
                    Text("Test")
                }
            }
            .navigationTitle("Historique")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        isShowingNewScreen = true
                    } label: {
                        Text("Filtrer la sélection")
                    }
                    .sheet(isPresented: $isShowingNewScreen) {
                        Filtres()
                    }
                }
            }
        }
    }
}

#Preview {
    Historique()
}
