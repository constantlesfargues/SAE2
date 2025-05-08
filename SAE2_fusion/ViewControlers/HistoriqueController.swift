//
//  HistoriqueController.swift
//  SAE2
//
//  Created by etudiant on 24/04/2025.
//

import UIKit
import SwiftUI

class HistoriqueController: UIViewController {
    
    let fluxStore = FluxStore()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        SceneDelegate.actualiserModeCouleur() // a metre dans chaque viewDidLoad au cas ou

        // Do any additional setup after loading the view.
        let controller = UIHostingController(rootView: Historique(store: fluxStore))
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        self.view.addSubview(controller.view)
        controller.didMove(toParent: self)
        
        NSLayoutConstraint.activate([
            controller.view.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            controller.view.heightAnchor.constraint(equalTo: self.view.heightAnchor),
            controller.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            controller.view.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
