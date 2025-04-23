
import Foundation

class Groupe : Codable {
    
    public var nomGroupe : String
    
    // renvoi toutes les données de l'instance dans un String formaté
    public func enChaine() -> String{
        return "nom groupe : \(nomGroupe)"
    }
    
}
