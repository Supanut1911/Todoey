//
//  CategoryVC.swift
//  Todoey
//
//  Created by Supanut Laddayam on 14/4/2563 BE.
//  Copyright © 2563 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class CategoryVC: UITableViewController {

    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadCategory()
        
//        let aCatogory = Category()
//        aCatogory.name = "shopping"
//        categoryArray.append(aCatogory)
//        
//        var aCatogory2 = Category()
//        aCatogory.name = "shopping2"
//        categoryArray.append(aCatogory2)
//        
//        var aCatogory3 = Category()
//        aCatogory.name = "shopping3"
//        categoryArray.append(aCatogory3)
    }

  

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add Category", message: "", preferredStyle: .alert)
        
        var textField = UITextField()
        
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            self.categoryArray.append(newCategory)
            
            self.saveCategory()
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
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let category = categoryArray[indexPath.row]
        cell.textLabel?.text = category.name
        
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

    func saveCategory() {
        do {
           try context.save()
        } catch {
           print("Error to save Category ",error)
        }
        
    }
    
    func loadCategory(with request:NSFetchRequest<Category> = Category.fetchRequest()) {
   
        
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context", error)
        }
        tableView.reloadData()
    }
    
}
