//
//  StatsViewController.swift
//  SAE2
//
//  Created by etudiant on 03/04/2025.
//

import UIKit

class StatsCell: UITableViewCell {
    public var idStat:Int = 0
}

class StatsViewController: UITableViewController {
    
    let lesStats:[String] = [
        "stat1",
        "stat2"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return lesStats.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "statCell", for: indexPath) as! StatsCell
        cell.textLabel?.text = lesStats[indexPath.row]
        cell.idStat = indexPath.row
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! StatsCell
        print(cell.idStat)
        AppDelegate.statIndex = cell.idStat
    }

}
