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
    // вызываем загрузку контента по данному url , то есть здесь будет запрос на картинку
    let data = try! Data(contentsOf: url)
    //и эту картинку передадим в Image
    self.image = UIImage(data: data)
    }
    
}
