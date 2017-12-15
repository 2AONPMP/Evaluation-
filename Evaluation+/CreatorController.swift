
//--- Biblioteques du Xcode utilisées dans le code
// -----------------------
import UIKit
import Foundation
// -----------------------

//---Class CreatorController pour contrôler la vues dans le code
class CreatorController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
   
    //----------------------
    //--- Constante qui utilisera les fonctions du UserDefaultsManager()
    let saveDataObj  = UserDefaultsManager()
    
    //--- Outlet qui va lier à label nom de èléve et lier champs textField de course et grade
    //---------------------
    @IBOutlet weak var student_name_label: UILabel!
    @IBOutlet weak var course_field: UITextField!
    @IBOutlet weak var grade_field: UITextField!
    
    //--- Declaration de la tableview qui va garder l'informations du èléves
    //----------------------
    @IBOutlet weak var criteriaTableView: UITableView!
    
    //--- Declaration de champ pour la moyenne d'èléve
    //----------------------
    @IBOutlet weak var average: UILabel!
    
    //--- Typealias qui renommeront les variables
    //-----------------------
    typealias studentName = String
    typealias courseName = String
    typealias gradeCourse = Double
   
    //--- Tableaux qui contient le nom, le cours et la note de l'élève
    //----------------------
    var studentGrades: [studentName: [courseName: gradeCourse]]!
    var arrayOfCourses: [courseName]!
    var arrayOfGrades: [gradeCourse]!
    
    //---------------------
    //--- Section viewDidLoad pour initialisation supplémentaire sur les vues qui ont été chargées
    //----------------------
    override func viewDidLoad(){
        super.viewDidLoad()
        student_name_label.text = saveDataObj.getValue(theKey: "name") as? String
        loadSavedData()
        saveData()
        average.text = verifierAverage(dictionnaireNotes: moyenneNotes(), ruleOfThree: {$0 * 100.0 / $1})
    }
    
    //--- Fonction tableview qui indique à la source de données de renvoyer le nombre de lignes dans une section donnée d'une vue de table. Retourne à studentGrades
    //----------------------
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfCourses.count
        
    }
    
    //--- Fonction qui demande la source de données pour une cellule à insérer dans un emplacement particulier de la vue de table
    //---------------------
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = criteriaTableView.dequeueReusableCell(withIdentifier: "criteriaCell")!
        
        if let aCourse = cell.viewWithTag(100) as! UILabel! {
            aCourse.text = arrayOfCourses[indexPath.row]
        }
        if let aGrade = cell.viewWithTag(101) as! UILabel! {
            aGrade.text = String(arrayOfGrades[indexPath.row])
        }
        return cell
    }
 
    //------ Fonction pour effacer la grade et note
    //---------------------
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            let name = student_name_label.text
            
            var courses_and_grades = studentGrades[name!]!
            
            let note = [courseName](courses_and_grades.keys)[indexPath.row]
            
            courses_and_grades[note] = nil
            studentGrades[name!] = courses_and_grades
            
            saveDataObj.setKey(theValue: studentGrades as AnyObject, theKey: "gradeCourse")
            saveData()
            tableView.deleteRows(at: [indexPath as IndexPath], with: UITableViewRowAnimation.automatic)
        }
    }
    
    //--- Function pour garder les informations d'èléve
    //---------------------
    func loadSavedData() {
        if saveDataObj.doesKeyExist(theKey: "gradeCourse") {
            studentGrades = saveDataObj.getValue(theKey: "gradeCourse") as! [studentName: [courseName: gradeCourse]]
        } else {
            studentGrades = [studentName: [courseName: gradeCourse]]()
        }
    }
    
    //--- Bounton pour ajouter les informations disciplines et notes d'élève
    //---------------------
    @IBAction func addCriteriaButton(_ sender: UIButton) {
        let name = student_name_label.text!
        
        var student_courses = studentGrades[name]!
        
        student_courses[course_field.text!] = gradeCourse(grade_field.text!)
        studentGrades[name] = student_courses
        saveDataObj.setKey(theValue: studentGrades as AnyObject, theKey: "gradeCourse")
        
        saveData()
        criteriaTableView.reloadData()
        average.text = verifierAverage(dictionnaireNotes: moyenneNotes(), ruleOfThree: {$0 * 100 / $1})

    }

    //--- Fonction qui remplit la table avec les informations saisies par l'utilisateur
    //---------------------
    func saveData() {
        let name = student_name_label.text
        let courses_and_grades = studentGrades[name!]
        arrayOfCourses = [courseName](courses_and_grades!.keys)
        arrayOfGrades = [gradeCourse](courses_and_grades!.values)
    }
    
    //---Fonction Average pour consulter la moyenne
    func verifierAverage(dictionnaireNotes: [Double: Double], ruleOfThree: (_ somme: Double, _ sur: Double) -> Double) -> String{
        
        let sommeNotes = [Double](dictionnaireNotes.keys).reduce(0, +)
        let sommesur = [Double](dictionnaireNotes.values).reduce(0, +)
        let conversion = ruleOfThree(sommeNotes, sommesur)
        return String(format: "%0.1f/%0.1f or %0.1f/100", sommeNotes, sommesur, conversion)
        
    }
    
    //--- Fonction qui calcule les notes et les moyennes des étudiants
    //-----------------
    func averageNotes(tableauDeNotes: [Double], moyenne: (_ sum: Double, _ nombreDeNotes: Double) -> Double) -> Double {
        let somme = tableauDeNotes.reduce(0, +)
        let resultat = moyenne(somme, Double(tableauDeNotes.count ))
        return resultat
    }
    
    // Calcule la moyenne
    //-----------------
    func moyenneNotes() ->  [Double: Double] {
        let average = arrayOfGrades.reduce(0, +)
        let somme = arrayOfGrades.count
        let moyenneNotes = Double(average/Double(somme))
        let dictionnaireGrades = [moyenneNotes: 10.0]
        return dictionnaireGrades
    }

    //--- Fonction pour déclencher l'activité de retour du clavier
    //--------------------
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

}
