
import Foundation

class Utilisateur : Codable {
    
    public var nomUtilisateur : String
    
    public init(_ nom : String){
        nomUtilisateur = nom
    }
    
    // sauvegarde l' utilisateur donné (dans le fichier "utilisateur.json")
    public static func ecrireUtilisateur(_ lesUtilisateur : [Utilisateur] ) {
        let leFileManager = FileManager.default
        let urls = leFileManager.urls(for: .documentDirectory ,in: .userDomainMask )
        let urlFichier = urls.first!.appendingPathComponent( "utilisateur.json" )
        
        let objJSONEncodeur = JSONEncoder()
        let donneesASauvegarder = try? objJSONEncodeur.encode( lesUtilisateur )
        
        leFileManager.createFile(atPath : urlFichier.path, contents : donneesASauvegarder, attributes : nil)
    }
    
    // renvoi l'utilisateur lu (dans le fichier "utilisateur.json")
    public static func lireUtilisateur() -> [Utilisateur]? {
        let leFileManager = FileManager.default
        let urls = leFileManager.urls(for: .documentDirectory ,in: .userDomainMask )
        let urlFichier = urls.first!.appendingPathComponent( "utilisateur.json" )
        
        if ( leFileManager.fileExists(atPath : urlFichier.path) ) {
            
            let data = try! Data( contentsOf : urlFichier )
            
            let decoder = JSONDecoder( )
            
            let retour = try! decoder.decode( [Utilisateur].self , from : data )
            return retour
        }else{
            let lesUtilisateurs : [Utilisateur]? = nil
            return lesUtilisateurs
        }
    }
    
    public func enChaine() -> String{
        return "nom : \(nomUtilisateur)"
    }
    
}
