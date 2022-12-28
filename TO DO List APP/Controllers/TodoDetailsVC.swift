//
//  TodoDetailsVC.swift
//  TO DO List APP
//
//  Created by ahmed rabie on 24/11/2022.
//

import UIKit
import AlertController
class TodoDetailsVC: UIViewController {

    @IBOutlet weak var todoSubjectDetailsLabel: UILabel!
    @IBOutlet weak var todoTitleDetailsLabel: UILabel!
    @IBOutlet weak var todoImageDetails: UIImageView!
    var todo: Todo!
    var currentIndex : Int!
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUpdateTodoDetails()
        
        if todo.image != nil {
            todoImageDetails.image = todo.image
        }else{
          // todoImageDetails.image = UIImage(systemName: "doc.plaintext.fill")
        }
        
        
        
        //here we recieve the notification in view of details
        NotificationCenter.default.addObserver(self, selector: #selector(updateTodoAfterEditingInDetails(recieve:)), name: NSNotification.Name(rawValue: "CurrentTodoEdited"), object: nil)
    }
    
    @objc func updateTodoAfterEditingInDetails(recieve: Notification){
        print("hello in update Todo in TodoDetailsVc")
        if let updatedTodoDetails = recieve.userInfo?["UpdateTodoEdited"] as? Todo{
            todo = updatedTodoDetails
            self.setUpUpdateTodoDetails()
            }
          
       
        print("done")
    }
   func setUpUpdateTodoDetails(){
       todoTitleDetailsLabel.text = todo.title
       todoSubjectDetailsLabel.text = todo.details
       todoImageDetails.image = todo.image
    }

    @IBAction func editTodoButton(_ sender: Any) {
        if let goToAddingTaskToEditVC = storyboard?.instantiateViewController(withIdentifier: "AddingTasksVC") as? AddingTasksVC {
            goToAddingTaskToEditVC.isCreation = false
            goToAddingTaskToEditVC.editedTodo = todo
            goToAddingTaskToEditVC.editedTodoIndex = currentIndex
            navigationController?.pushViewController(goToAddingTaskToEditVC, animated: true)
            
        }
    }
    
    @IBAction func deleteTodoButton(_ sender: Any) {
        let deleteAlert = UIAlertController.alert()
        deleteAlert.setTitle("⚠️Warning", color: .systemRed)
        deleteAlert.setMessage("Are you sure to delete this Todo?")
        deleteAlert.addAction(
            title: "Cancel",
            //systemIcon: "checkmark.bubble"
            color: .systemBlue ){
                //self.navigationController?.popViewController(animated: true)
            }
        deleteAlert.addAction(title: "Delete",
                              //systemIcon: "checkmark.bubble",
                              color: .systemRed){
            
          let newAlert = UIAlertController.alert()
              newAlert.setTitle("✅ Success", color: .systemMint)
              newAlert.setMessage("Your Todo has been Deleted successfully")
              newAlert.addAction(title: "Ok",//systemIcon: "checkmark.bubble"
                      color: .systemBlue ){
               self.navigationController?.popViewController(animated: true)
           }
            self.present(newAlert, animated: true)
             NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DeleteTodo"), object: nil, userInfo: ["deletedTodoIndex":self.currentIndex!])
                       
            self.navigationController?.popViewController(animated: true)
    }
           present(deleteAlert, animated: true)
                   
     /*   let alertDelete = UIAlertController(title: "Attention", message: "Are you sure to delete this todo", preferredStyle: .alert)
        let deleteButton = UIAlertAction(title: "Delete", style: .destructive) { deleteAction in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DeleteTodo"), object: nil, userInfo: ["deletedTodoIndex":self.currentIndex!])
            
            let alertSuccsessDelete = UIAlertController(title: "Delete Todo successfully", message: "you deleted this Todo successfuly", preferredStyle: .alert)
            let okBtn = UIAlertAction(title: "Ok", style: .default) { alert in
                self.navigationController?.popViewController(animated: true)
            }
            alertSuccsessDelete.addAction(okBtn)
            self.present(alertSuccsessDelete, animated: true)
        }
               
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
                alertDelete.addAction(deleteButton)
                alertDelete.addAction(cancelButton)
            present(alertDelete, animated: true)
      */
    }
  
}
