//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class TodoListVC: UITableViewController {

    var itemArray = [Item]()
    var datafilepath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(datafilepath)
        
        let newItem = Item()
        newItem.title = "HouseWork"
        newItem.done = true
        itemArray.append(newItem)
        
        
        let newItem2 = Item()
        newItem2.title = "Buy Eggs"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "Eat"
        itemArray.append(newItem3)
        
        self.loadItems()
        
    }
    
    //MARK:- tableViewDatasource Method
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
//        if itemArray[indexPath.row].done == true {
//            cell.accessoryType = .checkmark
//        } else {
//            cell.accessoryType = .none
//        }
        
        cell.accessoryType = item.done == true ? .checkmark : .none
        
        return cell
    }

    
    //MARK:- tableViewDelegate Method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

//        if itemArray[indexPath.row].done  == false {
//            itemArray[indexPath.row].done  = true
//        } else {
//            itemArray[indexPath.row].done  = false
//        }
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        self.saveItems()
        
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    
    
    //MARK: - Add new Items
    
    @IBAction func addButtonPress(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add new Item", message: "", preferredStyle: .alert)
        var textField = UITextField()
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            //what will happen once the user click add item
            
            let newItem = Item()
            newItem.title = textField.text!
            
            
            self.itemArray.append(newItem)
            
           
            self.saveItems()
            
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create a item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert,animated: true,completion: nil)
    }

    //MARK:- Model Manipulation Methods
    func saveItems() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: datafilepath!)
        } catch {
            print("Error encoding item array, \(error)")
        }
    }
    
    func loadItems() {
        if let data = try? Data(contentsOf: datafilepath!) {
            let decoder = PropertyListDecoder()
            do {
               itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("error decoder, \(error)")
            }
            
        }
    }
    
}

