//
//  PhotoModel.swift
//  EnternProject
//
//  Created by Мухтарпаша on 15.05.2020.
//  Copyright © 2020 Magomed Inc. All rights reserved.
//

import Foundation

// json это словарь, а чтоб свифт начал читать наши структуры , нужно сделать их словарями

struct PhotoModel: Codable {
    let id: String
    let description:String?
    let urls:urlsModel
    
    
    
}

struct urlsModel:Codable {
    let regular : String
    let small:String
    
}
