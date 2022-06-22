//
//  Item.swift
//  Todoey
//
//  Created by Wallace Santos on 19/06/22.
//

import Foundation
import RealmSwift

class Item: Object {
    //Declaration modifier - Permite que a propriedade seja monitorada para alteracoes durante a execucao do programa - Se o usuario alterar o valor, o dynamic permite que o Realm atualize dinamicamente
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated:Date?
//  Relacionamento Inverso,tipo do destino do link e a propriedade
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
}
