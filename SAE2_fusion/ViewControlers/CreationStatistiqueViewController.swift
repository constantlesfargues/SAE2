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
    var modifier:Bool = false
    var idAModif:Int = 0
    var laStat:Stat? = nil
    
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
        "graphique linéaire flux",
        "diagramme circulaire groupes",
        "diagramme en bars",
        "diagramme circulaire flux"
    ]
    
    @IBOutlet weak var nomTF: UITextField!

    @IBOutlet weak var tagTF: UITextField!
    
    @IBOutlet weak var typeStatPV: UIPickerView!
    
    @IBOutlet weak var dateMinDP: UIDatePicker!

    @IBOutlet weak var dateMaxDP: UIDatePicker!
    
    @IBOutlet weak var typeFluxSC: UISegmentedControl!
    @IBOutlet weak var recurrentSC: UISegmentedControl!
    
    
    @IBOutlet weak var nomGroupeTF: UITextField!
    
    @IBOutlet weak var laTableView: UITableView!
    
    public var lesGroupes:[Groupe] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        typeStatPV.delegate = self
        typeStatPV.dataSource = self
        
        laTableView.dataSource = self
        laTableView.delegate = self
        // Do any additional setup after loading the view.
        if let laStat {
            print(laStat.name)
            let lesTypes:[String:Int] = [
                "line":0,
                "pieGroupe":1,
                "bar":2,
                "pieMontant":3
            ]
            typeStatPV.selectRow(lesTypes[laStat.type]!, inComponent: 0, animated: false)
            if laStat.typeFlux != nil {
                let lesTypesFlux:[String:Int] = [
                    "entree":1,
                    "sortie":2
                ]
                typeFluxSC.selectedSegmentIndex = lesTypesFlux[laStat.typeFlux!]!
            }else {
                typeFluxSC.selectedSegmentIndex = 0
            }
            if laStat.recurrent != nil {
                let lesTypesRec:[Bool:Int] = [
                    true:1,
                    false:0
                ]
                recurrentSC.selectedSegmentIndex = lesTypesRec[laStat.recurrent!]!
            }else {
                recurrentSC.selectedSegmentIndex = 0
            }
            dateMaxDP.date = laStat.dateMax!
            dateMinDP.date = laStat.dateMin!
            
            lesGroupes = laStat.groupes!
            nomTF.text = laStat.name
            tagTF.text = laStat.tag
            
        }
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
            "line",
            "pieGroupe",
            "bar",
            "pieMontant"
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
            
            let nvStat = Stat(id: id, nomTF.text!,
                     lesTypes[typeStatPV.selectedRow(inComponent: 0)],
                     lesGroupes,
                     lesTypesFlux[typeFluxSC.selectedSegmentIndex],
                     dateMinDP.date,
                     dateMaxDP.date,
                     tagTF.text! != "" ? tagTF.text!:nil,
                     tableRecurrence[recurrentSC.selectedSegmentIndex]
                    )
            if modifier {
                AppDelegate.modifierStat(idAModif, nvStat)
            }else {
                AppDelegate.stats.append(nvStat)
            }
            AppDelegate.actualiserJSON()
            
            nomTF.text = ""
            tagTF.text = ""
            lesGroupes = []
            laTableView.reloadData()
            typeFluxSC.selectedSegmentIndex = 0
            recurrentSC.selectedSegmentIndex = 0
            
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
