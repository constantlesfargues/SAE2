import Foundation

class Flux : Codable{
    
    public var nomFlux : String
    public var montantFlux : Float
    public var typeFlux : String
    public var dateFlux : Date
    public var groupesFlux : [Groupe]
    
    // seulement si il est récurent
    public var frequenceFlux : Int // = 0 si non récurent
    public var dureeFlux : Int
    
    
    // sauvegarde les Flux donnés (dans le fichier "<nom utilisateur>Flux.json")
    public static func ecrireFlux(_ user : Utilisateur ,_ lesFlux : [Flux] ) {
        // récupere l'url du fichier
        let leFileManager = FileManager.default
        let urls = leFileManager.urls(for: .documentDirectory ,in: .userDomainMask )
        let urlFichier = urls.first!.appendingPathComponent( "\(user.nomUtilisateur)Flux.json" )
        
        // encode les Fluxs
        let objJSONEncodeur = JSONEncoder()
        let donneesASauvegarder = try? objJSONEncodeur.encode( lesFlux )
        
        // crée/écrit dans le fichier
        leFileManager.createFile(atPath : urlFichier.path, contents : donneesASauvegarder, attributes : nil)
    }
    
    // renvoi les Flux lus (dans le fichier "<nom utilisateur>Flux.json")
    public static func lireFlux(_ user : Utilisateur) -> [Flux]? {
        // récupere l'url du fichier
        let leFileManager = FileManager.default
        let urls = leFileManager.urls(for: .documentDirectory ,in: .userDomainMask )
        let urlFichier = urls.first!.appendingPathComponent( "\(user.nomUtilisateur)Flux.json" )
        
        // si le fichier existe
        if ( leFileManager.fileExists(atPath : urlFichier.path) ) {
            
            let data = try! Data( contentsOf : urlFichier )// charge le fichier
            
            let decoder = JSONDecoder( )
            let retour = try! decoder.decode( [Flux].self , from : data )// décode en objet de la classe
            
            return retour
        }else{
            let lesFlux : [Flux]? = nil
            return lesFlux // renvoi nil si le fichier n'existe pas
        }
    }
    
    // renvoi toutes les données de l'instance dans un String formaté
    public func enChaine() -> String{
        var chaine : String
        if ( frequenceFlux == 0 ){
            chaine = "\(nomFlux) ( \(typeFlux) ) : \(montantFlux) [\(dateFlux.formatted())] groupes : "
        }else{
            chaine = "\(nomFlux) ( \(typeFlux) ) : \(montantFlux) [\(dateFlux.formatted())] récurent f=\(frequenceFlux) jusqu'a \(dureeFlux) groupes :"
        }
        for groupe in groupesFlux{
            chaine.append("\(groupe.enChaine()),")
        }
        return chaine
    }
    
}
