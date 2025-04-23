//
//  Stat.swift
//  SAE2
//
//  Created by etudiant on 22/04/2025.
//

class Stat:Codable {
    public var name:String?
    public var points:[Point]?
    public var tag:String?
    public var id:Int?
    init(_ tag:String,_ name:String,_ points:[Point],_ id:Int) {
        self.name = name
        self.points = points
        self.tag = tag
        self.id = id
    }
}
