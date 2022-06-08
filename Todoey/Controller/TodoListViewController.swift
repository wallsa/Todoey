//
//  ViewController.swift
//  Todoey
//
//  Created by Wallace Santos on 05/06/22.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    var itemArray = [Item]()
    //instanciamos o UserDefaults que irá salvar os dados na sandbox do app no Iphone
//    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = UIColor.systemBlue
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        
        let newItem = Item()
        newItem.title = "Do Something"
        itemArray.append(newItem)
        
        loadItens()
        
//        if let lista = defaults.array(forKey: "TodoListArray") as? [Item] {
//         itemArray = lista
//        }
    }
    //MARK: - Table View DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: K.cellName)
        
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        //Ternary Operator
        // value = condition ? valueIfTrue : valueIfFalse
        
        cell.accessoryType = item.done == true ? .checkmark : .none
        
        //        if itemArray[indexPath.row].done == true{
        //            cell.accessoryType = .checkmark
        //        } else{
        //            cell.accessoryType = .none
        //        }
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //aqui estamos revertendo o resultado da propriedade done com o operador NOT
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    //MARK: - Add New Itens
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            
            let newItem = Item()
            
            guard let safeText = textField.text else {return}
            newItem.title = safeText
            self.itemArray.append(newItem)
            //Após adicionarmos o item digitado pelo usuario no Array
            //Armazenamos a Array com em um dic de chave TodoListArray
            
            //Enconding Data with NSCoder
            self.saveItems()
            
            print(textField.text!)
        }
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new Item"
            
            textField = alertTextField
            
        }
        alert.addAction(action)
        present(alert, animated: true)
        
    }
    
    func saveItems(){
        let encoder = PropertyListEncoder()
        
        do{
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        }catch{
            print(error)
        }
        self.tableView.reloadData()
    }
    
    func loadItens(){
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do{
                itemArray = try decoder.decode([Item].self, from: data)
            }catch{
                print(error)
            }
        }
    }
}
