//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Arhab Muhammad on 06/03/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import UIKit
//import CoreData
import RealmSwift
import SwipeCellKit
import ChameleonFramework

class CategoryTableViewController: SwipeTableViewController{
    var category: Results<Category>?
    let realm = try! Realm()
//    let contex = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext no need!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       loadCategory()
        tableView.rowHeight = 80.0
        tableView.separatorStyle = .none
    }
    
    //MARK: - TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  category?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! SwipeTableViewCell
        
let cell = super.tableView(tableView, cellForRowAt: indexPath)
       
        cell.textLabel?.text = category?[indexPath.row].name ?? "No category name is added"
        cell.backgroundColor = UIColor(hexString: category?[indexPath.row].colour ?? "1D9BF6")
        return cell
 
    }
    
    //MARK: - TableView Delegate Method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
       
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
       
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectCategory = category?[indexPath.row]
        }
        
    }
    
    
    
    
    //MARK: - Data manipulation methods
    
    
    func save(caregory: Category){
        do{
            try    realm.write{
//                realm.delete(caregory)
                realm.add(caregory)
            }
        }catch{
            print("Error saving context")
        }
        tableView.reloadData()
    }
    
    func loadCategory(){
        
    category = realm.objects(Category.self)
        

        tableView.reloadData()
    }
    
    //MARK: - Delete data from swipe
   
    override func updateModel(at indexPath: IndexPath) {
        if let item = self.category?[indexPath.row]{
            do{
                
                try self.realm.write{
                    self.realm.delete(item)
                }
            }catch {
                print("This contains a error at \(error)")
            }
        }
        
    }
    
    //MARK: - Add new Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
      var textfield = UITextField()
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
           
            let newCategory = Category()
            newCategory.name = textfield.text!
            newCategory.colour = UIColor.randomFlat().hexValue()
            self.save(caregory: newCategory)
            
        }
        alert.addAction(action)
        alert.addTextField { (field) in
            textfield = field
            textfield.placeholder = "Add a new category"
        }
        present(alert, animated: true, completion: nil)
        
    }
    
}


