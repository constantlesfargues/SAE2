
import Foundation

class Utilisateur : Codable {
    
    public var nomUtilisateur : String
    
    // constructeur
    public init(_ nom : String){
        nomUtilisateur = nom
    }
    
    // sauvegarde l' utilisateur donné (dans le fichier "utilisateur.json")
    public static func ecrireUtilisateur(_ lesUtilisateur : [Utilisateur] ) {
        // récupere l'url du fichier
        let leFileManager = FileManager.default
        let urls = leFileManager.urls(for: .documentDirectory ,in: .userDomainMask )
        let urlFichier = urls.first!.appendingPathComponent( "utilisateur.json" )
        
        // encode les utilisateurs
        let objJSONEncodeur = JSONEncoder()
        let donneesASauvegarder = try? objJSONEncodeur.encode( lesUtilisateur )
        
        // crée/écrit dans le fichier
        leFileManager.createFile(atPath : urlFichier.path, contents : donneesASauvegarder, attributes : nil)
    }
    
    // renvoi l'utilisateur lu (dans le fichier "utilisateur.json")
    public static func lireUtilisateur() -> [Utilisateur]? {
        // récupere l'url du fichier
        let leFileManager = FileManager.default
        let urls = leFileManager.urls(for: .documentDirectory ,in: .userDomainMask )
        let urlFichier = urls.first!.appendingPathComponent( "utilisateur.json" )
        
        // si le fichier existe
        if ( leFileManager.fileExists(atPath : urlFichier.path) ) {
            
            let data = try! Data( contentsOf : urlFichier )// charge le fichier
            
            let decoder = JSONDecoder( )
            let retour = try! decoder.decode( [Utilisateur].self , from : data )// décode en objet de la classe
            
            return retour
        }else{
            let lesUtilisateurs : [Utilisateur]? = nil
            return lesUtilisateurs // renvoi nil si le fichier n'existe pas
        }
    }
    
    // vérifie que le nouvNomUser n'est pas nil ou deja pris 
    public static func nomPossible(_ tabUsers : [Utilisateur] ,_ nouvNomUser : String? ) -> Bool {
        if ( nouvNomUser == nil ){
            return false
        }
        for unUtilisateur in tabUsers {
            if( unUtilisateur.nomUtilisateur == nouvNomUser ){
                return false
            }
        }
        return true
    }
    
    // renvoi toutes les données de l'instance dans un String formaté
    public func getNomFormate() -> String{
        let chaine : String = nomUtilisateur.filter { $0.isLetter || "0"..."9" ~= $0 }
        return chaine
    }
    
}
