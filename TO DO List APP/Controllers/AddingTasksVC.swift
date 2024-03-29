//
//  AddingTasksVC.swift
//  TO DO List APP
//
//  Created by ahmed rabie on 27/11/2022.
//

import UIKit
import AlertController
class AddingTasksVC: UIViewController {
    var isCreation = true
    var editedTodo : Todo?
    var editedTodoIndex : Int?
    
    @IBOutlet weak var changeOrAddPhotoBtn: UIButton!
    @IBOutlet weak var todoImageView: UIImageView!
    @IBOutlet weak var editOrAddButton: UIButton!
    @IBOutlet weak var taskTitleTextField: UITextField!
    @IBOutlet weak var taskDetailsTV: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if !isCreation  {
            editOrAddButton.setTitle("SaveEditing", for: .normal)
            changeOrAddPhotoBtn.setTitle("ChangePhoto", for: .normal)
            navigationItem.title = "Editig Task"
            
            if let todoBeforeEdit = editedTodo {
                taskTitleTextField.text = todoBeforeEdit.title
                taskDetailsTV.text = todoBeforeEdit.details
                todoImageView.image = todoBeforeEdit.image
            }
        } else{
            
        }
    }
    
    
    @IBAction func changePhotoButton(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    @IBAction func addButton(_ sender: Any) {
        if isCreation {
          if let taskTitle = taskTitleTextField.text {
              let todoTask = Todo(title: taskTitle, image: todoImageView.image, details: taskDetailsTV.text)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NewTaskTodoAdded"), object: nil, userInfo: ["addedTask": todoTask])
            }
            //showAlert(alertTitle: "Adding New Todo", alertMessage: "successfully adding of new Todo")
            showSuccessAlert(msg: "Your Todo has been added successfully")
        }else{
            //edit the Todo
            let todoAfterEdit = Todo(title: taskTitleTextField.text!, image: todoImageView.image, details: taskDetailsTV.text)
            let alert = UIAlertController.alert()
            alert.setTitle("📝 Editing", color: .systemRed)
            alert.setMessage("Are you sure to save the changes?")
            alert.addAction(
                title: "Cancel",
                //systemIcon: "checkmark.bubble"
                color: .systemBlue ){
                    self.navigationController?.popViewController(animated: true)
                }
            
            alert.addAction(
                       title: "Save",
                       //systemIcon: "checkmark.bubble"
                       color: .systemRed
                       )
            {
                 let newAlert = UIAlertController.alert()
                   newAlert.setTitle("✅ Success", color: .systemMint)
                   newAlert.setMessage("Your Todo has been Edited successfully")
                   newAlert.addAction(
                        title: "Ok",
                        //systemIcon: "checkmark.bubble"
                        color: .systemBlue ){
                        self.navigationController?.popViewController(animated: true)
                               }
                   self.present(newAlert, animated: true)
                 NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CurrentTodoEdited"), object: nil, userInfo: ["UpdateTodoEdited": todoAfterEdit, "EditedTodoIndex": self.editedTodoIndex! ])
                           
                  self.navigationController?.popViewController(animated: true)
                   }
            present(alert, animated: true)
          
        }
           
        
    }
    
    func showAlert (alertTitle: String, alertMessage: String){
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        let okAlertButton = UIAlertAction(title: "ok", style: .default) { action in
            //self.goToNextView(vcID: "TodosVC")
             self.tabBarController?.selectedIndex = 0
            self.taskTitleTextField.text = ""
        }
        alert.addAction(okAlertButton)
        present(alert, animated: true)
    }
    func showSuccessAlert(msg: String){
        let alert = UIAlertController.alert()
        alert.setTitle("✅ Success", color: .systemMint)
        alert.setMessage(msg)

        alert.addAction(
                   title: "Ok",
                   //systemIcon: "checkmark.bubble"
                   color: .systemBlue
                   ) {
                    self.tabBarController?.selectedIndex = 0
                  self.taskTitleTextField.text = ""
                   
               }
        present(alert, animated: true)
    }
    
}

extension AddingTasksVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedPhoto = info[.editedImage] as? UIImage {
            todoImageView.image = pickedPhoto
            dismiss(animated: true)
        } else {
            print("error Photo")
        }
      
    }
}

