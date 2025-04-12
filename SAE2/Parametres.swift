
import Foundation

class Parametres : Codable {
    
    // tout les parametres de l'app
    public var param1 : Int
    public var param2 : String
    // ajouter les parametres
    
    
    // constructeur (parametres initiaux)
    public init(){
        param1 = 0
        param2 = "test"
    }
    
    // sauvegarde les parametres donnés (dans le fichier "<nom utilisateur>Parametres.json")
    public static func ecrireParam(_ user : Utilisateur ,_ lesParametres : Parametres ) {
        let leFileManager = FileManager.default
        let urls = leFileManager.urls(for: .documentDirectory ,in: .userDomainMask )
        let urlFichier = urls.first!.appendingPathComponent( "\(user.nomUtilisateur)Parametres.json" )
        
        let objJSONEncodeur = JSONEncoder()
        let donneesASauvegarder = try? objJSONEncodeur.encode( lesParametres )
        
        leFileManager.createFile(atPath : urlFichier.path, contents : donneesASauvegarder, attributes : nil)
    }
    
    // renvoi les parametres lus (dans le fichier "<nom utilisateur>Parametres.json")
    public static func lireParam(_ user : Utilisateur) -> Parametres? {
        let leFileManager = FileManager.default
        let urls = leFileManager.urls(for: .documentDirectory ,in: .userDomainMask )
        let urlFichier = urls.first!.appendingPathComponent( "\(user.nomUtilisateur)Parametres.json" )
        
        if ( leFileManager.fileExists(atPath : urlFichier.path) ) {
            
            let data = try! Data( contentsOf : urlFichier )
            
            let decoder = JSONDecoder( )
            
            let retour : [Parametres]? = try? decoder.decode( [Parametres].self , from : data )
            if ( retour?.isEmpty == nil ) {
                return nil
            }else{
                return retour![0]
            }
        }else{
            return nil
        }
    }
    
    public func enChaine() -> String{
        return "\(param1) - \(param2)"
    }
    
    
}
