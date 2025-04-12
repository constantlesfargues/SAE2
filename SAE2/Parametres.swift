
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
        // récupere l'url du fichier
        let leFileManager = FileManager.default
        let urls = leFileManager.urls(for: .documentDirectory ,in: .userDomainMask )
        let urlFichier = urls.first!.appendingPathComponent( "\(user.nomUtilisateur)Parametres.json" )
        
        // encode les parametres
        let objJSONEncodeur = JSONEncoder()
        let donneesASauvegarder = try? objJSONEncodeur.encode( lesParametres )
        
        // crée/écrit dans le fichier
        leFileManager.createFile(atPath : urlFichier.path, contents : donneesASauvegarder, attributes : nil)
    }
    
    // renvoi les parametres lus (dans le fichier "<nom utilisateur>Parametres.json")
    public static func lireParam(_ user : Utilisateur) -> Parametres? {
        // récupere l'url du fichier
        let leFileManager = FileManager.default
        let urls = leFileManager.urls(for: .documentDirectory ,in: .userDomainMask )
        let urlFichier = urls.first!.appendingPathComponent( "\(user.nomUtilisateur)Parametres.json" )
        
        // si le fichier existe
        if ( leFileManager.fileExists(atPath : urlFichier.path) ) {
            
            let data = try! Data( contentsOf : urlFichier )// charge le fichier
            
            let decoder = JSONDecoder( )
            let retour : [Parametres]? = try? decoder.decode( [Parametres].self , from : data )// décode en objet de la classe
            
            if ( retour?.isEmpty == nil ) {  
                return nil
            }else{
                return retour![0]
            }
        }else{
            return nil// renvoi nil si le fichier n'existe pas
        }
    }
    
    // renvoi toutes les données de l'instance dans un String formaté
    public func enChaine() -> String{
        return "\(param1) - \(param2)"
    }
    
    
}
