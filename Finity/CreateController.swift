//
//  CreateController.swift
//  Finity
//
//  Created by Casey Chin on 4/17/24.
//

import UIKit

class CreateController: UIViewController {
    
    let minPriority = 1
    
    let maxPriority = 100
    
    let defaultPriority = 50
    
    
    @IBOutlet weak var taskName: UITextField!
    
    @IBOutlet weak var taskDescription: UITextField!
    
    @IBOutlet weak var Slider: UISlider!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    @IBAction func enterTask(_ sender: Any) {
        
        
        if (taskName.text == "") {
            
            presentAlert(title: "Oops...", message: "Make sure to add a title!")
            return
            
        }
        
                 
        let task = Task(title: taskName.text!, description: taskDescription.text!, date: datePicker.date, priority: Int(Slider.value))
            
        task.save()
        reset()
        
        
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    
    private func reset() {
        
        taskName.text = ""
        taskDescription.text = ""
        Slider.setValue(Float(defaultPriority), animated: false)
        datePicker.date = Date()
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    private func presentAlert(title: String, message: String) {
        // 1.
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert)
        // 2.
        let okAction = UIAlertAction(title: "OK", style: .default)
        // 3.
        alertController.addAction(okAction)
        // 4.
        present(alertController, animated: true)
    }

}
