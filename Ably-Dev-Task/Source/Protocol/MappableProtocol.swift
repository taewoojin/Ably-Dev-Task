//
//  MappableProtocol.swift
//  Ably-Dev-Task
//
//  Created by 진태우 on 2022/06/22.
//

import RealmSwift


// model <-> realm 객체 간에 mapping을 위한 protocol
protocol MappableProtocol {
    associatedtype PersistenceType: Storable
    
    func mapToPersistenceObject() -> PersistenceType
    static func mapFromPersistenceObject(_ object: PersistenceType) -> Self
}
