//
//  FoodVC.swift
//  coreDataRelationship
//
//  Created by Stephenson Ang on 1/28/20.
//  Copyright © 2020 Stephenson Ang. All rights reserved.
//

import UIKit

class FoodVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var foodList = [Foods]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
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
                        self.foodList.append(Foods(name: nameTxtField?.text ?? ""))
                        self.tableView.reloadData()
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
    
    
}
