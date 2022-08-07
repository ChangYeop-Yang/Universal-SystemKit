/*
 * Copyright (c) 2022 ChangYeop-Yang. All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import CoreData
import Foundation

public class SKCoreData: NSObject {
    
    // MARK: - Typealias
    public typealias CoreDataErrorHandler = (NSError) -> Swift.Void
    private typealias CoreDataAttribute = (modelPath: String, persistentPath: String)
    
    // MARK: - Object Properties
    public static let label: String = "com.SystemKit.SKCoreData"
    private let implementQueue = DispatchQueue(label: SKCoreData.label, qos: .userInitiated, attributes: .concurrent)
    private var attribute: CoreDataAttribute
    private var inContext: NSManagedObjectContext?
    
    // MARK: - Initalize
    public init(modelPath: String, persistentPath: String) {
        self.attribute.modelPath = modelPath
        self.attribute.persistentPath = persistentPath
    }
    
    public convenience init(managedContext: NSManagedObjectContext) {
        self.init(modelPath: "", persistentPath: "")
        self.inContext = managedContext
    }
}

// MARK: - Private Extension SKCoreData
private extension SKCoreData {
    
    final func createRequest<T: NSManagedObject>(entityName: String,
                                                 predicate: NSPredicate? = nil,
                                                 sortDescriptors: [NSSortDescriptor] = Array.init(),
                                                 fetchLimit: Int = Int.max) -> NSFetchRequest<T> {
        
        let request = NSFetchRequest<T>(entityName: entityName)
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors
        request.fetchLimit = fetchLimit
        
        return request
    }
}

// MARK: - Public Extension SKCoreData
public extension SKCoreData {
    
    @available(macOS 10.12, *)
    @discardableResult
    final func open() -> Bool {
        
        self.implementQueue.sync {
            
            
            return true
        }
    }
    
    final func insert<T: NSManagedObject>(object: T...) {
        
        self.implementQueue.async(flags: .barrier) { [weak self] in
            
            guard let self = self, let context = self.inContext else { return }
            
            object.forEach { item in context.insert(item) }
        }
    }
    
    final func insert<T: NSManagedObject>(objects: [T]) {
        
        self.implementQueue.async(flags: .barrier) { [weak self] in
            
            guard let self = self, let context = self.inContext else { return }
            
            objects.forEach { item in context.insert(item) }
        }
    }
    
    final func delete<T: NSManagedObject>(objects: [T]) {
        
        self.implementQueue.async(flags: .barrier) { [weak self] in
            
            guard let self = self, let context = self.inContext else { return }
            
            objects.forEach { target in context.delete(target) }
        }
    }
    
    final func delete<T: NSManagedObject>(object: T...) {
        
        self.implementQueue.async(flags: .barrier) { [weak self] in
            
            guard let self = self, let context = self.inContext else { return }
            
            object.forEach { target in context.delete(target) }
        }
    }
    
    final func first(entityName: String, predicate: NSPredicate? = nil) -> Optional<NSManagedObject> {
        
        self.implementQueue.sync { [weak self] in
                        
            guard let self = self, let context = self.inContext else { return nil }
            
            let request = self.createRequest(entityName: entityName, predicate: predicate, fetchLimit: 1)
            
            do { return try context.fetch(request).first }
            catch let error as NSError {
                NSLog(error.description)
                return nil
            }
        }
    }
    
    final func last(entityName: String, predicate: NSPredicate? = nil) -> Optional<NSManagedObject> {
        
        self.implementQueue.sync { [weak self] in
            
            guard let self = self, let context = self.inContext else { return nil }
                        
            let request = self.createRequest(entityName: entityName, predicate: predicate, fetchLimit: 1)
            
            do { return try context.fetch(request).last }
            catch let error as NSError {
                NSLog(error.description)
                return nil
            }
        }
    }
    
    final func fetch(entityName: String,
                     predicate: NSPredicate? = nil,
                     sortDescriptors: [NSSortDescriptor] = Array.init(),
                     fetchLimit: Int = Int.max,
                     errorHandler: CoreDataErrorHandler? = nil) -> [NSManagedObject] {
        
        self.implementQueue.sync { [weak self] in
                                    
            guard let self = self, let context = self.inContext else { return Array.init() }
            
            let request = self.createRequest(entityName: entityName, predicate: predicate,
                                             sortDescriptors: sortDescriptors, fetchLimit: fetchLimit)
            
            do { return try context.fetch(request) }
            catch let error as NSError {
                errorHandler?(error)
                return Array.init()
            }
        }
    }
    
    final func update<T: NSManagedObject>(object: T,
                                          errorHandler: Optional<CoreDataErrorHandler> = nil) {
        
        self.implementQueue.async(flags: .barrier) { [weak self] in
            
            guard let self = self, let context = self.inContext else { return }
            
            // NSManagedObject 대상이 현재 삭제가 된 상태인 경우에는 업데이트 작업을 수행하지 않습니다.
            if object.isDeleted { return }
            
            // NSManagedObject 대상이 변경 사항이 없는 경우에는 업데이트 작업을 수행하지 않습니다.
            guard object.isUpdated else { return }
            
            do { try context.save() }
            catch let error as NSError {
                NSLog(error.description)
                errorHandler?(error)
            }
        }
    }
    
    /**
        - NOTE: `hasChanges` true if you have inserted, deleted or updated the object (a combination of the following properties)
     */
    final func save(errorHandler: CoreDataErrorHandler? = nil) {
        
        self.implementQueue.async(flags: .barrier) { [weak self] in
            
            guard let self = self, let context = self.inContext else { return }
            
            // CoreData 저장 된 데이터들에 대하여 변경사항이 존재하지 않는 경우에는 영구 저장 작업을 수행하지 않습니다.
            guard context.hasChanges else { return }
            
            do { try context.save() }
            catch let error as NSError {
                NSLog(error.description)
                errorHandler?(error)
            }
        }
    }
    
    final func createObject<T: NSManagedObject>(forEntityName: String) -> T? {
        
        guard let context = self.inContext else { return nil }
        
        guard let entity = NSEntityDescription.entity(forEntityName: forEntityName, in: context) else { return nil }
        
        return NSManagedObject(entity: entity, insertInto: context) as? T
    }
}
