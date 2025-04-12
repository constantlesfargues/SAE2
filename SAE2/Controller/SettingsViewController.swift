//
//  SettingsViewController.swift
//  SAE2
//
//  Created by etudiant on 08/04/2025.
//

import UIKit

class SettingsViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var UtilisateurPicker: UIPickerView!
    
    @IBOutlet weak var boutonSuprimer: UIButton!
    
    
    public var alertAjout : UIAlertController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UtilisateurPicker.dataSource = self
        UtilisateurPicker.delegate = self
        UtilisateurPicker.reloadAllComponents()
        
        
        // create the actual alert controller view that will be the pop-up
        alertAjout = UIAlertController(title: "Ajouter un utilisateur", message: "Entrez le nom d'utilisateur", preferredStyle: .alert)
        alertAjout.addTextField { (textField) in
            // configure the properties of the text field
            textField.placeholder = "Nom d'utilisateur"
        }
        // add the buttons/actions to the view controller
        let cancelAction = UIAlertAction(title: "Annuler", style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: "Enregistrer", style: .default) { _ in

            // this code runs when the user hits the "save" button

            let inputName = self.alertAjout.textFields![0].text
            if (inputName != nil){
                AppDelegate.users.append(Utilisateur(inputName!))
            }else{
                // affiche erreur
            }
            self.UtilisateurPicker.reloadAllComponents()
        }
        alertAjout.addAction(cancelAction)
        alertAjout.addAction(saveAction)

        if (AppDelegate.users.count == 1){
            boutonSuprimer.isEnabled = false
        }
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
        
    }
    
    @IBAction func tapAjouterUtilisateur(_ sender: Any) {
        present(alertAjout, animated: true, completion: nil)
        if (AppDelegate.users.count > 1){
            boutonSuprimer.isEnabled = true
        }
    }
    
    @IBAction func tapSuprimerUtilisateur(_ sender: Any) {
        let indiceUserSupr : Int = UtilisateurPicker.selectedRow(inComponent: 0)
        
        AppDelegate.users.remove(at: indiceUserSupr)
    
        Utilisateur.ecrireUtilisateur(AppDelegate.users)
        
        UtilisateurPicker.reloadAllComponents()
        
        if (AppDelegate.users.count == 1){
            boutonSuprimer.isEnabled = false
        }
    }
    
    @IBAction func tapAppliquer(_ sender: Any) {
        // écrit les valeurs des champs dans les parametres
        // ( Dans AppDelegate & JSON )
    }
    
    @IBAction func tapAnnuler(_ sender: Any) {
        // remet tout les champs a la valeur actuelement dans les parametres
    }
    
}
