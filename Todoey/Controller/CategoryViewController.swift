//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Wallace Santos on 13/06/22.
//

import UIKit
import RealmSwift


class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
// new collection type
    var categories:Results<Category>?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = UIColor.darkGray
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        
        loadCategories()
    }
//MARK: - Add new Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    
    let alert = UIAlertController(title: "Add New Todoey Category", message: "", preferredStyle: .alert)
        
        var textField = UITextField()
    
        let action = UIAlertAction(title: "Add Category", style: .default) { action in
            let newCategory = Category()
            
            guard let safeCate = textField.text else {return}
            
            newCategory.name = safeCate
//          O datatype Results - Results is an auto-updating container type in Realm returned from object queries.
//          self.categories.append(newCategory)
            
            self.save(newCategory)
            
        }
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new Category"
            
            textField = alertTextField
            
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: K.categoryCell)
        cell.textLabel?.text = categories?[indexPath.row].name ?? K.noCategory
        return cell
    }
    
//MARK: - Realm Data
    
    func save(_ category:Category){
        
        do{
            try realm.write({
                realm.add(category)
            })
        }catch{
            print(error)
        }
        self.tableView.reloadData()
    }

    func loadCategories(){
     
        categories = realm.objects(Category.self)
        tableView.reloadData()
    
}

//MARK: - TableView Delegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.itensSegue, sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        guard let indexPath = tableView.indexPathForSelectedRow else {return}
        destinationVC.selectedCategory = categories?[indexPath.row]
    }
}


