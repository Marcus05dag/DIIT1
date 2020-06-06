//
//  TablController.swift
//  EnternProject
//
//  Created by Мухтарпаша on 05.06.2020.
//  Copyright © 2020 Magomed Inc. All rights reserved.
//

import UIKit
import CoreData

class TablController: UITableViewController{
    
    
    var photos = [#imageLiteral(resourceName: "image4"), #imageLiteral(resourceName: "image2"), #imageLiteral(resourceName: "image3"), #imageLiteral(resourceName: "image1"), #imageLiteral(resourceName: "Image5"),#imageLiteral(resourceName: "Image10"),#imageLiteral(resourceName: "Image11"),#imageLiteral(resourceName: "Image9"),#imageLiteral(resourceName: "Image6"),#imageLiteral(resourceName: "Image7"),#imageLiteral(resourceName: "Imag12")]
    var photoses = [PhotoModel]()
 
    let service = DataProvider()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.tableView.register(ImageViewCell.self, forCellReuseIdentifier: "ImageViewCell")
        

//        tableView.register(TableViewCell.self, forCellReuseIdentifier: "Cell")
//        tableView.register(UINib(nibName: "tableCustomCell", bundle: nil), forCellReuseIdentifier: "CellCus")
//        loadData()
    }

//    func loadData ()  {
//           service.loadCache { [weak self] (photos) in
//               self?.photos = photos
//               print("photos count" , photos.count)
//               self?.tableView.reloadData()
//           }
//
//           service.loadPhotos(onComplete: { [weak self] (photos) in
//               self?.photos = photos
//               print("photos count" , photos.count)
//               self?.tableView.reloadData()
//           }) { (error) in
//               print(error.localizedDescription)
//           }
//
//
//       }
    
    
    
    // MARK: - Table view data source

   
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        return photos.count
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ImageViewCell", for: indexPath) as! ImageViewCell
        
        
        
//        cell.tableCustomCell.loadImage(by: model.urls.regular)
        cell.mainImageView.image = photos[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let currentImage = photos[indexPath.row]
        
        let imageCrop = currentImage.getCropRatio()
        return tableView.frame.width / imageCrop
    }
}
    
extension UIImage {
        
        func getCropRatio () -> CGFloat {
            var widthRatio = self.size.width / self.size.height
            
            return widthRatio
            
        }
    }
     


