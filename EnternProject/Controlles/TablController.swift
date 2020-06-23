//
//  TablController.swift
//  EnternProject
//
//  Created by Мухтарпаша on 05.06.2020.
//  Copyright © 2020 Magomed Inc. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import SDWebImage

class TablController: UITableViewController{
    
    
//    var photos = [#imageLiteral(resourceName: "image4"), #imageLiteral(resourceName: "image2"), #imageLiteral(resourceName: "image3"), #imageLiteral(resourceName: "image1"), #imageLiteral(resourceName: "Image5"),#imageLiteral(resourceName: "Image10"),#imageLiteral(resourceName: "Image11"),#imageLiteral(resourceName: "Image9"),#imageLiteral(resourceName: "Image6"),#imageLiteral(resourceName: "Image7"),#imageLiteral(resourceName: "Imag12")]
    
    var photoses = [PhotoModel]()
    let service = DataProvider()
//MARK:ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
//        tableView.rowHeight = UITableView.automaticDimension
//        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        
        self.tableView.register(ImageViewCell.self, forCellReuseIdentifier: "ImageViewCell")
        

//        tableView.register(TableViewCell.self, forCellReuseIdentifier: "Cell")
//        tableView.register(UINib(nibName: "tableCustomCell", bundle: nil), forCellReuseIdentifier: "CellCus")
        loadData()
        fetchPhoto()
        
        
      
    }
    
    
   
        
  
    
    func loadData() {
          service.loadCache { [weak self] (photoses) in
              self?.photoses = photoses
               print("photos count" , photoses.count)
              self?.tableView.reloadData()
                   }
        
        service.loadPhotos(onComplete: { [weak self] (photoses) in
            self?.photoses = photoses
            self?.tableView.reloadData()
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
        
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            photoses.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.reloadData()
            tableView.endUpdates()
            
            
        }
        
    }
    
    

//    func loadDatas ()  {
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
      
        return photoses.count
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ImageViewCell", for: indexPath) as! ImageViewCell
        let model = photoses[indexPath.row]
        cell.mainImageView.loadImage(by: model.urls.regular)
//        cell.mainImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        cell.mainImageView.clipsToBounds = true
//        cell.mainImageView.sd_setImage(with: URL(string: NetworkConstants.baseURL + "/photos/?count=10&client_id=" + NetworkConstants.accessKey), completed: nil)
        
        
        
        return cell
    }
//    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 300    }
}
extension UIImage{

    func getCropRatio () -> CGFloat {
        let widthRatio = (self.size.width / self.size.height)

        return widthRatio

    }
}







