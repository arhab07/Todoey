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

class CategoryTableViewController: UITableViewController {
    var category: Results<Category>?
    let realm = try! Realm()
//    let contex = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext no need!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategory()
    }
    
    //MARK: - TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  category?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = category?[indexPath.row].name ?? "No category name is added"
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
    
    func loadCategory(){
        
    category = realm.objects(Category.self)
        
//        let result: NSFetchRequest = Category.fetchRequest()
//        do{
//        category = try contex.fetch(result)
//        }catch{
//            print("error")
//        }
        tableView.reloadData()
    }
    func save(caregory: Category){
        do{
            try    realm.write({
                realm.add(category!)
            })
        }catch{
            print("Error saving context")
        }
        tableView.reloadData()
    }
    
    
   
    
    
    //MARK: - Add new Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
      var textfield = UITextField()
        let alert = UIAlertController(title: "Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Category", style: .default) { (action) in
           
            let newCategory = Category()
            newCategory.name = textfield.text!
            self.save(caregory: newCategory)
//            self.category.append(newCategory)
            
        }
        alert.addAction(action)
        alert.addTextField { (field) in
            textfield = field
            textfield.placeholder = "Add a new category"
        }
        present(alert, animated: true, completion: nil)
        
    }
    
}
