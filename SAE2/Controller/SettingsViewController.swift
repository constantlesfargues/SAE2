//
//  SettingsViewController.swift
//  SAE2
//
//  Created by etudiant on 08/04/2025.
//

import UIKit

class SettingsViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var UtilisateurPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UtilisateurPicker.dataSource = self
        UtilisateurPicker.delegate = self
        UtilisateurPicker.reloadAllComponents()
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return AppDelegate.users.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return AppDelegate.users[row].nomUtilisateur
    }
    
    
    @IBAction func tapSelectioner(_ sender: Any) {
        // récup l'utilisateur sélectioné
        let indiceNouvUser : Int = UtilisateurPicker.selectedRow(inComponent: 0)
        // change l'utilisateur
        AppDelegate.changeUtilisateur(indiceNouvUser)
        // update toutes les données dans AppDelegate
    }
    

    @IBAction func tapAppliquer(_ sender: Any) {
        // écrit les valeurs des champs dans les parametres
        // ( Dans AppDelegate & JSON )
    }
    
    @IBAction func tapAnnuler(_ sender: Any) {
        // remet tout les champs a la valeur actuelement dans les parametres
    }
    
}
