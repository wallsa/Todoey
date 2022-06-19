//
//  ViewController.swift
//  Todoey
//
//  Created by Wallace Santos on 05/06/22.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    
    

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var itemArray = [Item]()
    
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
    
//MARK: - TableView Delegate
    
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
            
            let newItem = Item(context: self.context)
            
            guard let safeText = textField.text else {return}
            newItem.title = safeText
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            //Após adicionarmos o item digitado pelo usuario no Array
        
            self.saveItems()

        }
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new Item"
            
            textField = alertTextField
            
        }
        alert.addAction(action)
        present(alert, animated: true)
        
    }
//MARK: - CoreData
    
    func saveItems(){
        
        do{
            try context.save()
        }catch{
            print(error)
        }
        self.tableView.reloadData()
    }   
    //                                                default value of function
    func loadItens(with request:NSFetchRequest<Item> = Item.fetchRequest(), predicate:NSPredicate? = nil){
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        //se houver um parametro passado ao predicate, adicionamos ele e criamos um predicate composto, com o passado no parametro e o criado acima
        if let addtionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, addtionalPredicate])
        //caso nao haja e o mesmo seja nil, só iremos carregar os Itens que combinanam
        // com o parentCategory passado a nossa VC pelo selectedCategory
        }else{
            request.predicate = categoryPredicate
        }
        
        
        
        do{
            itemArray = try context.fetch(request)
        }catch{
            print(error)
        }
        tableView.reloadData()
    }
}
//MARK: - Search Bar Methods

extension TodoListViewController:UISearchBarDelegate{
   
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request = Item.fetchRequest()
        guard let searchText = searchBar.text else {return}
        //o predicate estabelece a regra de busca, no caso o atributo title da nossa Entidade Item, CONTAIN o searchText digitado em nossa SearchBar
        request.predicate = NSPredicate(format: "title CONTAINS [cd] %@", searchText)
        print(searchText)
        //o sortDescriptors indica por qual atributo iremos ordenar e se sera em ordem alfabetica
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadItens(with: request)

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


