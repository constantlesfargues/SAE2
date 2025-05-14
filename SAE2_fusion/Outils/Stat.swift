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
    
    // Sauvegarde les stats dans le fichier "<nom utilisateur>Stats.json"
    public static func ecrireStats(_ user: Utilisateur, _ lesStats: [Stat]) {
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let fileURL = urls.first!.appendingPathComponent("\(user.getNomFormate())Stats.json")
        
        let encoder = JSONEncoder()
        if let dataToSave = try? encoder.encode(lesStats) {
            fileManager.createFile(atPath: fileURL.path, contents: dataToSave, attributes: nil)
        }
    }
    
    // Renvoie les stats lus depuis "<nom utilisateur>Stats.json"
    public static func lireFlux(_ user: Utilisateur) -> [Stat]? {
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let fileURL = urls.first!.appendingPathComponent("\(user.getNomFormate())Stats.json")
        
        guard fileManager.fileExists(atPath: fileURL.path),
              let data = try? Data(contentsOf: fileURL),
              let flux = try? JSONDecoder().decode([Stat].self, from: data)
        else {
            return nil
        }
        
        return flux
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
            for groupe in groupes {
                print(groupe.nomGroupe)
                var okGrp:Bool = false
                for g in flux.groupesFlux {
                    print(g.nomGroupe)
                    if g.nomGroupe.lowercased() == groupe.nomGroupe.lowercased() {
                        okGrp = true
                        break
                    }
                }
                if !okGrp {
                    ok = false
                    break
                }
            }
        }
        print(ok)
        if !ok {return false}
        if let typeFlux {
            ok = typeFlux.lowercased() == flux.typeFlux.lowercased()
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
        var fluxs:[Flux] = []
        for flux in AppDelegate.fluxs {
            if flux.frequenceFlux > 0 {
                var dateMax:Date = Date()
                for f in AppDelegate.fluxs {
                    if f.dateFlux > dateMax {
                        dateMax = f.dateFlux
                    }
                }
                //print(Int(dateMax.timeIntervalSince(flux.dateFlux))/(60*60*24*flux.frequenceFlux))
                for i in 0...Int(dateMax.timeIntervalSince(flux.dateFlux))/(60*60*24*flux.frequenceFlux) {
                    fluxs.append(Flux(nomFlux: flux.nomFlux, montantFlux: flux.montantFlux, typeFlux: flux.typeFlux, dateFlux: flux.dateFlux.addingTimeInterval(TimeInterval(60*60*24*i*flux.frequenceFlux)), groupesFlux: flux.groupesFlux, frequenceFlux: flux.frequenceFlux, dureeFlux: 0))
                }
            }else {
                fluxs.append(flux)
            }
        }
        let fluxsCpy = fluxs
        fluxs = []
        for flux in fluxsCpy {
            if checkFlux(flux) {
                fluxs.append(flux)
            }
        }
        if fluxs.count > 1 {
            var isSorted = false
            //print(data,"\n")
            while !isSorted {
                isSorted = true
                for i in 0..<fluxs.count-1 {
                    if fluxs[i].dateFlux > fluxs[i+1].dateFlux {
                        isSorted = false
                        let temp = fluxs[i]
                        fluxs[i] = fluxs[i+1]
                        fluxs[i+1] = temp
                    }
                }
            }
        }
        if type == "pieMontant" {
            var data:[(nom:String,montant:Float)] = []
            for flux in fluxs {
                data.append((flux.nomFlux,flux.montantFlux))
            }
            return AnyView(mkPie(data: data))
        }
        else if type == "pieGroupe" {
            var data : [String:Float] = [:]
            for flux in fluxs {
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
            var dataFormat:[(nom:String,montant:Float)] = []
            for (k,v) in data {
                dataFormat.append((nom:k,montant:v))
            }
            return AnyView(mkPie(data: dataFormat))
        }else if type == "line" || type == "bar" {
            print(fluxs)
            var data:[Date:Float] = [:]
            var montant:Float = 0
            for flux in fluxs {
                
                montant += flux.typeFlux.lowercased() == "sortie" ? -flux.montantFlux : flux.montantFlux
                //print(flux.typeFlux.lowercased() == "sortie",flux.typeFlux.lowercased() == "sortie" ? -flux.montantFlux : flux.montantFlux)
                //montant += flux.montantFlux
                data[flux.dateFlux] = montant
            }
            var arrData:[(date:Date,montant:Float)] = []
            for (k,v) in data {
                arrData.append((date:k,montant:v))
            }
            if !arrData.isEmpty {
                var isSorted = false
                //print(data,"\n")
                while !isSorted {
                    isSorted = true
                    for i in 0..<data.count-1 {
                        if arrData[i].date > arrData[i+1].date {
                            isSorted = false
                            let temp = arrData[i]
                            arrData[i] = arrData[i+1]
                            arrData[i+1] = temp
                        }
                    }
                }
            }
            if type == "line" {
                return AnyView(mkLine(data:arrData))
            }
            return AnyView(mkBar(data:arrData))
        }/*else if type == "area" {
          var groupesSet:Set<String> = Set()
          groupesSet.insert("autre")
          for flux in fluxs {
          for groupe in flux.groupesFlux {
          groupesSet.insert(groupe.nomGroupe)
          }
          }
          let groupes = groupesSet.sorted()
          //print(groupes,"\n")
          var data:[(date:Date,montant:Float,groupe:String)] = []
          for flux in fluxs {
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
          if !data.isEmpty {
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
          }
          return AnyView(mkArea(data: data))
          }*/
        return AnyView(mkEmpty())
    }
}
