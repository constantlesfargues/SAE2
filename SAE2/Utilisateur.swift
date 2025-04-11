
import Foundation

class Utilisateur : Codable{
    
    public var nomUtilisateur : String
    
    public init(){
        nomUtilisateur = "test"
    }
    
    // sauvegarde l' utilisateur donné (dans le fichier "utilisateur.json")
    public static func ecrireUtilisateur(_ unUtilisateur : Utilisateur ) {
        let leFileManager = FileManager.default
        let urls = leFileManager.urls(for: .documentDirectory ,in: .userDomainMask )
        let urlFichier = urls.first!.appendingPathComponent( "utilisateur.json" )
        
        let objJSONEncodeur = JSONEncoder()
        let donneesASauvegarder = try? objJSONEncodeur.encode( unUtilisateur )
        
        leFileManager.createFile(atPath : urlFichier.path, contents : donneesASauvegarder, attributes : nil)
    }
    
    // renvoi l'utilisateur lu (dans le fichier "utilisateur.json")
    public static func lireUtilisateur() -> Utilisateur {
        let leFileManager = FileManager.default
        let urls = leFileManager.urls(for: .documentDirectory ,in: .userDomainMask )
        let urlFichier = urls.first!.appendingPathComponent( "utilisateur.json" )
        
        if ( leFileManager.fileExists(atPath : urlFichier.path) ) {
            
            let data = try! Data( contentsOf : urlFichier )
            
            let decoder = JSONDecoder( )
            
            let retour = try! decoder.decode( [Utilisateur].self , from : data )
            return retour[0]
        }else{
            let lesParametres : Utilisateur = Utilisateur()
            return lesParametres
        }
    }
    
    public func enChaine() -> String{
        return "nom : \(nomUtilisateur)"
    }
    
}
