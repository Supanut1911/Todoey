//
//  CategoryVC.swift
//  Todoey
//
//  Created by Supanut Laddayam on 14/4/2563 BE.
//  Copyright © 2563 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryVC: SwipeTableVC {
    
    let realm = try! Realm()

    var categoryArray: Results<Category>!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadCategory()
        
    }

  

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add Category", message: "", preferredStyle: .alert)
        
        var textField = UITextField()
        
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCategory = Category()
            newCategory.name = textField.text!
//            self.categoryArray.append(newCategory)
            
            self.save(category: newCategory)
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create a category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert,animated: true, completion: nil)
    }
    
    //MARK:- tableView data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No Category Added"
        
        return cell
    }
    
    
    //MARK:- tableView Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListVC
        
        if let indexpath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexpath.row]
        }
    }
    
    //MARK:- Data manipulation Method

    func save(category: Category) {
        do {
            try realm.write{
                realm.add(category)
            }
        } catch {
           print("Error to save Category ",error)
        }
        
    }
    
    func loadCategory() {
   
        categoryArray = realm.objects(Category.self)
 
        tableView.reloadData()
    }
    
    //MARK:- Delete Data from Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDel = self.categoryArray?[indexPath.row] {
            do {
                try self.realm.write{
                    self.realm.delete(categoryForDel)
                }
            } catch {
                print("Delete Category Error")
            }
            
        }
    }
}
