
import Foundation

struct Groupe: Identifiable, Codable {
    var id = UUID()
    public var nomGroupe: String

    init(_ nomGroupe: String) {
        self.nomGroupe = nomGroupe
    }
    
    public func enChaine() -> String{
        return "nom groupe : \(nomGroupe)"
    }
}
