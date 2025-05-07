
import Foundation

class Groupe : Codable {
    
    public var nomGroupe : String
    
    init(_ nomGroupe: String) {
        self.nomGroupe = nomGroupe
    }
    
    // renvoi toutes les données de l'instance dans un String formaté
    public func enChaine() -> String{
        return "nom groupe : \(nomGroupe)"
    }
    
}
