//
//  statHC.swift
//  SAE2
//
//  Created by etudiant on 17/04/2025.
//

import UIKit
import SwiftUI
import Charts

class StatHostingController: UIHostingController<StatUIView> {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder, rootView: StatUIView())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

func getStat()->Stat {
    for stat in AppDelegate.stats {
        if stat.id == AppDelegate.statIndex {
            return stat
        }
    }
    return AppDelegate.stats[0]
}

struct StatUIView: View {
    var body:some View{
        getStat().getChart(flux: AppDelegate.fluxs)
    }
}
