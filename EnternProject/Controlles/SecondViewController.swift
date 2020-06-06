//
//  SeconViewConrtoller.swift
//  EnternProject
//
//  Created by Мухтарпаша on 09.05.2020.
//  Copyright © 2020 Magomed Inc. All rights reserved.
//

import UIKit
import CoreData


class SecondViewController: UIViewController,UITableViewDelegate{
    
    
    @IBOutlet weak var tableViewSecond: UITableView!
    var photos = [PhotoModel]()
    let service = DataProvider()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewSecond.delegate = self
        
        tableViewSecond.register(UITableViewCell.self, forCellReuseIdentifier: "Cells")
        tableViewSecond.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier : "imageCell")
        
        // наши данные будут загружаться сразу , как только загрузится ViewDidload
        loadData()
    }
    
    
    // данный метод будет загружать наши данные
    func loadData ()  {
        service.loadCache { [weak self] (photos) in
            self?.photos = photos
            print("photos count" , photos.count)
            self?.tableViewSecond.reloadData()
        }
        
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
        tableView.separatorColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            return cells
           
    }
    
    
   func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    
       if editingStyle == .delete {

       // процесс между началом и концом удаление
       tableView.beginUpdates()


       //после удаление строки , мы говорим удалить ячейку
       photos.remove(at: indexPath.row)




        tableView.deleteRows(at: [indexPath], with: .automatic)
        
        




       //конец удаление строки и ячейки
       tableView.endUpdates()

    }
        
    
}  
    
   
}
    
    
