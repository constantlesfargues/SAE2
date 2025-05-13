//
//  SettingsViewController.swift
//  SAE2
//
//  Created by etudiant on 08/04/2025.
//

import UIKit

class SettingsViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    // roue de sélection de l'utilisateur
    @IBOutlet weak var UtilisateurPicker: UIPickerView!
    // Outlet pour désactiver le bouton suprimer
    @IBOutlet weak var boutonSuprimer: UIButton!
    
    
    // switch du mode sombre
    @IBOutlet weak var modeSombre: UISwitch!

    // pop up lors de l'ajout d'un Utilisateur
    public var alertAjout : UIAlertController!
    // pop up de la supression d'un Utilisateur
    public var alertSupr : UIAlertController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup la roue des Utilisateurs
        UtilisateurPicker.dataSource = self
        UtilisateurPicker.delegate = self
        UtilisateurPicker.reloadAllComponents()// actualise l'affichage des Utilisateurs
        
        // met tout les champs des parametres a la valeur actuele des parametres
        resetInputParam()
        
        // Empeche la supréssion d'Utilisateur si il n'y en a qu'un
        if (AppDelegate.users.count <= 1){
            boutonSuprimer.isEnabled = false
        }
        
        
        /*
         Pop up d'ajout d'Utilisateur
         */
        // Setup de la popup d'ajout d'Utilisateur :
        alertAjout = UIAlertController(title: "Ajouter un utilisateur", message: "Entrez le nom d'utilisateur", preferredStyle: .alert)
        alertAjout.addTextField { (textField) in
            textField.placeholder = "Nom d'utilisateur"
        }
        // Ajout des boutons de la pop up
        let cancelAction = UIAlertAction(title: "Annuler", style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: "Enregistrer", style: .default) { _ in

            // récupere le nom entré dans la pop up
            let inputName = self.alertAjout.textFields![0].text
            
            self.alertAjout.textFields?.first?.text = ""
            
            // Si un nom est bien entré
            if ( Utilisateur.nomPossible(AppDelegate.users, inputName) ){
                AppDelegate.users.append(Utilisateur(inputName!))
                Utilisateur.ecrireUtilisateur(AppDelegate.users)
                Parametres.ecrireParam(AppDelegate.users.last!, Parametres() )
            }else{
                print("ERREUR : le nom d'utilisateur est deja utilisé")
            }
            self.UtilisateurPicker.reloadAllComponents()// actualise l'affichage des Utilisateurs
            
            if (AppDelegate.users.count > 1){ // Active le bouton suprimmer si il y a assez d'utilisateurs
                self.boutonSuprimer.isEnabled = true
            }
        }
        alertAjout.addAction(cancelAction)
        alertAjout.addAction(saveAction)
        
        
        /*
         Pop up de supréssion d'Utilisateur
         */
        // Setup de la popup d'ajout d'Utilisateur :
        alertSupr = UIAlertController(title: "Suprimer un utilisateur", message: "Voulez vous vraiment suprimer l'utilisateur", preferredStyle: .alert)
        // Ajout des boutons de la pop up
        let cancelActionSupr = UIAlertAction(title: "Annuler", style: .cancel, handler: nil)
        let saveActionSupr = UIAlertAction(title: "Suprimer", style: .default) { _ in
            
            let indiceUserSupr : Int = self.UtilisateurPicker.selectedRow(inComponent: 0)// récupere l'indice de l'Utilisateur Actuel
            
            Flux.ecrireFlux(AppDelegate.users[indiceUserSupr], [])
            Parametres.ecrireParam(AppDelegate.users[indiceUserSupr], Parametres(isNull:true) )
            
            AppDelegate.users.remove(at: indiceUserSupr)// suprime l'utilisateur d'indice sélectioné
        
            Utilisateur.ecrireUtilisateur(AppDelegate.users)// actualise le JSON avec les utilisateurs actuels
            
            self.UtilisateurPicker.reloadAllComponents()// actualise l'affichage des Utilisateurs
            
            AppDelegate.changeUtilisateur(0)
            SceneDelegate.actualiserModeCouleur()
            self.resetInputParam()
            
            // Empeche la supréssion d'Utilisateur si il n'y en a qu'un
            if (AppDelegate.users.count <= 1){
                self.boutonSuprimer.isEnabled = false
            }
        }
        alertSupr.addAction(cancelActionSupr)
        alertSupr.addAction(saveActionSupr)
        
        SceneDelegate.actualiserModeCouleur() // a metre dans chaque viewDidLoad au cas ou
    }
    
    // requis pour controler la roue d'affichage des Utilisateurs
    // nombre de composants de la roue
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    // nombre de choix dans la roue
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return AppDelegate.users.count
    }
    // texte du choix d'indice "row" dans la roue
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return AppDelegate.users[row].nomUtilisateur
    }
    
    
    // Appuis sur le bouton "Sélectioner" (un Utilisateur)
    @IBAction func tapSelectioner(_ sender: Any) {
        // récup l'utilisateur sélectioné
        let indiceNouvUser : Int = UtilisateurPicker.selectedRow(inComponent: 0)
        // change l'utilisateur
        AppDelegate.changeUtilisateur(indiceNouvUser)
        
        resetInputParam()
        
        UtilisateurPicker.selectRow(0, inComponent: 0, animated: true)
        
        UtilisateurPicker.reloadAllComponents()// actualise l'affichage des Utilisateurs
        
        SceneDelegate.actualiserModeCouleur()
    }
    
    // Appuis sur le bouton "Ajouter" (un Utilisateur)
    @IBAction func tapAjouterUtilisateur(_ sender: Any) {
        present(alertAjout, animated: true, completion: nil)// appelle la pop up d'ajout d'Utilisateur
    }
    
    // Appuis sur le bouton "Suprimer" (un Utilisateur)
    @IBAction func tapSuprimerUtilisateur(_ sender: Any) {
        present(alertSupr, animated: true, completion: nil)// appelle la pop up d'ajout d'Utilisateur
    }
    
    // Appuis sur le bouton "Appliquer" (les parametres)
    @IBAction func tapAppliquer(_ sender: Any) {
        // écrit les valeurs des champs dans les parametres
        AppDelegate.param.modeSombre = modeSombre.isOn
        
        // actualise le JSON
        Parametres.ecrireParam(AppDelegate.users[0], AppDelegate.param)
        SceneDelegate.actualiserModeCouleur()
    }
    
    // Appuis sur le bouton "Annuler"
    @IBAction func tapAnnuler(_ sender: Any) {
        // remet tout les champs a la valeur actuelement dans les parametres
        resetInputParam()
    }
    
    // met tout les champs des parametres a la valeur actuele des parametres
    public func resetInputParam(){
        modeSombre.setOn(AppDelegate.param.modeSombre!, animated: true)
    }
    
}
