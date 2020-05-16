//
//  ViewController.swift
//  EnternProject
//
//  Created by Мухтарпаша on 09.05.2020.
//  Copyright © 2020 Magomed Inc. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    @IBOutlet weak var tableVIew: UITableView!
    var people:[NSManagedObject] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableVIew.dataSource = self
        tableVIew.delegate = self
        title = ""
        tableVIew.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
       
        
    }
    //MARK: COREDATA
    //извлечение данных из кор даты
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //1 получаем ссылку на делегат приложения
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        //получаем ссылку на его контейнер
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //NSFetchRequest отвечает за получение данных из базы данных. EntityName - нужен чтоб получить все объекты определенного объекта( в нашем случае Person)
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person")
        
        
        //мы передаем запрос на получение данных в контекст объекта. Fetch вовзращает массив объектов 
        do {
            people = try managedContext.fetch(fetchRequest)
                       
        } catch let error as NSError {
            print("could not fetch. \(error) , \(error.userInfo)")
        }
        
    }
    
    
    
    
    
    
    
    
    
//MARK: BUTTON AddName1
    @IBAction func addName1(_ sender: UIBarButtonItem) {
        //создали алерт
        let alert = UIAlertController(title: "Добавить имя", message: "Add Name", preferredStyle: .alert)
        
        //создали действие "Создать" в алерте
        let saveAction = UIAlertAction(title: "Создать", style:.default)  {
            [unowned self] action in
            
            guard let textField = alert.textFields?.first,
                let nameToSave = textField.text else {
                    return
            }
            
            self.save(name: nameToSave)
            self.tableVIew.reloadData()
    }
        //создали действие "Отмена" в алерте
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        
        alert.addTextField()
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        
        present(alert , animated: true)
    }
    
    //MARK: COREDATA
    func save (name: String) {
        // Чтоб получить доступ к контексту объекта, мы сперва должны получить ссылку на делегат приложения
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        // получаем доступ к контексту
        let managedContext = appDelegate.persistentContainer.viewContext
        
        
        // Cоздаем новый объект и вставляем туда контект управляемого объекта(managedContext)  и Person
        let entity = NSEntityDescription.entity(forEntityName: "Person", in: managedContext)!
        
        let person = NSManagedObject(entity:entity , insertInto: managedContext)
        
        
        // имея NSManagedObject в person , мы устанавливаем name атрибут, используя кодирование значение ключа .
        person.setValue(name , forKeyPath: "name" )
        
        
        // мы фиксируем изменения person и сохраняем их, вызывая контекст объекта
        do {
            try managedContext.save()
            people.append(person)
        } catch let error as NSError {
            print("Could not save . \(error) , \(error.userInfo)")
        }
        
        
    }
    
  
    

}
// MARK:EXTENSION
extension ViewController: UITableViewDataSource,UITableViewDelegate {
    
    //возвращаем количество ячеек таблицы
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
        
    }
    
    //Возвращает ячейки таблицы
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let person = people[indexPath.row]
        //возвращает повторно используемый объект ячейки TableView для указанного идентификатора повтороного использования и добавляет в таблицу
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        // тут получаем name атрибут NSManagedObject
        cell.textLabel?.text = person.value(forKeyPath:"name") as? String
        //задали цвет линии разделяющий ячейку
        tableView.separatorColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        
        return cell
    }
    
    
// задали высоту ячейкам
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45    }
    
    
    
    //MARK: DELETE
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        
        return .delete
    }
    
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            
               if editingStyle == .delete {

               // процесс между началом и концом удаление
               tableView.beginUpdates()


               //после удаление строки , мы говорим удалить ячейку
               people.remove(at: indexPath.row)




                tableView.deleteRows(at: [indexPath], with: .automatic)
                
                




               //конец удаление строки и ячейки
               tableView.endUpdates()

                
                
    }
    }
    
        func tableView (_ tableView: UITableView, canEditRowAt indexPath : IndexPath) -> Bool {
            
            
            
            
            return true
        }
        
        
    
}
