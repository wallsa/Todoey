//
//  ViewController.swift
//  Todoey
//
//  Created by Wallace Santos on 05/06/22.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    
    let realm = try! Realm()
    var todoItems:Results<Item>?
    
    var selectedCategory:Category?{
        //é executado quando o nosso valor é setado
        //assim nos certificamos que só carregaremos nossa view quando há valor para a categoria selecionada
        //Excluindo o risco de nossa aplicacao quebrar
        didSet{
            loadItens()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        let appearance = UINavigationBarAppearance()
        
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = UIColor.darkGray
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        
        
        
        
        
        
        
    }
    //MARK: - Table View DataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: K.cellName)
        
        if let item = todoItems?[indexPath.row]{
            cell.textLabel?.text = item.title
            //Ternary Operator
            // value = condition ? valueIfTrue : valueIfFalse
            
            cell.accessoryType = item.done == true ? .checkmark : .none
            
            //        if itemArray[indexPath.row].done == true{
            //            cell.accessoryType = .checkmark
            //        } else{
            //            cell.accessoryType = .none
            //        }
        }else{
            cell.textLabel?.text = "No items Added"
        }
        
        return cell
    }
    
    //MARK: - TableView Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let item = todoItems?[indexPath.row]{
            do{
                try realm.write{
                    item.done = !item.done}
            }catch{
                print(error)
            }
        }
        tableView.reloadData()
    }
    //MARK: - Add New Itens
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            
            if let currentCategory = self.selectedCategory {
                do{
                    try self.realm.write{
                        let newItem = Item()
                        guard let safeText = textField.text else {return}
                        newItem.title = safeText
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                }catch{
                    print("Error saving new items, \(error)")
                }
                
            }
            self.tableView.reloadData()
            
        }
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new Item"
            
            textField = alertTextField
            
        }
        alert.addAction(action)
        present(alert, animated: true)
        
    }
    //MARK: - CoreData
    
    func save(_ item:Item){
        do{
            try realm.write({
                realm.add(item)
            })
        }catch{
            print(error)
        }
        self.tableView.reloadData()
        
    }
    
    func loadItens(){
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
}
//MARK: - Search Bar Methods

extension TodoListViewController:UISearchBarDelegate{
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
        
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.isEmpty == true{
            loadItens()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
    
    
}


