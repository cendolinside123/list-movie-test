//
//  CoreDataStack.swift
//  movie
//
//  Created by Jan Sebastian on 29/04/24.
//

import Foundation
import CoreData

class CoreDataStack {
    
    static let shared: CoreDataStack = CoreDataStack()
    
    var isTestOnly: Bool = false
    
    private lazy var storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Movie")
        
        if isTestOnly {
            let persistentStoreDescription = NSPersistentStoreDescription()
            persistentStoreDescription.type = NSInMemoryStoreType
            container.persistentStoreDescriptions = [persistentStoreDescription]
        }
        
        container.loadPersistentStores(completionHandler: { storeDescription, error in
            print("storeDescription: \(storeDescription)")
            if let getError = error as NSError? {
                print("Unresolved error \(getError), \(getError.userInfo)")
            }
        })
        
        return container
    }()
    
    private lazy var managedContext: NSManagedObjectContext = {
        return self.storeContainer.viewContext
    }()
    
    private lazy var privateManagedContext: NSManagedObjectContext = {
        return self.storeContainer.newBackgroundContext()
    }()
    
    func saveContext() {
        guard managedContext.hasChanges else {
            return
        }
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
        
    }
    
    func doInBackground(doTask: @escaping (() -> Void), result: @escaping (Result<Void, Error>) -> Void) {
        self.privateManagedContext.perform {
            do {
                doTask()
                try self.privateManagedContext.save()
                result(.success(()))
            } catch let error as NSError{
                print("Unresolved error \(error), \(error.userInfo)")
                result(.failure(error))
            }
            
        }
    }
    
    func doInBackground(doTask: @escaping (() -> Void)) {
        self.privateManagedContext.perform {
            doTask()
        }
    }
    
    func getContext() -> NSManagedObjectContext {
        return managedContext
    }
    
    func getPrivateContext() -> NSManagedObjectContext {
        return privateManagedContext
    }
    
    func doTestSetup() {
        _ = self.storeContainer
        print("managedContext: \(managedContext)")
        print("privateManagedContext: \(privateManagedContext)")
    }
    
    func getStoreContainer() -> NSPersistentContainer {
        return storeContainer
    }
    
    private func setStroreContainer(container: NSPersistentContainer) {
        storeContainer = container
    }
}
