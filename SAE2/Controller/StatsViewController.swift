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
    public var idStat:Int = 0
    public var reloadStats:()->() = {}
    @IBAction func tapRemove(_ sender: Any) {
        AppDelegate.stats.remove(at: idStat)
        removeBtn.isEnabled = false
        self.reloadStats()
    }
}

class StatsViewController: UITableViewController,UIPickerViewDelegate,UIPickerViewDataSource {
    private var tags:[String] = []
    private var stats:[Stat] = []
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return tags.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return tags[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row == 0 {
            stats = AppDelegate.stats
        }else {
            stats = []
            for stat in AppDelegate.stats {
                if stat.tag == tags[row] {
                    stats.append(stat)
                }
            }
        }
        self.tableView.reloadData()
    }
    
    @IBOutlet weak var tagPV: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tags = AppDelegate.getTags()
        stats = AppDelegate.stats
        tagPV.delegate = self
        tagPV.dataSource = self
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
        cell.statName?.text = stats[indexPath.row].name!
        cell.idStat = stats[indexPath.row].id!
        cell.reloadStats = self.tableView.reloadData
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! StatsCell
        print(cell.idStat)
        AppDelegate.statIndex = cell.idStat
    }

}
