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
    private var attribute: Optional<CoreDataAttribute> = nil
    private var inContext: Optional<NSManagedObjectContext> = nil
    
    // MARK: - Initalize
    @available(macOS 10.12, *)
    public init(modelPath: String, persistentPath: String) {
        self.attribute = CoreDataAttribute(modelPath, persistentPath)
    }
    
    public init(managedContext: NSManagedObjectContext) {
        self.inContext = managedContext
    }
    
    public convenience init(concurrencyType: NSManagedObjectContextConcurrencyType) {
        let managedContext = NSManagedObjectContext(concurrencyType: concurrencyType)
        self.init(managedContext: managedContext)
    }
}

// MARK: - Private Extension SKCoreData
private extension SKCoreData {
    
    final func createRequest<T: NSManagedObject>(entity: T.Type,
                                                 predicate: NSPredicate? = nil,
                                                 sortDescriptors: [NSSortDescriptor] = Array.init(),
                                                 fetchLimit: Int = Int.max) -> NSFetchRequest<T> {
        
        let entityName = String(describing: entity)
        
        let request = NSFetchRequest<T>(entityName: entityName)
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors
        request.fetchLimit = fetchLimit
        
        return request
    }
    
    typealias PerformAndWaitBlock = (NSManagedObjectContext) -> Swift.Void
    final func performAndWait(_ syncBlock: @escaping PerformAndWaitBlock) {
        
        guard let context = self.inContext else { return }
        
        context.performAndWait { syncBlock(context) }
    }

    typealias PerformBlock = (NSManagedObjectContext) -> Swift.Void
    final func perform(_ asyncBlock: @escaping PerformBlock) {
        
        guard let context = self.inContext else { return }
        
        context.perform { asyncBlock(context) }
    }
}

// MARK: - Public Extension SKCoreData With Properties
public extension SKCoreData {
    
    var managedContext: Optional<NSManagedObjectContext> {
        self.implementQueue.sync { return self.inContext }
    }
}

// MARK: - Public Extension SKCoreData With Method
public extension SKCoreData {
    
    @available(macOS 10.12, *)
    @discardableResult
    final func open() -> Bool {
        
        self.implementQueue.sync {
            
            guard let attribute = self.attribute else { return false }
            
            // CoreData Model 파일이 정상적으로 존재하는지 확인합니다.
            guard FileManager.default.fileExists(atPath: attribute.modelPath) else { return false }
            
            return true
        }
    }
    
    final func insert<T: NSManagedObject>(object: T...) {
        
        self.perform { context in
            object.forEach { item in context.insert(item) }
        }
    }
    
    final func insert<T: NSManagedObject>(objects: [T]) {
        
        self.perform { context in
            objects.forEach { item in context.insert(item) }
        }
    }
    
    final func delete<T: NSManagedObject>(objects: [T]) {
        
        self.perform { context in
            objects.forEach { target in context.delete(target) }
        }
    }
    
    final func delete<T: NSManagedObject>(object: T...) {
        
        self.perform { context in
            object.forEach { target in context.delete(target) }
        }
    }
    
    final func fetch<T: NSManagedObject>(entity: T.Type,
                                         predicate: NSPredicate? = nil,
                                         sortDescriptors: [NSSortDescriptor] = Array.init(),
                                         fetchLimit: Int = Int.max,
                                         errorHandler: Optional<CoreDataErrorHandler> = nil) -> [T] {
        
        var result: [T] = Array.init()
        
        self.performAndWait { context in
            
            let request = self.createRequest(entity: entity, predicate: predicate,
                                             sortDescriptors: sortDescriptors, fetchLimit: fetchLimit)
            
            
            do { result = try context.fetch(request) }
            catch let error as NSError {
                NSLog(error.description)
                errorHandler?(error)
                return
            }
        }
        
        return result
    }
    
    final func update<T: NSManagedObject>(object: T, errorHandler: Optional<CoreDataErrorHandler> = nil) {
        
        self.perform { [weak self] context in
            
            guard let self = self else { return }
            
            // NSManagedObject 대상이 현재 삭제가 된 상태인 경우에는 업데이트 작업을 수행하지 않습니다.
            if object.isDeleted { return }
            
            // NSManagedObject 대상이 변경 사항이 없는 경우에는 업데이트 작업을 수행하지 않습니다.
            guard object.isUpdated else { return }
            
            self.save(errorHandler: errorHandler)
        }
    }
    
    /**
        - NOTE: `hasChanges` true if you have inserted, deleted or updated the object (a combination of the following properties)
     */
    final func save(errorHandler: Optional<CoreDataErrorHandler> = nil) {
        
        self.performAndWait { context in
            
            // CoreData 저장 된 데이터들에 대하여 변경사항이 존재하지 않는 경우에는 영구 저장 작업을 수행하지 않습니다.
            guard context.hasChanges else { return }
            
            do { try context.save() }
            catch let error as NSError {
                NSLog(error.description)
                errorHandler?(error)
            }
        }
    }
    
    final func createObjectWithInsert(forEntityName: String, insertInto: NSManagedObjectContext) -> Optional<NSManagedObject> {
                
        guard let entity = NSEntityDescription.entity(forEntityName: forEntityName, in: insertInto) else { return nil }
        
        return NSManagedObject(entity: entity, insertInto: insertInto)
    }
}
