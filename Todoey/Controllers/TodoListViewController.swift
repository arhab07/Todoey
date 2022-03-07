//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

class TodoListViewController: UITableViewController{

    var todoItems : Results<Item>?
    let realm = try! Realm()
    var selectCategory : Category? {
        didSet{
            loadItems()
        }
    }


    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
//      print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist"))
        
        // Do any additional setup after loading the view.
//        let newItem1 = Item()
//        newItem1.title = "Find Milk"
//        itemarray.append(newItem1)
//
//        let newItem2 = Item()
//        newItem2.title = "Find Milk"
//        itemarray.append(newItem2)
//
//        let newItem3 = Item()
//        newItem3.title = "Find Pen"
//        itemarray.append(newItem3)
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
//        loadItems( )
        
//        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
//            itemarray = items
        
    }
    //MARK: - numberofrowinsection
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  todoItems?.count ?? 1
    }
    
//MARK: - cellforRow
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                             //deqeueReusableCell...
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoitemCell", for: indexPath)
      
        if    let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            //        ternory oprator
            cell.accessoryType = item.done ? .checkmark : .none
        }else {
            cell.textLabel?.text = "No items added"
        }
       
        
//
//        if item.done == true{
//            cell.accessoryType = .checkmark
//        }else {
//            cell.accessoryType = .none
//        }
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // did select row
//        print(itemarray[indexPath.row])
        
        if let item = todoItems?[indexPath.row]{
        do{
            
                try realm.write{
//                    realm.delete(item)
                    item.done = !item.done
                }
            }catch {
                print("This contains a error at \(error)")
            }
        }

        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }

    //MARK: - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new Todoby Items", message: "", preferredStyle: .alert )
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
           
            if let currentCategory = self.selectCategory{
                do{
                    try self.realm.write{
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateSelected = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch{
                    print("This has a error at error \(error)")
                }
            }
//
            self.tableView.reloadData()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create a new Item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
//    func saveItem(){
//        do{
//            try    contex.save()
//        }catch{
//            print("Error saving context")
//        }
//    }
    
    func loadItems(){
       todoItems = selectCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
        
    }
    
    
}
    



extension TodoListViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateSelected", ascending: true)

        tableView.reloadData()
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


//let request : NSFetchRequest<Item> = Item.fetchRequest()
//
//let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
//request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//loadItems(with: request , predicate:  predicate )


//let alert = UIAlertController(title: "Add new Todoby Item", message: "", preferredStyle: .alert)
//let action = UIAlertAction(title: "Add Items", style: .default) { (action) in
//    // What will happen once the user clicks
//    print("Success")
//}
//alert.addAction(action)
//present(alert, animated: true, completion: nil)

//        the core data is replaced by  REALMSWIFT
        
        //        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectCategory!.name!)
//
//        if let additionalPredicate = predicate {
//            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,additionalPredicate])
//        }else{
//            request.predicate =  categoryPredicate
//        }
//
//
//            do{
//             itemarray =   try contex.fetch(request)
//            }catch{
//                print("Error")
//            }

//        if itemarray[indexPath.row].done == false {
//            itemarray[indexPath.row].done = true
//        }else{
//            itemarray[indexPath.row].done = false
//        }
        
//        if  tableView.cellForRow(at: indexPath)?.accessoryType != .checkmark{
//
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }else{
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//
//        }
