//
//  Stat.swift
//  SAE2
//
//  Created by etudiant on 22/04/2025.
//

import Foundation
import SwiftUI
import Charts

class Stat:Codable {
    public var id:Int
    public var name:String
    public var type:String
    public var groupes:[Groupe]?
    public var typeFlux:String?
    public var dateMin:Date?
    public var dateMax:Date?
    public var tag:String?
    public var recurrent:Bool?
    public init(id:Int,_ name:String
         ,_ type:String
         ,_ groupes:[Groupe]?
         ,_ typeFlux:String?
         ,_ dateMin:Date?
         ,_ dateMax:Date?
         ,_ tag:String?
         ,_ recurrent:Bool?
    ){
        self.id = id
        self.name = name
        self.type = type
        self.groupes = groupes
        self.typeFlux = typeFlux
        self.dateMin = dateMin
        self.dateMax = dateMax
        self.tag = tag
        self.recurrent = recurrent
    }
    
    @ViewBuilder private func mkPie(data:[(nom:String,montant:Float)])-> some View {
        Chart(data, id: \.nom) { d in
            SectorMark(angle: .value(
                Text(verbatim: d.nom), d.montant )
            ).foregroundStyle(
                by: .value(
                    Text(verbatim: d.nom),
                    d.nom
                )
            )
        }
    }
    
    @ViewBuilder private func mkLine(data:[(date:Date,montant:Float)])-> some View {
        Chart(data, id: \.date) { d in
            LineMark(
                x:.value("temps", d.date),
                y:.value("montant",d.montant)
            )
        }
    }
    
    @ViewBuilder private func mkArea(data:[(date:Date,montant:Float,groupe:String)])-> some View {
        Chart(data, id: \.date) { d in
            AreaMark(
                x:.value("temps", d.date),
                y:.value("montant",d.montant)
            ).foregroundStyle(by: .value("groupe", d.groupe))
        }
    }
    
    @ViewBuilder private func mkBar(data:[(date:Date,montant:Float)])-> some View {
        Chart(data, id: \.date) { d in
            BarMark(
                x:.value("temps", d.date),
                y:.value("montant",d.montant)
            )
        }
    }
    
    @ViewBuilder private func mkEmpty()->some View {
        Text("une statistique")
    }
    
    public func checkFlux(_ flux:Flux)->Bool {
        var ok = true
        if let recurrent {
            if flux.frequenceFlux == 0 && recurrent || flux.frequenceFlux > 0 && !recurrent{
                ok = false
            }
        }
        if !ok {return false}
        if let groupes {
            for i in 0..<min(flux.groupesFlux.count,groupes.count) {
                if groupes[i].nomGroupe != flux.groupesFlux[i].nomGroupe {
                    ok = false
                    break
                }
            }
        }
        if !ok {return false}
        if let typeFlux {
            ok = typeFlux == flux.typeFlux
        }
        if !ok {return false}
        if let dateMax {
            ok = dateMax >= flux.dateFlux
        }
        if !ok {return false}
        if let dateMin {
            ok = dateMin <= flux.dateFlux
        }
        if !ok {return false}
        return true
    }
    
    public func getChart(flux:[Flux])->AnyView {
        if type == "pieMontant" {
            var data:[(nom:String,montant:Float)] = []
            for flux in AppDelegate.fluxs {
                if checkFlux(flux) {
                    data.append((flux.nomFlux,flux.montantFlux))
                }
            }
            return AnyView(mkPie(data: data))
        }
        else if type == "pieGroupe" {
            var data : [String:Float] = [:]
            for flux in AppDelegate.fluxs {
                if checkFlux(flux) {
                    if flux.groupesFlux.isEmpty {
                        if data["autre"] == nil {
                            data["autre"] = 0
                        }
                        data["autre"]! += flux.montantFlux
                    }else  {
                        for groupe in flux.groupesFlux {
                            let gr = groupe.nomGroupe
                            if data[gr] == nil {
                                data[gr] = 0
                            }
                            data[gr]! += flux.montantFlux
                        }
                    }
                }
            }
            var dataFormat:[(nom:String,montant:Float)] = []
            for (k,v) in data {
                dataFormat.append((nom:k,montant:v))
            }
            return AnyView(mkPie(data: dataFormat))
        }else if type == "line" {
            var data:[(date:Date,montant:Float)] = []
            var montant:Float = 0
            for flux in AppDelegate.fluxs {
                if checkFlux(flux) {
                    montant += flux.montantFlux
                    data.append((date:flux.dateFlux,montant:montant))
                }
            }
            return AnyView(mkLine(data:data))
        }else if type == "area" {
            var groupesSet:Set<String> = Set()
            groupesSet.insert("autre")
            for flux in AppDelegate.fluxs {
                for groupe in flux.groupesFlux {
                    groupesSet.insert(groupe.nomGroupe)
                }
            }
            let groupes = groupesSet.sorted()
            //print(groupes,"\n")
            var data:[(date:Date,montant:Float,groupe:String)] = []
            for flux in AppDelegate.fluxs {
                if checkFlux(flux) {
                        for subGroupe in groupes {
                            var montant:Float = 0
                            if subGroupe == "autre" && flux.groupesFlux.isEmpty {
                                montant += flux.montantFlux
                            }else {
                                for groupe in flux.groupesFlux {
                                    if groupe.nomGroupe == subGroupe {
                                        montant += flux.montantFlux/Float(flux.groupesFlux.count)
                                        break
                                    }
                                }
                            }
                            if montant < 0 {
                                data.append((date:flux.dateFlux,montant:0,groupe:subGroupe))
                            }
                            data.append((date:flux.dateFlux,montant:montant,groupe:subGroupe))
                        }
                    /*
                    if let negative {
                        for i in data.count-groupes.count..<data.count {
                            data[i].montant = negative/Float(groupes.count)
                        }
                    }
                     */
                    
                }
            }
            var isSorted = false
            //print(data,"\n")
            while !isSorted {
                isSorted = true
                for i in 0..<data.count-1 {
                    if data[i].date > data[i+1].date {
                        isSorted = false
                        let temp = data[i]
                        data[i] = data[i+1]
                        data[i+1] = temp
                    }
                }
            }
            
            //print(data)
            /*
            if data.count > 1 {
                for i in 1..<data.count {
                    data[i].montant += data[i-1].montant
                }
            }*/
            return AnyView(mkArea(data: data))
        }else if type == "bar" {
            var data:[(date:Date,montant:Float)] = []
            for flux in AppDelegate.fluxs {
                if checkFlux(flux) {
                    data.append((flux.dateFlux,flux.montantFlux))
                }
            }
            return AnyView(mkBar(data:data))
        }
        return AnyView(mkEmpty())
    }
}
