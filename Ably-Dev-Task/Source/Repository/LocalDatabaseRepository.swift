//
//  LocalDatabaseRepository.swift
//  Ably-Dev-Task
//
//  Created by 진태우 on 2022/06/21.
//

import Foundation


class LocalDatabaseRepository<T> {
    
    // MARK: Properties
    
    var manager: DataManager
    
    
    // MARK: Initializing
    
    required init(manager: DataManager) {
        self.manager = manager
    }
    
    
    // MARK: Methods
    
    func fetch<T>(
        _ model: T.Type,
        predicate: NSPredicate?,
        sorted: Sorted?,
        completion: (([T]) -> Void)
    ) where T: Storable {
        manager.fetch(model, predicate: predicate, sorted: sorted, completion: completion)
    }
    
    func add(object: Storable) throws {
        try manager.add(object: object)
    }
    
    func delete<T>(
        _ model: T.Type,
        object: Storable,
        predicate: NSPredicate
    ) throws where T: Storable {
        if let item = manager.fetchValue(model, predicate: predicate) {
            try manager.delete(object: item)
        }
    }
    
}
