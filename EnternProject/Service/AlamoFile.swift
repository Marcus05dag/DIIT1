//
//  AlamoFile.swift
//  EnternProject
//
//  Created by Мухтарпаша on 10.06.2020.
//  Copyright © 2020 Magomed Inc. All rights reserved.
//

import Foundation
import Alamofire


extension TablController {
    func fetchPhoto () {
        
        let request = AF.request("https://api.unsplash.com/")
        
        request.responseJSON { (data) in
            print(data)
        }
        
        
    }
    
    
    
}
