//
//  TodoStorage.swift
//  TO DO List APP
//
//  Created by ahmed rabie on 22/12/2022.
//

import Foundation
import UIKit
import CoreData

class TodoStorage{
    
    //func storeTodoInCoreData
   static func storeTodo(todo: Todo){
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
   static func getTodoFromCoreData() -> [Todo]{
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
   static func updateTodoInCoreData(todoUpdated: Todo, index: Int){
        
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
    static func deletingTodoFromCoreData(index: Int){
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
}
