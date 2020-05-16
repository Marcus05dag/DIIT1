//
//  BaseService.swift
//  EnternProject
//
//  Created by Мухтарпаша on 15.05.2020.
//  Copyright © 2020 Magomed Inc. All rights reserved.
//

import Foundation

class BaseService  {
    enum ServerError:Error {
        
        case noDataProvided
        case failedDecode
        
        
    }
    
    
    //№8 так как мы не вернули из loadPhotos наши модели Photomodel,поэтому мы добавим обработчик onComplete
    func loadPhotos (onComplete: @escaping ([PhotoModel]) -> Void ,onError:@escaping(Error) -> Void) {
        //№1
        //создаем url для запроса
        let urlString = NetworkConstants.baseURL + "/photos?client_id=" + NetworkConstants.accessKey
        
        //№2
        //создаем URL объект из нашего url запроса
        let url = URL(string: urlString)!
        //№3
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                error.localizedDescription
                onError(error)
                
                return
            }
            
            
            
            
            //№4
            guard let data = data else {
                error?.localizedDescription
                onError(ServerError.noDataProvided)
                
                return
            }
            
            
            //maiping in JSon
            //JSONDecoder - чтоб получать что то от сервера
            //JSONEncode - чтоб что то отправить серверу
            //тут мы из data получаем массив наших объектов
            //№5
            guard let photos = try?JSONDecoder().decode([PhotoModel].self, from: data) else {
                print("could not decode")
                onError(ServerError.failedDecode)
                return
                
                
            }//№6
//            dump(photos)
            
            
            DispatchQueue.main.async {
                //№9
                //мы будем возвращать в этот обработчик наши загруженные модели photos
                onComplete(photos)
            }
            
            
        }//№7
        //запускаем наш task
        task.resume()
        
        
    }
}
