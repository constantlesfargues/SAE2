
import Foundation

class Groupe : Codable {
    
    public var nomGroupe : String
    
    init(_ nom:String) {
        self.nomGroupe = nom
    }
    
    // renvoi toutes les données de l'instance dans un String formaté
    public func enChaine() -> String{
        return "nom groupe : \(nomGroupe)"
    }
    
}
