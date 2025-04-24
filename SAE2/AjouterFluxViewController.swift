//
//  AjouterFluxViewController.swift
//  SAE2
//
//  Created by etudiant on 22/04/2025.
//

import UIKit

class AjouterFluxViewController: UIViewController {
    
    
    @IBOutlet weak var typeFluxSC: UISegmentedControl!
    @IBOutlet weak var nomFluxTF: UITextField!
    @IBOutlet weak var dateFluxDP: UIDatePicker!
    @IBOutlet weak var montantFluxTF: UITextField!
    
    @IBOutlet weak var testLB: UILabel!
    
    @IBAction func tapSurAnnuler(_ sender: Any) {
        nomFluxTF.text = ""
        montantFluxTF.text = ""
        typeFluxSC.selectedSegmentIndex = 0
        dateFluxDP.date = Date()
    }
    
    @IBAction func tapSurAjouter(_ sender: Any) {
        var leType : String
        var leNom : String
        var laDate : Date
        var leMontant : Float
        var lesGroupes : [Groupe]
        var laFreq : Int
        var laDuree : Int
        
        if typeFluxSC.selectedSegmentIndex == 0{
            leType = "entree"
        }else{
            leType = "sortie"
        }
        leNom = nomFluxTF.text!
        if let montant = Float(montantFluxTF.text!) {
            leMontant = montant
        }else {
            return
        }
        leMontant = abs(Float(montantFluxTF.text!)!)
        laDate = dateFluxDP.date
        
        testLB.text = "Type : \(leType) \n Nom : \(leNom) \n Date : \(laDate) \n Montant : \(leMontant)"
        
        var leNouveauFlux : Flux
        leNouveauFlux = Flux(leNom, leMontant, leType, laDate, lesGroupes, laFreq, laDuree)
        
        
    }
    
    @IBAction func tapSurRetour(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
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
