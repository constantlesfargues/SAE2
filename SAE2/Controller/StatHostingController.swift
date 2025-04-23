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

struct StatUIView: View {
    var body: some View {
        Chart(AppDelegate.stats[AppDelegate.statIndex].points! ,id:\.x) { item in
            LineMark(
                x: .value("x",item.x),
                y: .value("y",item.y)
                )
        }
    }
}
