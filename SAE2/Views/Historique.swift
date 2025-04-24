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
                        NavigationLink(destination: Text(flux.enChaine())) {
                            VStack(alignment: .leading) {
                                Text(flux.nomFlux)
                                    .font(.headline)
                                Text("\(flux.montantFlux, specifier: "%.2f") € - \(flux.typeFlux)")
                                    .font(.subheadline)
                            }
                        }
                    }
                    .navigationTitle("Mes Flux")
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) { // ⬅️ Item placé à gauche
                            Button {
                                        isShowingNewScreen = true
                                    } label: {
                                        Text("Filtres")
                                    }
                                    .sheet(isPresented: $isShowingNewScreen) {
                                        Text("Filtres") // ⬅️ Contenu du nouvel écran
                                    }
                                    }
                    }
                }
    }
}

#Preview {
    Historique()
}
