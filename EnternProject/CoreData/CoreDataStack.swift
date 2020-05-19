//
//  CoreDataStack.swift
//  EnternProject
//
//  Created by Мухтарпаша on 17.05.2020.
//  Copyright © 2020 Magomed Inc. All rights reserved.
//

import CoreData



final class CoreDataStack  {
    
    static let shared = CoreDataStack()
    
    private init() {}
    
    // данный контейнер является посредником между хранилищем и контекстом
    lazy var persistentContainer: NSPersistentContainer = {
        //наш посредник загружает Model и начинает с ней работать
        let container = NSPersistentContainer(name: "Model")
        //тут происходит загрузка
        container.loadPersistentStores(completionHandler: { (description , error) in
            print(description)
            if let error = error {
                fatalError("Unable to load persistent store: \(error)")
            }
        })
        return container
    }()
    
    lazy var context: NSManagedObjectContext = {
        //viewContext - это главный контекст, который работает на основной очереди
        return persistentContainer.viewContext
    }()
}

