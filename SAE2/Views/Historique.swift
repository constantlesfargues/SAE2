//
//  Historique.swift
//  SAE2
//
//  Created by etudiant on 24/04/2025.
//

import SwiftUI

struct Historique: View {
    @ObservedObject var store: FluxStore
    @State private var isShowingNewScreen = false

    var body: some View {
        NavigationStack {
            List {
                Section("Votre historique") {
                    ForEach(store.fluxs) { flux in
                        NavigationLink(destination: Text(flux.enChaine())) {
                            VStack(alignment: .leading) {
                                Text(flux.nomFlux)
                                    .font(.headline)
                                Text("\(flux.montantFlux, specifier: "%.2f") € - \(flux.typeFlux)")
                                    .font(.subheadline)
                            }
                        }
                    }
                    .onDelete(perform: store.supprimerFlux) // 🔥 swipe-to-delete
                }
            }
            .refreshable {
                store.rechargerDepuisJSON()
            }
            .onAppear {
                store.rechargerDepuisJSON()
            }
            .navigationTitle("Historique")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
                ToolbarItem(placement: .topBarTrailing) {
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
    Historique(store: FluxStore())
}
