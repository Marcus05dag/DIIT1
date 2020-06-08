//
//  TableViewController.swift
//  EnternProject
//
//  Created by Мухтарпаша on 03.06.2020.
//  Copyright © 2020 Magomed Inc. All rights reserved.
//

import UIKit
import  CoreData
import Firebase

class TableViewController: UITableViewController{
    
    var man:[NSManagedObject] = []

        //MARK:ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLogOutButton ()

        view.backgroundColor = .red
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        conficureButtonPlus()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchReq()
        
        
    }
    
    //MARK:ConfigureLogOut
    fileprivate func configureLogOutButton () {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Выйти", style: .plain, target: self, action: #selector(handleLogOut))
        navigationItem.leftBarButtonItem?.tintColor = .black
        
        
    }

    
    @objc fileprivate func handleLogOut () {
        
        print("LogOut")
        
        //set up action
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Выход", style: .destructive, handler: { (_) in
            do {
                try Auth.auth().signOut()
                let loginVC = LoginViewController()
                let navController = UINavigationController(rootViewController: loginVC)
                navController.modalPresentationStyle = .fullScreen
                self.present(navController, animated: true, completion: nil)
            }catch {
                print("Failed to sign out")
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        present(alert,animated: true)
    }
    
    //MARK:FetchReq
    fileprivate func fetchReq () {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else  {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person")
        
        do {
            man = try managedContext.fetch(fetchRequest)
        }catch let error as NSError {
            print("Could not fetch, \(error) , \(error.userInfo)")
        }
        
    }
    
    //MARK:configureButtonPlus
    fileprivate func conficureButtonPlus() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Icon-App-20x20-1"), style: .plain, target: self, action: #selector(handlePlus))
        
        
    }
    
    //MARK:HandlePlus
    @objc fileprivate func handlePlus () {
        print("button plus")
        let alert = UIAlertController(title: "Добавить имя", message: "Добавить новое имя", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Сохранить ", style: .default) { [unowned self] action in
            guard let textField = alert.textFields?.first,
                let nameToSave = textField.text else {
                    return
                
            }
            self.save(name: nameToSave)
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title:"Отмена", style: .cancel)
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert,animated: true)
        
        
        
    }
    
    //MARK:SAVE
    fileprivate func save (name:String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Person", in: managedContext)!
        
        let person = NSManagedObject(entity: entity, insertInto: managedContext)
        
        
        person.setValue(name, forKey: "name")
        
        
        do {
            try managedContext.save()
            man.append(person)
        } catch let error as NSError {
            print("Could not save,\(error), \(error.userInfo)")
        }
        
    }

    
    
    
    
    
    
    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return man.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let person = man[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = person.value(forKeyPath: "name") as? String

        return cell
    }
    
    //MARK:DELETE
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            man.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.reloadData()
            tableView.endUpdates()
            
            
        }
        
    }
    
    
    override func tableView (_ tableView: UITableView, canEditRowAt indexPath : IndexPath) -> Bool {
              
              
              
              
              return true
          }
}
