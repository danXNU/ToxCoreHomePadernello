//
//  ToxCoreHomeTests.swift
//  ToxCoreHomeTests
//
//  Created by Dani Tox on 30/08/2018.
//  Copyright © 2018 Dani Tox. All rights reserved.
//

import XCTest
@testable import ToxCoreHome

class ToxCoreHomeTests: XCTestCase {

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        testFetchingClasses()
        testObjectsFetching()
    }
    
    var fetchedObjects : [ToxObject] = []
    func testObjectsFetching() {
        let server = try? ToxSocket<String, [ToxObject]>()
        XCTAssertNotNil(server)
        let request = ToxRequest(type: ToxRequestEnum.showObjects, body: "")
        server?.send(request: request, completionHandler: { (objects, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(objects)
            fetchedObjects = objects!
            print("Objects count: \(objects!.count)")
        })
        
    }
    
    var fecthedClasses : [String] = []
    func testFetchingClasses() {
        let server = try? ToxSocket<String, [String]>()
        XCTAssertNotNil(server)
        let request = ToxRequest(type: ToxRequestEnum.showClasses, body: "")
        server?.send(request: request, completionHandler: { (classes, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(classes)
            fecthedClasses = classes!
            print("Classes count: \(classes!)")
        })
    }
    
    func testCreateObject() {
        let objectsToCreateCount = Int.random(in: 0...10)
        
        let objectCountBefore = fetchedObjects.count
        
        for _ in 0..<objectsToCreateCount {
            let name = String.randomString(length: 10)
            
            let classes = fecthedClasses
            XCTAssertGreaterThan(classes.count, 0)
            let className = classes[Int.random(in: 0..<classes.count)]
            
            let object = ToxObject(name: name, desc: "Nessuna", className: className)
            
            object.addMeOnServer { (error) in
                XCTAssertNil(error)
                testObjectsFetching()
            }
        }
        
        let objectCountAfter = fetchedObjects.count
        
        if objectCountAfter != (objectCountBefore + objectsToCreateCount) {
            XCTFail("ObjectsCountBefore = \(objectCountBefore)\nAfter:\(objectCountAfter)\nCoutToCreate:\(objectsToCreateCount)")
        }
        
        
    }
    
    func testRemoveObject() {
        let object = fetchedObjects[Int.random(in: 0..<fetchedObjects.count)]
        XCTAssertNotNil(object.id)
        
        let server = try? ToxSocket<[String: Int], String>()
        XCTAssertNotNil(server)
        let body = ["object_id" : object.id!]
        let request = ToxRequest(type: ToxRequestEnum.removeObject, body: body)
        
        server?.send(request: request, completionHandler: { (returnMsg, error) in
            XCTAssertNil(error)
        })
        
    }
    
    func testExecuteMessage() {
        let objects = fetchedObjects
        XCTAssertGreaterThan(objects.count, 0)
        
        for object in objects {
            let messages = object.messages
            XCTAssertNotNil(messages)
            
            for message in messages! {
                object.execute(message: message) { (error) in
                    XCTAssertNil(error)
                }
            }
        }
    }

    
    func testAddAndRemoveHandler() {
        
        let objects = fetchedObjects
        
        let object = objects.first
        XCTAssertNotNil(object)
        XCTAssertNotNil(object?.id)
        XCTAssertNotNil(object?.handlers.keys)
        
        let keys = Array((object?.handlers.keys)!)
        XCTAssertGreaterThanOrEqual(keys.count, 1)
        
        
        let randomKey = keys[Int.random(in: 0..<keys.count)]
        
        let handlerObject = objects[Int.random(in: 0..<objects.count)]
        XCTAssertNotNil(handlerObject.id)
        
        let handlerObjectMessages = handlerObject.messages
        XCTAssertNotNil(handlerObjectMessages)
        
        let messagesCount = handlerObjectMessages!.count
        XCTAssertGreaterThan(messagesCount, 0)
        
        let randomMessage = handlerObjectMessages![Int.random(in: 0..<messagesCount)]
        
        let function = ToxFunction()
        function.functionName = randomMessage
        function.objectID = handlerObject.id!
        
        let handler = ToxHandler(funct: function)
        handler.idObjectOwner = object?.id!
        handler.key = randomKey
        
        
        
        object!.addHandlerOnServer(handler, completion: { (error) in
            XCTAssertNil(error)
        })
        
        object?.fetchHandlers(completion: { (error) in
            XCTAssertNil(error)
        })
        
        let handlerToRemove = object?.handlers[randomKey]?.last
        XCTAssertNotNil(handlerToRemove)
        XCTAssertNotNil(handlerToRemove!.id)
        
        object!.remove(handler: handlerToRemove!.id, completion: { (error) in
            XCTAssertNil(error)
        })
    }
    
    func testChangeProperties() {
        let objects = fetchedObjects
        let randomIndex = Int.random(in: 0..<objects.count)
        
        let object = objects[randomIndex]
        let currProperties = object.customVariables
        
        let keys = Array(currProperties.keys)
        XCTAssertGreaterThan(keys.count, 0)
        
        var changedDict : [String : ToxArbitraryValueType] = [:]
        for key in keys {
            let type = currProperties[key]!.valueType
            if type == "Int" {
                let newValue = Int.random(in: 0...100)
                changedDict[key] = ToxArbitraryValueType.int(newValue)
            } else if type == "Float" {
                let newValue = Float.random(in: 0.0...100.0)
                changedDict[key] = ToxArbitraryValueType.float(newValue)
            } else {
                let newValue = String.randomString(length: 15)
                changedDict[key] = ToxArbitraryValueType.string(newValue)
            }
        }
        if changedDict == [:] {
            XCTFail("changeDict is empty")
        }
        print(changedDict)
        object.change(properties: changedDict) { (error) in
            XCTAssertNil(error)
        }
        
    }
    
    
}
