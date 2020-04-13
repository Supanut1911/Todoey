//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class TodoListVC: UITableViewController {

    var itemArray = [Item]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        print(datafilepath)
        
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
            
        //case togging the checkmark
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        //case delete item
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        print(indexPath.row)
        
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
            
            let newItem = Item(context: self.context)
            
            newItem.title = textField.text!
            newItem.done = false
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
        
        do {
            try context.save()
        } catch {
            print("error saving context, \(context)")
        }
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest() ) {
//        let request: NSFetchRequest<Item> = Item.fetchRequest()
        do {
        itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context", error)
        }
        
        tableView.reloadData()
    }
    
   
    
}

//MARK:- SearchBar Method
extension TodoListVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        // print(searchBar.text!)
        
        //Query
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.predicate = predicate
        
        let sortDescripter = NSSortDescriptor(key: "title", ascending: true)
        
        request.sortDescriptors = [sortDescripter]

//        do {
//            itemArray = try context.fetch(request)
//        } catch {
//            print("Error fetching data from context", error)
//        }
      
        loadItems(with: request)
        
       }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
       
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
}
