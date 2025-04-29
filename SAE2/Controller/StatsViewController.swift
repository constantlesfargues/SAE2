//
//  StatsViewController.swift
//  SAE2
//
//  Created by etudiant on 03/04/2025.
//

import UIKit

class StatsCell: UITableViewCell {
    @IBOutlet weak var statName: UILabel!
    @IBOutlet weak var removeBtn: UIButton!
    public var i:Int = 0
    public var reloadStats:()->() = {}
    @IBAction func tapRemove(_ sender: Any) {
        AppDelegate.stats.remove(at: i)
        removeBtn.isEnabled = false
        self.reloadStats()
    }
}

class StatsViewController: UITableViewController,UIPickerViewDelegate,UIPickerViewDataSource {
    private var tags:[String] = []
    private var stats:[Stat] = []
    private var filtre:String? = nil
    public var alertAjout : UIAlertController!
    
    public var tagRow:Int = 0
    
    public var alertResRecherche : UIAlertController!
    
    @IBAction func tapSearch(_ sender: Any) {
        present(alertAjout, animated: true,completion: nil)
    }
    
    @IBAction func tapReinit(_ sender: Any) {
        filtre = nil
        updateStats()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return tags.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return tags[row]
    }
    
    func updateStats() {
        stats = []
        for stat in AppDelegate.stats {
            if filtre == nil || stat.name.contains(filtre!) {
                if tagRow == 0 {
                    stats.append(stat)
                }else if stat.tag == tags[tagRow] {
                    stats.append(stat)
                }
            }
        }
        self.tableView.reloadData()
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        tagRow = row
        updateStats()
        self.tableView.reloadData()
    }
    
    @IBOutlet weak var tagPV: UIPickerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tags = AppDelegate.getTags()
        stats = AppDelegate.stats
        tagPV.delegate = self
        tagPV.dataSource = self
        
        // Setup de la popup de recherche de stats :
        alertAjout = UIAlertController(title: "filtrer les statistiques", message: "texte par lequel filtrer:", preferredStyle: .alert)
        alertAjout.addTextField { (textField) in
            textField.placeholder = "filtre"
        }
        // Ajout des boutons de la pop up
        let cancelAction = UIAlertAction(title: "Annuler", style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: "Chercher", style: .default) { _ in
            //nom recherché
            if self.alertAjout.textFields![0].text == "" {
                self.filtre = nil
            }else {
                self.filtre = self.alertAjout.textFields![0].text
                self.alertAjout.textFields![0].text = ""
                print(self.filtre!)
            }
            self.updateStats()
            
        }
        alertAjout.addAction(cancelAction)
        alertAjout.addAction(saveAction)
        // Do any additional setup after loading the view.
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return stats.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "statCell", for: indexPath) as! StatsCell
        cell.statName?.text = stats[indexPath.row].name
        cell.i = indexPath.row
        cell.reloadStats = self.tableView.reloadData
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        AppDelegate.fluxs = [
            Flux(nomFlux: "f3", montantFlux: 60, typeFlux: "sortie", dateFlux: Date(timeIntervalSinceReferenceDate: 60*60*24*99), groupesFlux: [], frequenceFlux: 0, dureeFlux: 0),
            Flux(nomFlux: "f1", montantFlux: 50, typeFlux: "entree", dateFlux: Date(timeIntervalSinceReferenceDate: 60*60*24*100), groupesFlux: [Groupe("g2")], frequenceFlux: 0, dureeFlux: 0),
            Flux(nomFlux: "f1", montantFlux: 40, typeFlux: "entree", dateFlux: Date(timeIntervalSinceReferenceDate: 60*60*24*101), groupesFlux: [Groupe("g2"),Groupe("g1")], frequenceFlux: 0, dureeFlux: 0),
            
            Flux(nomFlux: "f2", montantFlux: 30, typeFlux: "entree", dateFlux: Date(timeIntervalSinceReferenceDate:60*60*24*102), groupesFlux: [Groupe("g1")], frequenceFlux: 0, dureeFlux: 0),
            Flux(nomFlux: "f2", montantFlux: 30, typeFlux: "entree", dateFlux: Date(timeIntervalSinceReferenceDate:60*60*24*103), groupesFlux: [Groupe("g2"),Groupe("g1")], frequenceFlux: 0, dureeFlux: 0),
            Flux(nomFlux: "f3", montantFlux: 25, typeFlux: "sortie", dateFlux: Date(timeIntervalSinceReferenceDate: 60*60*24*104), groupesFlux: [], frequenceFlux: 0, dureeFlux: 0),
            Flux(nomFlux: "f3", montantFlux: 25, typeFlux: "sortie", dateFlux: Date(timeIntervalSinceReferenceDate: 60*60*24*105), groupesFlux: [], frequenceFlux: 0, dureeFlux: 0)
        ]
        
        let cell = sender as! StatsCell
        print(cell.i)
        AppDelegate.statIndex = cell.i
    }

}
