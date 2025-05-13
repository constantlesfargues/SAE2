//
//  AjouterFluxViewController.swift
//  SAE2
//
//  Created by etudiant on 22/04/2025.
//

import UIKit

class AjouterFluxViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    @IBOutlet weak var typeFluxSC: UISegmentedControl!
    @IBOutlet weak var nomFluxTF: UITextField!
    @IBOutlet weak var dateFluxDP: UIDatePicker!
    @IBOutlet weak var montantFluxTF: UITextField!
    @IBOutlet weak var laFrequenceSC: UISegmentedControl!
    @IBOutlet weak var estRecurrSC: UISegmentedControl!
    @IBOutlet weak var validationLB: UILabel!
    @IBOutlet weak var nomGroupeTF: UITextField!
    
    @IBOutlet weak var laTableView: UITableView!
    
    public var lesGroupes:[Groupe] = []
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        lesGroupes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "groupeCellFlux", for: indexPath) as! groupeCell
        cell.nomGroupeLB.text = lesGroupes[indexPath.row].nomGroupe
        cell.onRemove = {
            self.lesGroupes.remove(at: indexPath.row)
            self.laTableView.reloadData()
        }
        return cell
    }
    
    
    
    @IBAction func tapAjouterGroupe(_ sender: Any) {
        if nomGroupeTF.text! != "" {
            lesGroupes.append(Groupe(nomGroupeTF.text!))
            self.laTableView.reloadData()
        }
    }
    
    @IBAction func tapSurAnnuler(_ sender: Any) {
        nomFluxTF.text = ""
        montantFluxTF.text = ""
        typeFluxSC.selectedSegmentIndex = 0
        dateFluxDP.date = Date()
        laFrequenceSC.selectedSegmentIndex = 0
        estRecurrSC.selectedSegmentIndex = 0
    }
    
    @IBAction func tapSurAjouter(_ sender: Any) {
        
        var laDuree : Int = 730
        
        var leType : String
        if typeFluxSC.selectedSegmentIndex == 0{
            leType = "entree"
        }else{
            leType = "sortie"
        }
        
        var leNom : String
        leNom = nomFluxTF.text!
        
        var laDate : Date
        laDate = dateFluxDP.date
        
        if (montantFluxTF.text == ""){
            validationLB.text = "Veuillez rentrer un montant pour le flux."
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.validationLB.text = ""
            }
        }
        var leMontant : Float
        if let montant = Float(montantFluxTF.text!) {
            leMontant = montant
        }else {
            return
        }
        leMontant = abs(Float(montantFluxTF.text!)!)
        
        var laFreq : Int = 0
        let laFreqRecup : Int = laFrequenceSC.selectedSegmentIndex
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
        
        if (nomFluxTF.text == ""){
            validationLB.text = "Veuillez rentrer un nom pour le flux."
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.validationLB.text = ""
            }
        }
        else{
            var leNouveauFlux : Flux
            leNouveauFlux = Flux(nomFlux : leNom, montantFlux : leMontant, typeFlux: leType, dateFlux: laDate, groupesFlux : lesGroupes, frequenceFlux : laFreq, dureeFlux : laDuree)
            AppDelegate.fluxs.append(leNouveauFlux)
            AppDelegate.actualiserJSON()
            typeFluxSC.selectedSegmentIndex = 0
            nomFluxTF.text! = ""
            dateFluxDP.date = Date()
            montantFluxTF.text! = ""
            laFrequenceSC.selectedSegmentIndex = 0
            estRecurrSC.selectedSegmentIndex = 0
            validationLB.text = "Le flux a bien été ajouté!"
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.validationLB.text = ""
                self.lesGroupes.removeAll()
                self.laTableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cacherClavier))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        validationLB.text = ""
        
        self.laTableView.delegate = self
        self.laTableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    @objc func cacherClavier() {
        view.endEditing(true)
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
