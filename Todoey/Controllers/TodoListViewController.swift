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
import ChameleonFramework
class TodoListViewController: SwipeTableViewController{

    @IBOutlet weak var searchBar: UISearchBar!
    var todoItems : Results<Item>?
    let realm = try! Realm()
    var selectCategory : Category? {
        didSet{
            loadItems()
            tableView.rowHeight = 80.0
        }
    }


    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
        
        
      
        

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        if let colorhex = selectCategory?.colour{
//            guard let navbar = navigationController?.navigationBar else {fatalError("It does not exits")}
//        navbar.barTintColor = UIColor(hexString: colorhex)
//        }
        
        if let colourHex = selectCategory?.colour {
                    /*
                     First we set the title to match the category. We know that it exist since we are inside our if let statement here:
                     */
            title = selectCategory!.name
         
                    /*
                     Set the colour to use here:
                     */
                    let theColourWeAreUsing = UIColor(hexString: colourHex)!
         
                    /*
                     Then let us set the background colour of the search bar as well:
                     */
                    searchBar.barTintColor = theColourWeAreUsing
         
                    /*
                     THen we will set the colours. Using navigationController?.navigationBar.backgroundColor is not an option here because in iOS 13, the status bar at the very top does not change colour (strangely enough). After Googling this, I found a solution where they use UINavigationBarAppearance() instead.
                     */
                    let navBarAppearance = UINavigationBarAppearance()
                    let navBar = navigationController?.navigationBar
                    let navItem = navigationController?.navigationItem
                    navBarAppearance.configureWithOpaqueBackground()
         
                    /*
                     We use Chameleon's ContrastColorOf() function to set the colour of the text based on the colour we use. If it is dark, the text is light, and vice versa.
                     */
                    let contrastColour = ContrastColorOf(theColourWeAreUsing, returnFlat: true)
         
                    navBarAppearance.titleTextAttributes = [.foregroundColor: contrastColour]
                    navBarAppearance.largeTitleTextAttributes = [.foregroundColor: contrastColour]
                    navBarAppearance.backgroundColor = theColourWeAreUsing
                    navItem?.rightBarButtonItem?.tintColor = contrastColour
                    navBar?.tintColor = contrastColour
                    navBar?.standardAppearance = navBarAppearance
                    navBar?.scrollEdgeAppearance = navBarAppearance
         
                    self.navigationController?.navigationBar.setNeedsLayout()
                }
    }
    
    //MARK: - numberofrowinsection
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  todoItems?.count ?? 1
    }
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
////        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! SwipeTableViewCell
//
//let cell = super.tableView(tableView, cellForRowAt: indexPath)
//        cell.textLabel?.text = todoItems?[indexPath.row].done ?? "No category name is added"
//        return cell
//    }
    
//MARK: - cellforRow
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                             //deqeueReusableCell...
       let cell = super.tableView(tableView, cellForRowAt: indexPath)
      
        if    let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            //        ternory oprator
            cell.accessoryType = item.done ? .checkmark : .none
        }else {
            cell.textLabel?.text = "No items added"
        }
        
        if let color = UIColor(hexString: selectCategory!.colour)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(todoItems!.count)){
            cell.backgroundColor = color
            cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
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
    
    
    override func updateModel(at indexPath: IndexPath) {
        if let item = self.todoItems?[indexPath.row]{
            do{
                
                try self.realm.write{
                    self.realm.delete(item)
                }
            }catch {
                print("This contains a error at \(error)")
            }
        }
        
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
