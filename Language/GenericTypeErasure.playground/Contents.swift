//  Type Erasure with Generics
//
//  Definition:     Hiding an object's real type / implementation details behind a generic protocol that uses an associated type
//
//  Usage:          If you are dealing with a range of objects and want to hide their concrete types or want to handle an array of generic protocols with associated types

import Foundation

protocol DataStore {
    associatedtype StoredType
    
    func store(_ object: StoredType, forKey key: String)
    func fetchObject(forKey key: String) -> StoredType?
}

class AnyDataStore<StoredType>: DataStore {
    private let storeObject: (StoredType, String) -> Void
    private let fetchObject: (String) -> StoredType?
    
    init<Store: DataStore>(_ store: Store) where Store.StoredType == StoredType {
        storeObject = store.store
        fetchObject = store.fetchObject
    }
    
    func store(_ object: StoredType, forKey key: String) {
        storeObject(object, key)
    }
    
    func fetchObject(forKey key: String) -> StoredType? {
        fetchObject(key)
    }
}

class InMemoryUrlStore: DataStore {
    typealias StoredType = URL
    private var urls = [String: URL]()
    
    func store(_ object: URL, forKey key: String) {
        urls[key] = object
    }
    
    func fetchObject(forKey key: String) -> URL? {
        return urls[key]
    }
}

class FileManagerUrlStore: DataStore {
    typealias StoredType = URL
    
    func store(_ object: URL, forKey key: String) {
        // store the URL
    }
    
    func fetchObject(forKey key: String) -> URL? {
        return nil
    }
}

// ERROR: Protocol 'DataStore' can only be used as a generic constraint because it has Self or associated type requirements
var stores: [DataStore] = [
    InMemoryUrlStore(),
    FileManagerUrlStore()
]

// This works
var anyStores: [AnyDataStore<URL>] = [
    AnyDataStore(InMemoryUrlStore()),
    AnyDataStore(FileManagerUrlStore())
]
