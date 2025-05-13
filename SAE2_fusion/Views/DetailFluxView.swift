//
//  DetailFluxView.swift
//  SAE2_fusion
//
//  Created by etudiant on 13/05/2025.
//


import SwiftUI

struct DetailFluxView: View {
    let flux: Flux

    var body: some View {
        Form {
            Section(header: Text("Nom")) {
                Text(flux.nomFlux)
            }
            Section(header: Text("Montant")) {
                Text("\(flux.montantFlux, specifier: "%.2f") €")
            }
            Section(header: Text("Type")) {
                Text(flux.typeFlux.capitalized)
            }
            Section(header: Text("Date")) {
                Text(dateFormatter.string(from: flux.dateFlux))
            }
            Section(header: Text("Groupes")) {
                Text("Nombre de groupes : \(flux.groupesFlux.count)")
                ForEach(flux.groupesFlux) { groupe in
                    Text(groupe.nomGroupe)
                }
            }
            if flux.frequenceFlux > 0 {
                Section(header: Text("Récurrence")) {
                    Text("Tous les \(flux.frequenceFlux) jours")
                }
            }
        }.navigationTitle("Détail")
    }

    var dateFormatter: DateFormatter {
        let df = DateFormatter()
        df.dateStyle = .medium
        return df
    }
}
