//
//  TodosVC.swift
//  TO DO List APP
//
//  Created by ahmed rabie on 24/11/2022.
//

import UIKit
import CoreData

class TodosVC: UIViewController {

    //var todosArr = [ Todo(title: "Goto the school", image: UIImage(named: "Image-1"),details: "iam going to school because my team will play in the league"), Todo(title: "Doing homwork", image: UIImage(named: "Image-2")), Todo(title: "Studing my lessons"), Todo(title: "Watching TV", image: UIImage(named: "Image-3")), Todo(title: "Go to the club", image: UIImage(named: "Image-4"))]
    
    //comment
    
    var todosArr : [Todo] = []
    @IBOutlet weak var todosTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.todosArr = getTodoFromCoreData()
        
        // recieve notification which add new todo
        NotificationCenter.default.addObserver(self, selector: #selector(addNewTaskNotification(notific:)), name: NSNotification.Name(rawValue: "NewTaskTodoAdded"), object: nil)
        
        // recieve notification which edit todo
        NotificationCenter.default.addObserver(self, selector: #selector(updateTodoAfterEditing(recieve:)), name: NSNotification.Name(rawValue: "CurrentTodoEdited"), object: nil)
        
        // recieve notification which delete todo
        NotificationCenter.default.addObserver(self, selector: #selector(deleteTodo(deleteNotification:)), name: NSNotification.Name(rawValue: "DeleteTodo"), object: nil)
        
        todosTableView.dataSource = self
        todosTableView.delegate = self
        
        //todosTableView.tableFooterView = UIView()
    }
    
    @objc func addNewTaskNotification(notific: Notification){
        print("hello in adding new todo")
        if let newTodo = notific.userInfo?["addedTask"] as? Todo{
            todosArr.append(newTodo)
            todosTableView.reloadData()
            storeTodo(todo: newTodo)
        }
        //print(notific.userInfo? ["addedTask"])
        print("Added done")
        }
    
    @objc func updateTodoAfterEditing(recieve: Notification){
        print("hello in update Todo in TodosVC")
        if let updatedTodo = recieve.userInfo?["UpdateTodoEdited"] as? Todo{
            if let indexx = recieve.userInfo?["EditedTodoIndex"] as? Int{
                todosArr[indexx] = updatedTodo
                todosTableView.reloadData()
                updateTodoInCoreData(todoUpdated: updatedTodo, index: indexx)
            }
          
        }
        print("Updated done")
    }
    
    @objc func deleteTodo(deleteNotification: Notification){
        print("warning you deleted this Todo from TodosVC")
        if let removeIndex = deleteNotification.userInfo?["deletedTodoIndex"] as? Int{
         todosArr.remove(at: removeIndex)
         todosTableView.reloadData()
            deletingTodoFromCoreData(index: removeIndex)
            print("Deleted Done")
        }
    }
    
    //func storeTodoInCoreData
    func storeTodo(todo: Todo){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{return}
        let managedContext = appDelegate.persistentContainer.viewContext
        guard let todoEntity = NSEntityDescription.entity(forEntityName: "TodoData", in: managedContext) else {return}
        let todoObject = NSManagedObject.init(entity: todoEntity, insertInto: managedContext)
        todoObject.setValue(todo.title, forKey: "title")
        todoObject.setValue(todo.details, forKey: "details")
        
        if let photo = todo.image {
           // let photoCoreData = photo.jpegData(compressionQuality: 0.8)
            let photoCoreData = photo.pngData()
            todoObject.setValue(photoCoreData, forKey: "image")
        }

        do {
            try managedContext.save()
            print("-----------success------------")
        } catch{
            print("********--------error saving in CoreData----------******")
        }

    }
    
    //func retrieveDataFromCoreData()
    func getTodoFromCoreData() -> [Todo]{
        var todos : [Todo] = []
        
        guard let appDelgateRetrive = UIApplication.shared.delegate as? AppDelegate else {return []}
        let context = appDelgateRetrive.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TodoData")
        do {
            let resultData = try context.fetch(fetchRequest) as! [NSManagedObject]
            for managedTodo in resultData {
                let titleCore = managedTodo.value(forKey: "title") as? String
                let detailsCore = managedTodo.value(forKey: "details") as? String
                var imageCore : UIImage? 
                if let imageFromContext = managedTodo.value(forKey: "image") as? Data {
                     imageCore = UIImage(data: imageFromContext)
                }
                let todoCore = Todo(title: titleCore!, image: imageCore, details: detailsCore)
                todos.append(todoCore)
            }
        } catch {
            print("*************error in retrive data from coreData*****************")
        }
        
        return todos
    }
    
    //func updateDataAfterEditInCoreData()
    func updateTodoInCoreData(todoUpdated: Todo, index: Int){
        
        guard let appDelgateUpdate = UIApplication.shared.delegate as? AppDelegate else {return}
        let updateContext = appDelgateUpdate.persistentContainer.viewContext
        let fetchRequestUpdate = NSFetchRequest<NSFetchRequestResult>(entityName: "TodoData")
        do {
            let resultDataUpdated = try updateContext.fetch(fetchRequestUpdate) as! [NSManagedObject]
            resultDataUpdated[index].setValue(todoUpdated.title, forKey: "title")
            resultDataUpdated[index].setValue(todoUpdated.details, forKey: "details")
            if let photo = todoUpdated.image {
                let imageCoreData = photo.pngData()
                resultDataUpdated[index].setValue(imageCoreData, forKey: "image")
            }
            try updateContext.save()
        
        }
        catch {
            print("************* Error in Update data in coreData *****************")
        }
    }
    
    //func deleteTodoFromCoreData()
    func deletingTodoFromCoreData(index: Int){
        guard let appDelgate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelgate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TodoData")
        
        do {
            let result = try context.fetch(fetchRequest) as! [NSManagedObject]
            let todoToDelete = result[index]
            context.delete(todoToDelete)
            
            try context.save()
        }catch{
            print("****** Error in deleting todo from core data ********")
        }
    }
    
//    @objc func deleteTodo(deleteNotification: Notification){
//        print("warning you deleted this Todo from TodosVC")
//
//         let alertDelete = UIAlertController(title: "Attention", message: "Are you sure to delete the todo", preferredStyle: .alert)
//         let deleteButton = UIAlertAction(title: "Delete", style: .destructive) { action in
//            if let removeIndex = deleteNotification.userInfo?["deletedTodoIndex"] as? Int{
//                self.todosArr.remove(at: removeIndex)
//                self.todosTableView.reloadData()
//                self.navigationController?.popViewController(animated: true)
//            }
//
//    }
//        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
//         alertDelete.addAction(deleteButton)
//        alertDelete.addAction(cancelButton)
//        present(alertDelete, animated: true)
//
//
//        print("Deleted Done")
//        }
    
    
}
extension TodosVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todosArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCellID", for: indexPath) as? TodoCell {
            cell.todoTitleLabel.text = todosArr[indexPath.row].title
            if todosArr[indexPath.row].image != nil {
                cell.todoImageView.image = todosArr[indexPath.row].image
            }else{
               // cell.todoImageView.image = UIImage(systemName: "pencil.circle.fill")
                cell.todoImageView.image = UIImage(systemName:"square.and.pencil")
            }
            cell.todoImageView.layer.cornerRadius = cell.todoImageView.frame.width / 2
            return cell
        }
          
          return UITableViewCell()
    }
        
}

extension TodosVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let newTodo = todosArr[indexPath.row]
        if let detailsTodoVC = storyboard?.instantiateViewController(withIdentifier: "TodoDetailsVCID") as? TodoDetailsVC
        {
            detailsTodoVC.todo = newTodo
            detailsTodoVC.currentIndex = indexPath.row
            navigationController?.pushViewController(detailsTodoVC, animated: true)
            //present(detailsTodoVC, animated: true, completion: nil)
        }
    }
}
