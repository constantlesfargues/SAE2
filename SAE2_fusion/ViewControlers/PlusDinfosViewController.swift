//
//  PlusDinfosViewController.swift
//  SAE2_fusion
//
//  Created by etudiant on 12/05/2025.
//

import UIKit

class PlusDinfosViewController: UIViewController {
    
    @IBOutlet weak var choixUserSC: UISegmentedControl!
    @IBOutlet weak var infosLB: UILabel!

        
    func editText(){
        var leChoix : Int = choixUserSC.selectedSegmentIndex
        
        switch leChoix{
        case 0:
            infosLB.text = "La page Historique est la page principale de l'application.\nVous pourrez y retrouver la totalité des flux enregistrés sur votre profil sur cette page, accompagnés de leurs caractéristiques propres.\nVous pourrez appliquer des filtres sur cette page en appuyant sur le bouton 'Filtrer la sélection', ou encore en supprimer en cliquant sur le bouton 'Supprimer' et en sélectionnant les flux que vous voulez voir disparaître."
            break
        case 1:
            infosLB.text = "La page Ajout est une page très importante pour l'application.\nElle vous permet de créer autant de flux que vous voulez, afin de pouvoir suivre le plus précisément possible vos dépenses et entrées d'argent.\nVous devrez choisir un nom puis un montant pour le flux, puis la date de ce dernier. Ensuite, vous pourrez choisir si votre flux pourra se répéter plusieurs fois (par exemple un salaire sera un flux récurrent se produisant tous les mois), et vous pourrez finalement créer un groupe dans lequel votre flux pourra se trouver.\nAinsi, si vous souhaitez regrouper l'intégralité de vos dépenses pour vos sorties au restaurant, il vous suffira de cliquer sur le '+' après avoir rentré le mot 'restaurant' à chaque fois, et votre flux sera enregistré dans ce groupe."
            break
        case 2:
            infosLB.text = "La page Statistiques est un atout majeur de notre application.\nElle vous permet de créer et visualiser un ensemble de statistiques personnalisées pour visualiser et analyser vos dépenses, où vous voulez et quand vous voulez.\nEn cliquant sur le bouton '+', vous trouverez une page de création de statistique. Il vous suffira de rentrer le type de statistique que vous souhaitez obtenir, et ensuite préciser si vous voulez appliquer des filtres sur des caractéristiques particulières pour n'obtenir que les flux récurrents par exemple. Après avoir cliqué sur 'effectuer', vous pourrez retourner sur la page Statistiques.\nEnsuite, il ne vous faudra plus qu'à cliquer sur la flèche en haut à gauche pour recharger la page et vous pourrez visualiser la statistique que vous viendrez de créer. Si vous souhaitez classer vos statistiques avec un nom particulier, vous pourrez rentrer leur nom en cliquant sur la loupe en haut à gauche de votre écran."
            break
        case 3:
            infosLB.text = "La page Paramètres est celle d'où vous venez. C'est la page qui permet le fonctionnement de l'application, car c'est elle qui gère l'ensemble des profils existants sur votre application. Vous pourrez créer un profil en cliquant sur l'icone '+', renseigner son nom, puis une fois le profil rajouté, il vous suffira de le sélectionner sur la liste juste au dessus, puis de cliquer sur le bouton 'Sélectionner' pour pouvoir créer des flux et les visualiser sur ce profil.\nEn effet, si vous ajoutez des flux dans un profil, et que vous souhaitez changer de profil, en sélectionnant un autre profil vous ne pourrez plus voir les flux du dernier profil sur lequel vous étiez, à moins de le resélectionner comme profil principal.\nVous pourrez également, pour votre confort visuel, adapter l'application en appliquant le mode sombre. Pour cela, vous cliquez sur le bouton 'Mode sombre' et ensuit 'Appliquer' et le tour est joué!"
            break
        case 4:
            infosLB.text = "La page assistant est un générateur de plan d'épargne généré par IA. Ils vous suffit de rentrer les données demandées, puis l'app vous génére un rapport complet. Attention, il faut prendre des pincettes avant de passer à l'action."
            break
        default:
            break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        editText()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func tapSurSC(_ sender: Any) {
        editText()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
