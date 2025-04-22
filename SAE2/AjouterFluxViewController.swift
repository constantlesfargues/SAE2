//
//  AjouterFluxViewController.swift
//  SAE2
//
//  Created by etudiant on 22/04/2025.
//

import UIKit

class AjouterFluxViewController: UIViewController {
    
    
    @IBOutlet weak var typeFluxSC: UISegmentedControl!
    @IBOutlet weak var titreFluxTF: UITextField!
    @IBOutlet weak var dateFluxDP: UIDatePicker!
    
    
    
    @IBAction func tapSurAnnuler(_ sender: Any) {
    }
    
    @IBAction func tapSurAjouter(_ sender: Any) {
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
