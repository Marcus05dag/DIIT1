//
//  SeconViewConrtoller.swift
//  EnternProject
//
//  Created by Мухтарпаша on 09.05.2020.
//  Copyright © 2020 Magomed Inc. All rights reserved.
//

import UIKit
class SecondViewController: UIViewController,UITableViewDelegate{
    
    
    @IBOutlet weak var tableViewSecond: UITableView!
    var photos = [PhotoModel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewSecond.delegate = self
        tableViewSecond.dataSource = self
        tableViewSecond.register(UITableViewCell.self, forCellReuseIdentifier: "Cells")
        tableViewSecond.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier : "imageCell")
        
        // наши данные будут загружаться сразу , как только загрузится ViewDidload
        loadData()
    }
    
    
    // данный метод будет загружать наши данные
    func loadData ()  {
        let service = BaseService()
        
        service.loadPhotos(onComplete: { [weak self] (photos) in
            self?.photos = photos
            print("photos count" , photos.count)
            self?.tableViewSecond.reloadData()
        }) { (error) in
            print(error.localizedDescription)
        }
        
        
    }
    
    
    
    
    
    
    
    
    
    
}









//MARK:EXTENSION
extension SecondViewController: UITableViewDataSource {
  //возвращаем количество ячеек
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cells = tableViewSecond.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath) as! TableViewCell
        
        let Model = photos[indexPath.row]
        // грузим в нашу кастомную ячейку картинку 
        cells.customImageCell.loadImage(by: Model.urls.regular)
            return cells
           
    }
    }
    
    

