//
//  DataProvider.swift
//  EnternProject
//
//  Created by Мухтарпаша on 19.05.2020.
//  Copyright © 2020 Magomed Inc. All rights reserved.
//

import CoreData


final class DataProvider {
    // чтоб работать с моделями, нам нужен контекст, мы взяли ссылку на наш контекст
    private let context = CoreDataStack.shared.context
    // нужен чтоб загрузить наше фото через сервис
    private let service = BaseService()
    
    
    
    func loadCache (onComplete: @escaping ([PhotoModel]) -> Void) {
        // из хранилище запрашиваем данные 
        let request: NSFetchRequest<PhotoEntity> = PhotoEntity.fetchRequest()
                  
                  let photoEntyties = try? self.context.fetch(request)
                  
                  //мы делаем проверку
                  if let photos = photoEntyties, !photos.isEmpty {
                      let photoModels = photos.map {
                          PhotoModel(id: $0.id ?? "" , description: $0.desc , urls: .init(regular: $0.url ?? "" , small: ""))
                      }
                      
                      
                      onComplete(photoModels)
                  } else {
                    
                  }
    }
    
    
    
    func loadPhotos (onComplete: @escaping ([PhotoModel]) -> Void ,onError:@escaping(Error) -> Void) {
        
        service.loadPhotos(onComplete: { [weak self] (photos) in
            guard let self = self else {
                return
            }
            // мы для каждой фотографии полученной создаем сущность в базе данных
            for item in photos {
                let photoEntity = PhotoEntity(context: self.context)
                //теперь нужнл выставить свойство этой сущности
                photoEntity.id = item.id
                photoEntity.desc = item.description
                photoEntity.url = item.urls.regular
            }
            //сохраняем изменения
            try? self.context.save()
            //возвращаем наши фотки
            onComplete(photos)
        }) { (error) in
            
            print(error.localizedDescription)
            
            //делаем так, чтоб если вдруг интернета не будет, отображались старые данные
            let request: NSFetchRequest<PhotoEntity> = PhotoEntity.fetchRequest()
            
            let photoEntyties = try? self.context.fetch(request)
            
            //мы делаем проверку
            if let photos = photoEntyties, !photos.isEmpty {
                let photoModels = photos.map {
                    PhotoModel(id: $0.id ?? "" , description: $0.desc , urls: .init(regular: $0.url ?? "" , small: ""))
                }
                
                
                onComplete(photoModels)
            } else {
                onError(error)
            }
        }
        
}
    
    
    
    
}
