import Foundation

class Flux : Codable, Identifiable{
    
    public var nomFlux : String
    public var montantFlux : Float
    public var typeFlux : String
    public var dateFlux : Date
    public var groupesFlux : [Groupe]
    
    // seulement si il est récurent
    public var frequenceFlux : Int // = 0 si non récurent
    public var dureeFlux : Int = 0
    
    public init( nomFlux: String, montantFlux: Float, typeFlux: String, dateFlux: Date, groupesFlux: [Groupe], frequenceFlux: Int, dureeFlux: Int) {
        self.nomFlux = nomFlux
        self.montantFlux = montantFlux
        self.typeFlux = typeFlux
        self.dateFlux = dateFlux
        self.groupesFlux = groupesFlux
        self.frequenceFlux = frequenceFlux
        self.dureeFlux = dureeFlux
    }
    
    // Sauvegarde les flux dans le fichier "<nom utilisateur>Flux.json"
    public static func ecrireFlux(_ user: Utilisateur, _ lesFlux: [Flux]) {
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let fileURL = urls.first!.appendingPathComponent("\(user.getNomFormate())Flux.json")
        
        let encoder = JSONEncoder()
        if let dataToSave = try? encoder.encode(lesFlux) {
            fileManager.createFile(atPath: fileURL.path, contents: dataToSave, attributes: nil)
        }
    }
    
    // Renvoie les flux lus depuis "<nom utilisateur>Flux.json"
    public static func lireFlux(_ user: Utilisateur) -> [Flux]? {
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let fileURL = urls.first!.appendingPathComponent("\(user.getNomFormate())Flux.json")
        
        guard fileManager.fileExists(atPath: fileURL.path),
              let data = try? Data(contentsOf: fileURL),
              let flux = try? JSONDecoder().decode([Flux].self, from: data)
        else {
            return nil
        }
        
        return flux
    }
    
    // renvoi toutes les données de l'instance dans un String formaté
    public func enChaine() -> String{
        var chaine : String
        if typeFlux == "entree"{
            typeFlux = "Entrée"
        }
        else if typeFlux == "sortie"{
            typeFlux = "Sortie"
        }
        else{
            
        }
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
