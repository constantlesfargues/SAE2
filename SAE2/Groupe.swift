
import Foundation

class Groupe : Codable {
    
    public var nomGroupe : String
    
    public func enChaine() -> String{
        return "nom groupe : \(nomGroupe)"
    }
    
}
