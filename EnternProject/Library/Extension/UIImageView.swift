//
//  UIImageView.swift
//  EnternProject
//
//  Created by Мухтарпаша on 16.05.2020.
//  Copyright © 2020 Magomed Inc. All rights reserved.
//

import UIKit



extension UIImageView {
    
    
    // мы создали метод, чтоб по строку url могли загружать картинку
    func loadImage(by imageURL: String) {
    // мы создали url из строк,которые передали методу
    let url = URL(string: imageURL)!
        // кэш используется для хранения респонсов (ответов)
        let cache = URLCache.shared
        // мы создаем запрос
        let request = URLRequest(url: url)
        //потом мы берем из кэша нашу дату
        if  let imageData = cache.cachedResponse(for: request)?.data  {
            self.image = UIImage(data: imageData)
        } else {
            URLSession.shared.dataTask(with: request) { (data, response,_) in
                
                
                guard let data = data , let response = response else {
                    return
                }
                // а тут мы показываем все что получили из кэша
                DispatchQueue.main.async {
                    let cacheResponse = CachedURLResponse(response: response, data: data)
                    
                    cache.storeCachedResponse(cacheResponse, for: request)
                    self.image = UIImage(data:data)
                }
                //запускаем
            }.resume()
        }
        
        
    // вызываем загрузку контента по данному url , то есть здесь будет запрос на картинку
//    let data = try! Data(contentsOf: url)
    //и эту картинку передадим в Image
//    self.image = UIImage(data: data)
    }
    
}
