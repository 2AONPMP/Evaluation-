//
//  ViewController.swift
//  Evaluation+
//
//  Created by eleves on 17-11-20.
//  Copyright © 2017 eleves. All rights reserved.
//
//--- Biblioteques du Xcode utilisées dans le code
//---------------------
import UIKit
import Foundation
//---------------------

//---Class viewController pour contrôler la vues dans le code
//---------------------
class MainController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    //--- Outlet qui va lier à tableView et textField
    //---------------------
    @IBOutlet weak var student_name_tableview: UITableView!
    @IBOutlet weak var student_name_field: UITextField!
    //---------------------
    
    //--- Constante qui utilisera les fonctions du UserDefaultsManager()
    let saveDataObj = UserDefaultsManager()
    
    //--- Typealias qui renommeront les variables
    //---------------------
    typealias studentName = String
    typealias courseName = String
    typealias gradeCourse = Double
    //---------------------
    
    //--- Tableau de dictionaires studentGrades qui contient le nom, le cours et la note de l'élève
    //---------------------
    var studentGrades: [studentName: [courseName: gradeCourse]]!
    
    //--- Section viewDidLoad pour initialisation supplémentaire sur les vues qui ont été chargées
    //---------------------
    override func viewDidLoad() {
            super.viewDidLoad()
            loadUserDefaults()
    }
    
    //--- Fonction tableview qui indique à la source de données de renvoyer le nombre de lignes dans une section donnée d'une vue de table. Retourne à studentGrades
    //---------------------
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return studentGrades.count
    }
    
    //--- Fonction qui demande la source de données pour une cellule à insérer dans un emplacement particulier de la vue de table
    //---------------------
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.default,
                                                        reuseIdentifier: nil)
            cell.textLabel?.text = [studentName](studentGrades.keys)[indexPath.row]
            return cell
    }
 
    //--- Fonction pour effacerla cell du tableView. Le contrôle d'édition utilisé par une cellule
    //---------------------
    func tableView(_ tableView: UITableView, commit editinsStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
            if editinsStyle == UITableViewCellEditingStyle.delete {
                let name = [studentName](studentGrades.keys)[indexPath.row]
                studentGrades[name] = nil
                saveDataObj.setKey(theValue: studentGrades as AnyObject, theKey: "gradeCourse")
                tableView.deleteRows(at: [indexPath as IndexPath], with: UITableViewRowAnimation.automatic)
            }
    }
    
    //--- Fonction pour continuer dans la deuxieme page, le indentifier est la nom "seg"
    //---------------------
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let name = [studentName](studentGrades.keys)[indexPath.row]
            saveDataObj.setKey(theValue: name as AnyObject, theKey: "name")
            performSegue(withIdentifier: "seg", sender: nil)
    }
    
    //--- Renvoyer la valeur du textField comme vraie
    //---------------------
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
    }
    
    //--- Function pour garder les qui contient le nom, le cours et la note de l'élève
    //---------------------
    func loadUserDefaults() {
        if saveDataObj.doesKeyExist(theKey: "gradeCourse") {
                studentGrades = saveDataObj.getValue(theKey: "gradeCourse") as! [studentName: [courseName: gradeCourse]]
        } else {
            studentGrades = [studentName: [courseName: gradeCourse]]()
        }
    }
    
    
    //--- Bounton pour ajouter les informations d'élève
    //---------------------
    @IBAction func addstudent(_ sender: UIButton) {
        if student_name_field.text != "" {
            studentGrades[student_name_field.text!] = [courseName: gradeCourse]()
            student_name_field.text = ""
            saveDataObj.setKey(theValue: studentGrades as AnyObject, theKey: "gradeCourse")
            student_name_tableview.reloadData()
            }
        }
    
    //--- Fonction pour déclencher l'activité de retour du clavier
    //--------------------
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            view.endEditing(true)
    }
}
  



