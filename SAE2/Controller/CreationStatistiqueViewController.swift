//
//  CreationStatistiqueViewController.swift
//  SAE2
//
//  Created by etudiant on 30/04/2025.
//

import UIKit

class groupeCell:UITableViewCell {
    @IBAction func tapBtnRemove(_ sender: Any) {
        onRemove()
    }
    @IBOutlet weak var nomGroupeLB: UILabel!
    public var onRemove:()->() = {}
}

class CreationStatistiqueViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        lesTypes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        lesTypes[row]
    }
    
    public var lesTypes:[String] = [
        "diagramme circulaire flux",
        "diagramme circulaire groupes",
        "graphique linéaire flux",
        "graphique en aires groupes",
        "diagramme en bars"
    ]
    
    @IBOutlet weak var nomTF: UITextField!

    @IBOutlet weak var tagTF: UITextField!
    
    @IBOutlet weak var typeStatPV: UIPickerView!
    
    @IBOutlet weak var dateMinDP: UIDatePicker!
    @IBOutlet weak var dateMinSwitch: UISwitch!
    
    @IBOutlet weak var dateMaxSwitch: UISwitch!
    @IBOutlet weak var dateMaxDP: UIDatePicker!
    
    @IBOutlet weak var typeFluxSC: UISegmentedControl!
    @IBOutlet weak var recurrentSC: UISegmentedControl!
    
    
    @IBOutlet weak var nomGroupeTF: UITextField!
    
    @IBOutlet weak var laTableView: UITableView!
    
    public var lesGroupes:[Groupe] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        typeStatPV.delegate = self
        typeStatPV.dataSource = self
        
        laTableView.dataSource = self
        laTableView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        lesGroupes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "groupeCell", for: indexPath) as! groupeCell
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
    
    @IBAction func tapCreerStat(_ sender: Any) {
        
        var id = 0
        if let last = AppDelegate.stats.last {
            id = last.id+1
        }
        
        let lesTypes:[String] = [
            "pieMontant",
            "pieGroupe",
            "line",
            "area",
            "bar"
        ]
        
        let lesTypesFlux:[String?] = [
            nil,
            "entree",
            "sortie"
        ]
        
        let tableRecurrence:[Bool?] = [
            nil,true,false
        ]
        
        if nomTF.text! != "" {
            
            AppDelegate.stats.append(
                Stat(id: id, nomTF.text!,
                     lesTypes[typeStatPV.selectedRow(inComponent: 0)],
                     lesGroupes,
                     lesTypesFlux[typeFluxSC.selectedSegmentIndex],
                     dateMinSwitch.isOn ? dateMinDP.date : nil,
                     dateMaxSwitch.isOn ? dateMaxDP.date : nil,
                     tagTF.text! != "" ? tagTF.text!:nil,
                     tableRecurrence[recurrentSC.selectedSegmentIndex]
                    )
            )
            
            nomTF.text = ""
            tagTF.text = ""
            
        }
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
