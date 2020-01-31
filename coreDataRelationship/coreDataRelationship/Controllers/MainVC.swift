//
//  ViewController.swift
//  coreDataRelationship
//
//  Created by Stephenson Ang on 1/28/20.
//  Copyright © 2020 Stephenson Ang. All rights reserved.
//

import UIKit
import CoreData

class MainVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var userList = [UserName]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fetchUserNameData()
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }

    @IBAction func addBtnWasPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Adding Username", message: "Who is it?", preferredStyle: .alert)
        
        alert.addTextField { (textfield) in
            textfield.keyboardType = .default
            textfield.placeholder = "Enter Name"
        }
        alert.addTextField { (textfield) in
            textfield.keyboardType = .numberPad
            textfield.placeholder = "Enter Age"
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { (action) in
            let nameTxtField = alert.textFields?[0]
            let ageTxtField = alert.textFields?[1]
            
//            self.userList.append(UserName(name: nameTxtField?.text ?? "Anonymous", age: Int(ageTxtField?.text ?? "") ?? 0))
            let usernameData : UserName = UserName(name: nameTxtField?.text ?? "Anonymous", age: Int(ageTxtField?.text ?? "") ?? 0)
            self.createUserNameData(username: usernameData)
            self.fetchUserNameData()
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
}
extension MainVC {
    
    func createUserNameData(username: UserName) {
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let manageContext = appdelegate.persistentContainer.viewContext
        let usernameEntity = NSEntityDescription.entity(forEntityName: "User", in: manageContext)!
        
        let user = NSManagedObject(entity: usernameEntity, insertInto: manageContext)
        
        user.setValue(username.name, forKey: "name")
        user.setValue(username.age, forKey: "age")
        
        do {
            try manageContext.save()
        } catch let error as NSError {
            print("could not save data \(error), \(error.userInfo)")
        }
    }
    
    func fetchUserNameData() {
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else { return }
                let manageContext = appdelegate.persistentContainer.viewContext
                
                let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
                
                do {
                    let result = try manageContext.fetch(request)
                    self.userList.removeAll()
                    for data in result as! [NSManagedObject] {
                        self.userList.append(UserName(name: data.value(forKey: "name") as! String, age: data.value(forKey: "age") as! Int))
                        self.tableView.reloadData()
                    }
                } catch {
                    print("Failed")
                }
    }
    
    func deleteUserNameData(username: String) {
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let manageContext = appdelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        request.predicate = NSPredicate(format: "name = %@", username)
        
        do {
            let test = try manageContext.fetch(request)
            let counter = findTheIndex(name: username)
            let objectToDelete = test[0] as! NSManagedObject
            manageContext.delete(objectToDelete)
            userList.remove(at: counter)
            do {
                try manageContext.save()
                self.tableView.reloadData()
            } catch {
                print(error)
            }
        } catch {
            print(error)
        }
    }
    
    func updateUserData(username: UserName, updatedUsername: UserName) {
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let manageContext = appdelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        request.predicate = NSPredicate(format: "name = %@", username.name)
        
        do {
            let update = try manageContext.fetch(request)
            
            let objectToUpdate = update[0] as! NSManagedObject
            
            objectToUpdate.setValue(updatedUsername.name, forKey: "name")
            objectToUpdate.setValue(updatedUsername.age, forKey: "age")
            self.fetchUserNameData()
            do {
                try manageContext.save()
                self.tableView.reloadData()
            } catch {
                print(error)
            }
        } catch {
            print(error)
        }
    }
    
    func findTheIndex(name: String) -> Int {
        var count = 0
        for loop in userList {
            print("\(count) : \(loop.name) - \(name)")
            if loop.name == name {
                return count
            } else {
                count = count + 1
            }
        }
        return 0
    }
    
}

//TABLEVIEW
extension MainVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UsernameCell") as? UsernameCell else { return UITableViewCell() }
        let username = userList[indexPath.row]
        
        cell.configureCell(username: username)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let contextItemDelete = UIContextualAction(style: .destructive, title: "delete") {  (contextualAction, view, boolValue) in
            //Code I want to do here
            let username = self.userList[indexPath.row]
            self.deleteUserNameData(username: username.name)
        }
        let contextItemUpdate = UIContextualAction(style: .destructive, title: "Update") {  (contextualAction, view, boolValue) in
            //Code I want to do here
            
            
            let alert = UIAlertController(title: "Adding Username", message: "Who is it?", preferredStyle: .alert)
                    
                    alert.addTextField { (textfield) in
                        textfield.keyboardType = .default
                        textfield.placeholder = "Enter Name"
                    }
                    alert.addTextField { (textfield) in
                        textfield.keyboardType = .numberPad
                        textfield.placeholder = "Enter Age"
                    }
                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                    alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { (action) in
                        let nameTxtField = alert.textFields?[0]
                        let ageTxtField = alert.textFields?[1]
                        
            //            self.userList.append(UserName(name: nameTxtField?.text ?? "Anonymous", age: Int(ageTxtField?.text ?? "") ?? 0))
//                        let usernameData : UserName = UserName(name: , age: Int(ageTxtField?.text ?? "") ?? 0)
                        self.updateUserData(username: self.userList[indexPath.row], updatedUsername: UserName(name: nameTxtField?.text ?? "Anonymous", age: Int(ageTxtField?.text ?? "") ?? 0))
                    }))
                    
                    self.present(alert, animated: true, completion: nil)
            
            
//            let username = self.userList[indexPath.row]
//            self.updateUserData(username: username)
        }
        let swipeActions = UISwipeActionsConfiguration(actions: [contextItemDelete, contextItemUpdate])

        return swipeActions
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sample = userList[indexPath.row]
        
        print("the name of the cell \(sample.name)")
    }
    
}
