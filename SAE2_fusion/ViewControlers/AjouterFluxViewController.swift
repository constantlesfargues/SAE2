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
    @IBOutlet weak var laFrequenceSC: UISegmentedControl!
    @IBOutlet weak var estRecurrSC: UISegmentedControl!
    @IBOutlet weak var validationLB: UILabel!
    
    @IBAction func tapSurAnnuler(_ sender: Any) {
        nomFluxTF.text = ""
        montantFluxTF.text = ""
        typeFluxSC.selectedSegmentIndex = 0
        dateFluxDP.date = Date()
        laFrequenceSC.selectedSegmentIndex = 0
        estRecurrSC.selectedSegmentIndex = 0
    }
    
    @IBAction func tapSurAjouter(_ sender: Any) {
        var leType : String
        var leNom : String
        var laDate : Date
        var leMontant : Float
        var lesGroupes : [Groupe] = [Groupe("Restaurant")]
        var laFreq : Int = 0
        var laDuree : Int = 0
        
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
        let laFreqRecup : Int =
        laFrequenceSC.selectedSegmentIndex
        if estRecurrSC.selectedSegmentIndex == 1{
            if laFreqRecup == 0{
                laFreq = 1
            }
            else if laFreqRecup == 1{
                laFreq = 7
            }
            else if laFreqRecup == 2{
                laFreq = 30
            }
            else if laFreqRecup == 3{
                laFreq = 365
            }
        }
        else{
        }
        
        var leNouveauFlux : Flux
        leNouveauFlux = Flux(nomFlux : leNom, montantFlux : leMontant, typeFlux: leType, dateFlux: laDate, groupesFlux : lesGroupes, frequenceFlux : laFreq, dureeFlux : laDuree)
        AppDelegate.fluxs.append(leNouveauFlux)
        AppDelegate.actualiserJSON()
        validationLB.text="Le flux a bien été ajouté!"
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
