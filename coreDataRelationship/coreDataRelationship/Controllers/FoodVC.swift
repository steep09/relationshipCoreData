//
//  FoodVC.swift
//  coreDataRelationship
//
//  Created by Stephenson Ang on 1/28/20.
//  Copyright © 2020 Stephenson Ang. All rights reserved.
//

import UIKit
import CoreData

class FoodVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var foodList = [Foods]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //UPDATE TABLEVIEW WHEN A CELL IS PRESSED
        self.fetchFoodData(food: foodList)
        
    }
    
    @IBAction func addBtnWasPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Adding Food", message: "What is it?", preferredStyle: .alert)
                
                alert.addTextField { (textfield) in
                    textfield.keyboardType = .default
                    textfield.placeholder = "Enter Name of Food"
                }
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { (action) in
                    let nameTxtField = alert.textFields?[0]
                    if nameTxtField?.text == "" {
                        return
                    } else {
                        let sample = Foods(name: nameTxtField?.text ?? "something")
                        print(sample.name)
                        self.createFoodData(food: sample)
                        
//                        self.foodList.append(Foods(name: nameTxtField?.text ?? ""))
//                        self.tableView.reloadData()
                    }
                }))
                
                self.present(alert, animated: true, completion: nil)
    }
    
}

//TABLEVIEW
extension FoodVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FoodCell") as? FoodCell else { return UITableViewCell() }
        
        let foods = foodList[indexPath.row]
        
        cell.configureCell(food: foods)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let contextItem = UIContextualAction(style: .destructive, title: "delete") {  (contextualAction, view, boolValue) in
                //Code I want to do here
                let food = self.foodList[indexPath.row]
                self.deleteFoodData(food: food.name)
            }
            let swipeActions = UISwipeActionsConfiguration(actions: [contextItem])

            return swipeActions
        }
    
}

//CORE DATA
extension FoodVC {
    
    func createFoodData(food: Foods) {
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let manageContext = appdelegate.persistentContainer.viewContext
        let foodentity = NSEntityDescription.entity(forEntityName: "Food", in: manageContext)!
        
        let foods = NSManagedObject(entity: foodentity, insertInto: manageContext)
        
        foods.setValue(food.name, forKey: "name")
        
        self.foodList.append(Foods(name: food.name))
        self.tableView.reloadData()
        
        do {
            try manageContext.save()
        } catch {
            print(error)
        }
    }
    
    func fetchFoodData(food: [Foods]) {
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let manageContext = appdelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Food")

        do {
            let result = try manageContext.fetch(request)
            self.foodList.removeAll()
            for data in result as! [NSManagedObject] {
                self.foodList.append(Foods(name: data.value(forKey: "name") as! String))
                self.tableView.reloadData()
            }
        } catch {
            print("Failed")
        }
    }
    
    func deleteFoodData(food: String) {
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let manageContext = appdelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Food")
        
        request.predicate = NSPredicate(format: "name = %@", food)
        
        do {
            let test = try manageContext.fetch(request)
            let counter = findTheIndex(name: food)
            let objectToDelete = test[0] as! NSManagedObject
            manageContext.delete(objectToDelete)
            foodList.remove(at: counter)
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
}

extension FoodVC {
    func findTheIndex(name: String) -> Int {
        var count = 0
        for loop in foodList {
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
