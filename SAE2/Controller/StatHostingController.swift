//
//  statHC.swift
//  SAE2
//
//  Created by etudiant on 17/04/2025.
//

import UIKit
import SwiftUI
import Charts



#Preview {
    StatUIView()
}

class StatHostingController: UIHostingController<StatUIView> {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder, rootView: StatUIView())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(AppDelegate.statIndex)
    }
}

struct StatUIView: View {
    var body: some View {
        Chart(AppDelegate.stats[AppDelegate.statIndex] ,id:\.x) { item in
            LineMark(
                x: .value("x",item.x),
                y: .value("y",item.y)
                )
        }
    }
}
