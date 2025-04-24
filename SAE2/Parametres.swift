
import Foundation

class Parametres : Codable {
    
    // tout les parametres de l'app
    public var modeSombre : Bool?
    // ajouter les parametres
    
    
    // constructeur (parametres initiaux)
    public init(){
        modeSombre = false
    }
    public init( isNull : Bool){
        if(isNull){
            modeSombre = nil
        }
    }
    
    public static func ecrireParam(_ user: Utilisateur, _ lesParametres: Parametres) {
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let fileURL = urls.first!.appendingPathComponent("\(user.getNomFormate())Parametres.json")

        let encoder = JSONEncoder()
        if let dataToSave = try? encoder.encode(lesParametres) {
            fileManager.createFile(atPath: fileURL.path, contents: dataToSave, attributes: nil)
        }
    }

    public static func lireParam(_ user: Utilisateur) -> Parametres? {
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let fileURL = urls.first!.appendingPathComponent("\(user.getNomFormate())Parametres.json")

        guard fileManager.fileExists(atPath: fileURL.path),
              let data = try? Data(contentsOf: fileURL),
              let param = try? JSONDecoder().decode(Parametres.self, from: data)
        else {
            return nil
        }

        return param
    }
    
    // renvoi toutes les données de l'instance dans un String formaté
    public func enChaine() -> String{
        return "\(modeSombre)"
    }
    
    
}
