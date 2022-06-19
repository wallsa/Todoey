//
//  Item.swift
//  Todoey
//
//  Created by Wallace Santos on 19/06/22.
//

import Foundation
import RealmSwift

class IItem: Object {
    //Declaration modifier - Permite que a propriedade seja monitorada para alteracoes durante a execucao do programa - Se o usuario alterar o valor, o dynamic permite que o Realm atualize dinamicamente
    dynamic var title : String = ""
    var done : Bool = false
    
}
