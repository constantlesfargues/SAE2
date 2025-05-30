//
//  AppDelegate.swift
//  SAE2
//
//  Created by etudiant on 24/03/2025.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // debut alex
    public static var stats: [Stat] = []
    
    public static func getTags()->[String] {
        var tags : Set<String> = []
        for stat in stats {
            if let tag = stat.tag {
                tags.insert(tag)
            }
        }
        var tagsArr = Array(tags)
        tagsArr.insert("tous",at:0)
        return tagsArr
    }
    
    public static func removeStat(id:Int) {
        for i in 0..<stats.count {
            if id == stats[i].id {
                stats.remove(at:i)
                break
            }
        }
    }
    
    public static func modifierStat(_ id:Int,_ stat:Stat) {
        for i in 0..<stats.count {
            if id == stats[i].id {
                stats[i] = stat
                return
            }
        }
    }
    
    public static var statIndex:Int = 0
    // fin alex
    
    // Les Utilisateurs
    // le premier ( AppDelegate.users[0] ) est celui actuelement utilisé
    public static var users : [Utilisateur] = [Utilisateur("default")]
    
    // Parametres de l'utilisateur actuel
    public static var param : Parametres = Parametres()
    
    // Données de l'utilisateur actuel
    public static var fluxs : [Flux] = []
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        sleep(1)
        // récupere les Utilisateurs dans le JSON
        let utilisateursLu = Utilisateur.lireUtilisateur()
        if ( utilisateursLu != nil ){
            AppDelegate.users = utilisateursLu!
        }else{
            Utilisateur.ecrireUtilisateur(AppDelegate.users)
        }
        
        // récupere les données (Fluxs, Parametres) de l'utilisateur actuel
        AppDelegate.updateDonneesUser()
        
        SceneDelegate.actualiserModeCouleur()
        
        return true
    }
    
    public static func updateDonneesUser(){
        // récupere les parametres dans le JSON de l'utilisateur
        // crée le fichier avec les parametres de base si il n'existe pas
        let parametresLu = Parametres.lireParam(AppDelegate.users[0])
        if ( parametresLu != nil ){
            AppDelegate.param = parametresLu!
        }else{
            Parametres.ecrireParam(AppDelegate.users[0], AppDelegate.param)
        }
        
        // récupere les Fluxs dans le JSON de l'utilisateur
        // crée le fichier avec aucuns Fluxs si il n'existe pas
        let fluxsLu = Flux.lireFlux(AppDelegate.users[0])
        if ( fluxsLu != nil ){
            AppDelegate.fluxs = fluxsLu!
        }else{
            Flux.ecrireFlux(AppDelegate.users[0], AppDelegate.fluxs)
        }
        let statsLu = Stat.lireFlux(AppDelegate.users[0])
        if ( statsLu != nil ){
            AppDelegate.stats = statsLu!
        }else{
            Stat.ecrireStats(AppDelegate.users[0], AppDelegate.stats)
        }
    }
    
    // écrit les données actuelles sur le JSON
    public static func actualiserJSON(){
        Flux.ecrireFlux(AppDelegate.users[0], fluxs)
        Parametres.ecrireParam(AppDelegate.users[0], param)
        Stat.ecrireStats(AppDelegate.users[0], stats)
        // rajouter les stat
    }
    
    public static func changeUtilisateur(_ indiceUtilisateur : Int){
        // change le premier utilisateur dans la liste users
        let userCo : Utilisateur = AppDelegate.users.remove(at: indiceUtilisateur)// supr & recup l'user voulu
        AppDelegate.users.insert(userCo, at: 0)// le place en premiere position
        Utilisateur.ecrireUtilisateur(AppDelegate.users)// actualise le JSON
        
        AppDelegate.updateDonneesUser()// récupere les données du nouveau utilisateur sélectioné
    }
    
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "SAE2")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}
