//
//  CoreDataManager.swift
//  SB-L-2.13-CoreDataDemo
//
//  Created by Sergey Nestroyniy on 26.10.2022.
//

import Foundation
import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()
    
    private var context : NSManagedObjectContext { CoreDataManager.shared.persistentContainer.viewContext }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "SB_L_2_13_CoreDataDemo")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - func
    
    func saveTask (_ taskName: String) -> Task? {
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "Task", in: context) else {return nil}
        guard let task = NSManagedObject(entity: entityDescription, insertInto: context) as? Task else {return nil}
        task.name = taskName
        
        if context.hasChanges {
            do {
                try context.save()
            } catch  let error {
                print(error)
            }
        }
        
        return task
    }
    
    func deleteTask (_ task: Task) {
        context.delete(task)
        do {
            try context.save()
        } catch let error {
            print(error)
        }
    }
    
}
