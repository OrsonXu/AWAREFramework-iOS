//
//  Tests.swift
//  Tests
//
//  Created by Yuuki Nishiyama on 2019/04/04.
//  Copyright © 2019 tetujin. All rights reserved.
//

import XCTest
import AWAREFramework

class Tests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        //CoreDataHandler.shared().deleteLocalStorage(withName: "AWARE", type: "sqlite")
        
        AWARECore.shared()
        AWAREStudy.shared()
        AWARESensorManager.shared()
        
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testLimitedDataFetch(){
        
        let acc = Accelerometer()
        
        var array = Array<Dictionary<String,Any>>()
        for i in 0...999 {
            var dict = Dictionary<String,Any>()
            dict.updateValue(AWAREUtils.getUnixTimestamp(Date().addingTimeInterval(TimeInterval(i))), forKey: "timestamp")
            dict.updateValue(AWAREStudy.shared().getDeviceId(), forKey: "device_id")
            dict.updateValue(0, forKey: "double_values_0")
            dict.updateValue(1, forKey: "double_values_1")
            dict.updateValue(2, forKey: "double_values_2")
            dict.updateValue(3, forKey: "accuracy")
            dict.updateValue("\(i)", forKey: "label")
            array.append(dict)
        }
        print(array.count)
        acc.storage?.saveData(with: array, buffer: false, saveInMainThread: true)
        let expectation = XCTestExpectation(description: "test")
        acc.storage?.fetchData(from: Date().addingTimeInterval(-1*60*60*24), to: Date().addingTimeInterval(1000), limit: 10, all: false, handler: { (name, data, from, to, isEnd, error) in
            print(name, data!.count)
            if(isEnd){
                print("done")
                DispatchQueue.main.async {
                    expectation.fulfill()
                }
            }else{
                print("continue")
                
            }
        })
        wait(for: [expectation], timeout: 10)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
