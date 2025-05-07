//
//  FluxViewController.swift
//  SAE2
//
//  Created by etudiant on 03/04/2025.
//

import UIKit

class FluxViewController:  UITableViewController {

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "afficheCreerFlux"){
            let leSecondControler = segue.destination as! AjouterFluxViewController
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    
    @IBAction func tapSurAjouter(_ sender: Any) {
        performSegue(withIdentifier: "afficheCreerFlux", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }
    

    
    // MARK: - Navigation

    //In a storyboard-based application, you will often want to do a little preparation before navigation
    

}
