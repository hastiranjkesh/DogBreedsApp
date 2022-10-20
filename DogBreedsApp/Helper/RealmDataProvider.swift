//
//  RealmDataProvider.swift
//  DogBreedsApp
//
//  Created by hasti ranjkesh on 10/20/22.
//
import Foundation
import RealmSwift

protocol RealmDataProviderProtocol {
    func isRealmAccessible() -> Bool
    func objects<T: Object>(_ type: T.Type, predicate: NSPredicate?) -> Results<T>?
    func object<T: Object>(_ type: T.Type, key: String) -> T?
    func add<T: Object>(_ data: [T], update: Bool)
    func add<T: Object>(_ data: T, update: Bool)
    func runTransaction(action: () -> Void)
    func delete<T: Object>(_ data: [T], completion: @escaping () -> Void)
    func delete<T: Object>(_ data: T, completion: @escaping () -> Void)
    func objectStillExists<T: Object>(_ type: T.Type, key: String) -> Bool
}

final class RealmDataProvider<T>: RealmDataProviderProtocol where T: Object {
    func isRealmAccessible() -> Bool {
        do {
            _ = try Realm()
        } catch {
            print("Realm is not accessible")
            return false
        }
        return true
    }
    
    func objects<T: Object>(_ type: T.Type, predicate: NSPredicate? = nil) -> Results<T>? {
        if !isRealmAccessible() { return nil }
        do {
            let realm = try Realm()
            realm.refresh()
            return predicate == nil ? realm.objects(type) : realm.objects(type).filter(predicate!)
        } catch {
            return nil
        }
    }
    
    func object<T: Object>(_ type: T.Type, key: String) -> T? {
        if !isRealmAccessible() { return nil }
        do {
            let realm = try Realm()
            realm.refresh()
            return realm.object(ofType: type, forPrimaryKey: key)
        } catch {
            return nil
        }
    }
    
    func add<T: Object>(_ data: [T], update: Bool) {
        if !isRealmAccessible() { return }
        do {
            let realm = try Realm()
            realm.refresh()
            if realm.isInWriteTransaction {
                realm.add(data, update: update ? .all : .error)
            } else {
                try? realm.write {
                    realm.add(data, update: update ? .all : .error)
                }
            }
        } catch {
            print("Realm Error: Add failed")
        }
    }
    
    func add<T: Object>(_ data: T, update: Bool) {
        add([data], update: update)
    }
    
    func runTransaction(action: () -> Void) {
        if !isRealmAccessible() { return }
        do {
            let realm = try Realm()
            realm.refresh()
            if realm.isInWriteTransaction {
                action()
            } else {
                try? realm.write { action() }
            }
        } catch {
            print("Realm Erro: Run Transaction failed")
        }
    }
    
    func delete<T: Object>(_ data: [T], completion: @escaping () -> Void = {}) {
        if !isRealmAccessible() { return }
        do {
            let realm = try Realm()
            realm.refresh()
            if realm.isInWriteTransaction {
                realm.delete(data)
                completion()
            } else {
                try? realm.write {
                    realm.delete(data)
                    completion()
                }
            }
        } catch {
            print("Realm Error: Delete failed")
        }
    }
    
    func delete<T: Object>(_ data: T, completion: @escaping () -> Void = {}) {
        delete([data], completion: completion)
    }
    
    func objectStillExists<T: Object>(_ type: T.Type, key: String) -> Bool {
        return object(type, key: key) != nil
    }
}

