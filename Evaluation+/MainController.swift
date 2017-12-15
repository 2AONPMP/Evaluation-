//
//  ViewController.swift
//  Evaluation+
//
//  Created by eleves on 17-11-20.
//  Copyright © 2017 eleves. All rights reserved.
//
//---------------------
import UIKit
import Foundation
//---------------------
class MainController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    //---------------------
    @IBOutlet weak var student_name_tableview: UITableView!
    @IBOutlet weak var student_name_field: UITextField!
    //---------------------
    
    let saveDataObj = UserDefaultsManager()
    
    //---------------------
    typealias studentName = String
    typealias courseName = String
    typealias gradeCourse = Double
    //---------------------
    
    var studentGrades: [studentName: [courseName: gradeCourse]]!
    
    //---------------------
    
    override func viewDidLoad() {
            super.viewDidLoad()
            loadUserDefaults()
    }
    
    //---------------------
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return studentGrades.count
    }
    
    //---------------------
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.default,
                                                        reuseIdentifier: nil)
            cell.textLabel?.text = [studentName](studentGrades.keys)[indexPath.row]
            return cell
    }
    
    //------ Fonction pour effacer
    
    func tableView(_ tableView: UITableView, commit editinsStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
            if editinsStyle == UITableViewCellEditingStyle.delete {
                let name = [studentName](studentGrades.keys)[indexPath.row]
                studentGrades[name] = nil
                saveDataObj.setKey(theValue: studentGrades as AnyObject, theKey: "gradeCourse")
                tableView.deleteRows(at: [indexPath as IndexPath], with: UITableViewRowAnimation.automatic)
            }
    }
    
    //------ Fonction pour continuer dans la deuxieme page
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let name = [studentName](studentGrades.keys)[indexPath.row]
            saveDataObj.setKey(theValue: name as AnyObject, theKey: "name")
            performSegue(withIdentifier: "seg", sender: nil)
    }
    
   //---------------------
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
    }
    
    //---------------------
    
    func loadUserDefaults() {
        if saveDataObj.doesKeyExist(theKey: "gradeCourse") {
                studentGrades = saveDataObj.getValue(theKey: "gradeCourse") as! [studentName: [courseName: gradeCourse]]
        } else {
            studentGrades = [studentName: [courseName: gradeCourse]]()
        }
    }
    
    //---------------------
    
    @IBAction func addstudent(_ sender: UIButton) {
        if student_name_field.text != "" {
            studentGrades[student_name_field.text!] = [courseName: gradeCourse]()
            student_name_field.text = ""
            saveDataObj.setKey(theValue: studentGrades as AnyObject, theKey: "gradeCourse")
            student_name_tableview.reloadData()
            }
        }
    
    //------ Fonction pour clavier
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            view.endEditing(true)
    }
}
  



