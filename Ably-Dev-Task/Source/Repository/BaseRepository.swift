//
//  BaseRepository.swift
//  Ably-Dev-Task
//
//  Created by 진태우 on 2022/06/21.
//

import Foundation


class BaseRepository<T> {
    
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
    
    func fetchValue<T>(
        _ model: T.Type,
        predicate: NSPredicate?,
        sorted: Sorted?
    ) -> [T] where T: Storable  {
        return manager.fetchValue(model, predicate: predicate, sorted: sorted)
    }
    
    func save(object: Storable) throws {
        try manager.save(object: object)
    }
    
    func delete<T>(
        _ model: T.Type,
        object: Storable,
        predicate: NSPredicate
    ) throws where T: Storable {
        if let item = manager.fetchValue(model, predicate: predicate, sorted: nil).first {
            try manager.delete(object: item)
        }
    }
    
}
