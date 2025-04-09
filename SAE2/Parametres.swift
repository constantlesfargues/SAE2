
import Foundation

class Parametres : Codable {
    
    // tout les parametres de l'app
    public var param1 : Int
    public var param2 : String
    // ajouter parametres
    
    
    // constructeur
    public init(){
        param1 = 0
        param2 = "test"
    }
    
    // sauvegarde les parametres donnés (dans le fichier "parametres.json")
    public static func ecrireParam(_ lesParametres : Parametres ) {
        let leFileManager = FileManager.default
        let urls = leFileManager.urls(for: .documentDirectory ,in: .userDomainMask )
        let urlFichier = urls.first!.appendingPathComponent( "parametres.json" )
        
        let objJSONEncodeur = JSONEncoder()
        let donneesASauvegarder = try? objJSONEncodeur.encode( lesParametres )
        
        leFileManager.createFile(atPath : urlFichier.path, contents : donneesASauvegarder, attributes : nil)
    }
    
    // renvoi les parametres lus (dans le fichier "parametres.json")
    public static func lireParam() -> Parametres {
        let leFileManager = FileManager.default
        let urls = leFileManager.urls(for: .documentDirectory ,in: .userDomainMask )
        let urlFichier = urls.first!.appendingPathComponent( "parametres.json" )
        
        if ( leFileManager.fileExists(atPath : urlFichier.path) ) {
            
            let data = try! Data( contentsOf : urlFichier )
            
            let decoder = JSONDecoder( )
            
            let retour = try! decoder.decode( [Parametres].self , from : data )
            return retour[0]
        }else{
            let lesParametres : Parametres = Parametres()
            return lesParametres
        }
    }
    
    
}
