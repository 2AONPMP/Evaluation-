
// -----------------------
import UIKit
import Foundation
// -----------------------

class CreatorController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
   
    //----------------------
    
    let saveDataObj  = UserDefaultsManager()
    
    //---------------------
   
    @IBOutlet weak var student_name_label: UILabel!
    @IBOutlet weak var course_field: UITextField!
    @IBOutlet weak var grade_field: UITextField!
    
   //----------------------
 
    @IBOutlet weak var criteriaTableView: UITableView!
    
    //----------------------
    
    @IBOutlet weak var average: UILabel!
    
    //-----------------------
   
    typealias studentName = String
    typealias courseName = String
    typealias gradeCourse = Double
   
   //----------------------
    
    var studentGrades: [studentName: [courseName: gradeCourse]]!
    var arrayOfCourses: [courseName]!
    var arrayOfGrades: [gradeCourse]!
    
    //----------------------
   
    override func viewDidLoad(){
        super.viewDidLoad()
        student_name_label.text = saveDataObj.getValue(theKey: "name") as? String
        loadSavedData()
        saveData()
        average.text = verifierAverage(dictionnaireNotes: moyenneNotes(), ruleOfThree: {$0 * 100.0 / $1})
    }
    
    //----------------------
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfCourses.count
        
    }
    
    //---------------------
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = criteriaTableView.dequeueReusableCell(withIdentifier: "criteriaCell")!
        
        if let aCourse = cell.viewWithTag(100) as! UILabel! {
            aCourse.text = arrayOfCourses[indexPath.row]
        }
        //Afficher les elements de le tableau
        if let aGrade = cell.viewWithTag(101) as! UILabel! {
            aGrade.text = String(arrayOfGrades[indexPath.row])
        }
        return cell
    }
 
    //------ Fonction pour effacer la grade et note
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
    
    //---------------------
    
    func loadSavedData() {
        if saveDataObj.doesKeyExist(theKey: "gradeCourse") {
            studentGrades = saveDataObj.getValue(theKey: "gradeCourse") as! [studentName: [courseName: gradeCourse]]
        } else {
            studentGrades = [studentName: [courseName: gradeCourse]]()
        }
    }
    
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

    //---------------------
    func saveData() {
        let name = student_name_label.text
        let courses_and_grades = studentGrades[name!]
        arrayOfCourses = [courseName](courses_and_grades!.keys)
        arrayOfGrades = [gradeCourse](courses_and_grades!.values)
    }
    
    //------------------ Function Average
    func verifierAverage(dictionnaireNotes: [Double: Double], ruleOfThree: (_ somme: Double, _ sur: Double) -> Double) -> String{
        
        let sommeNotes = [Double](dictionnaireNotes.keys).reduce(0, +)
        let sommesur = [Double](dictionnaireNotes.values).reduce(0, +)
        let conversion = ruleOfThree(sommeNotes, sommesur)
        return String(format: "%0.1f/%0.1f or %0.1f/100", sommeNotes, sommesur, conversion)
        
    }
    
    //-----------------
    
    func averageNotes(tableauDeNotes: [Double], moyenne: (_ sum: Double, _ nombreDeNotes: Double) -> Double) -> Double {
        let somme = tableauDeNotes.reduce(0, +)
        let resultat = moyenne(somme, Double(tableauDeNotes.count ))
        return resultat
    }
    
    //-----------------
    
    func moyenneNotes() ->  [Double: Double] {
        let average = arrayOfGrades.reduce(0, +)
        let somme = arrayOfGrades.count
        let moyenneNotes = Double(average/Double(somme))
        let dictionnaireGrades = [moyenneNotes: 10.0]
        return dictionnaireGrades
    }

    //------ Fonction pour clavier
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

}
