//
//  FluxStore.swift
//  SAE2
//
//  Created by etudiant on 07/05/2025.
//


import Foundation

class FluxStore: ObservableObject {
    @Published var fluxs: [Flux] = []

    init() {
        self.fluxs = AppDelegate.fluxs
    }

    func ajouterFlux(_ flux: Flux) {
        AppDelegate.fluxs.append(flux)
        AppDelegate.actualiserJSON()
        rechargerDepuisJSON()
    }

    func supprimerFlux(at offsets: IndexSet) {
        fluxs.remove(atOffsets: offsets)
        AppDelegate.fluxs = fluxs
        AppDelegate.actualiserJSON()
    }

    func rechargerDepuisJSON() {
        if let fluxsLu = Flux.lireFlux(AppDelegate.users[0]) {
            self.fluxs = fluxsLu
            AppDelegate.fluxs = fluxsLu
        }
    }
}
