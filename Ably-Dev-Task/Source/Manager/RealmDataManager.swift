//
//  RealmDataManager.swift
//  Ably-Dev-Task
//
//  Created by 진태우 on 2022/06/21.
//

import Foundation

import Realm
import RealmSwift


protocol DataManager {
    func fetch<T: Storable>(_ model: T.Type, predicate: NSPredicate?, sorted: Sorted?, completion: (([T]) -> ()))
    func fetchValue<T: Storable>(_ model: T.Type, predicate: NSPredicate?, sorted: Sorted?) -> [T]
    func save(object: Storable) throws
    func delete(object: Storable) throws
}

protocol Storable {}

extension Object: Storable {}

public struct Sorted {
    var key: String
    var ascending: Bool = true
}

class RealmDataManager {
    private let realm: Realm?
    
    init(_ realm: Realm? = try? Realm()) {
        self.realm = realm
    }
}

extension RealmDataManager: DataManager {
    
    func fetch<T>(
        _ model: T.Type,
        predicate: NSPredicate?,
        sorted: Sorted?,
        completion: (([T]) -> ())
    ) where T : Storable {
        guard let realm = realm, let model = model as? Object.Type else { return }
        var objects = realm.objects(model)
        if let predicate = predicate {
            objects = objects.filter(predicate)
        }
        
        if let sorted = sorted {
            objects = objects.sorted(byKeyPath: sorted.key, ascending: sorted.ascending)
        }
        
        completion(objects.compactMap { $0 as? T })
    }
    
    func fetchValue<T>(
        _ model: T.Type,
        predicate: NSPredicate?,
        sorted: Sorted?
    ) -> [T] where T: Storable {
        guard let realm = realm, let model = model as? Object.Type else { return [] }
        var objects = realm.objects(model)
        if let predicate = predicate {
            objects = objects.filter(predicate)
        }
        
        if let sorted = sorted {
            objects = objects.sorted(byKeyPath: sorted.key, ascending: sorted.ascending)
        }
        
        return objects.compactMap { $0 as? T }
    }
    
    func save(object: Storable) throws {
        guard let realm = self.realm, let object = object as? Object else { throw Realm.Error(.fail) }
        try realm.write {
            realm.add(object, update: .all)
        }
    }
    
    func delete(object: Storable) throws {
        guard let realm = self.realm, let object = object as? Object else { throw Realm.Error(.fail) }
        try realm.write {
            realm.delete(object)
        }
    }
    
}
