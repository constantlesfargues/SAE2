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
    @State private var filtreActuel = Filtre()
    @State private var refreshID = UUID()
    
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Solde total")) {
                    Text("\(totalFluxFormatted())")
                        .foregroundColor(totalFlux() >= 0 ? .green : .red)
                        .fontWeight(.bold)
                }
                
                Section("Votre historique") {
                    ForEach(store.fluxs.filter { matchFiltre($0) }) { flux in
                        NavigationLink(destination: DetailFluxView(flux: flux)) {
                            VStack(alignment: .leading) {
                                Text(flux.nomFlux).font(.headline)
                                Text("\(flux.montantFlux, specifier: "%.2f") € - \(flux.typeFlux)").font(.subheadline)
                            }
                        }
                    }.onDelete(perform: store.supprimerFlux)
                }
            }
            .id(refreshID)
            .refreshable { store.rechargerDepuisJSON() }
            .onAppear { store.rechargerDepuisJSON() }
            .navigationTitle("Historique")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Filtrer") {
                        isShowingNewScreen = true
                    }
                    .sheet(isPresented: $isShowingNewScreen, onDismiss: {
                        refreshID = UUID()
                    }) {
                        Filtres(filtre: $filtreActuel)
                    }
                }
            }
        }
    }
    
    func matchFiltre(_ flux: Flux) -> Bool {
        if let type = filtreActuel.type, flux.typeFlux != type { return false }
        if let min = filtreActuel.montantMin, flux.montantFlux < min { return false }
        if let max = filtreActuel.montantMax, flux.montantFlux > max { return false }
        if let minDate = filtreActuel.dateMin, flux.dateFlux < minDate { return false }
        if let maxDate = filtreActuel.dateMax, flux.dateFlux > maxDate { return false }
        return true
    }
    
    func totalFlux() -> Float {
        store.fluxs.reduce(0) { total, flux in
            flux.typeFlux == "entree" ? total + flux.montantFlux : total - flux.montantFlux
        }
    }
    
    func totalFluxFormatted() -> String {
        let montant = totalFlux()
        return String(format: "%.2f €", montant)
    }
}

#Preview {
    Historique(store: FluxStore())
}
