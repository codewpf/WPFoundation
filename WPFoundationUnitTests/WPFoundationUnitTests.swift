//
//  WPFoundationUnitTests.swift
//  WPFoundationUnitTests
//
//  Created by Alex on 19/04/21.
//  Copyright © 2021 http://codewpf.com/. All rights reserved.
//

import XCTest
@testable import WPFoundation

class WPFoundationUnitTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testRemovedGivenElement() {
        var origin: [Int] = [1,2,3,4,5,6,7,8,9,0]
        let element: Int = 5
        let after: [Int] = [1,2,3,4,6,7,8,9,0]
        
        origin.removed(object: element)
        
        XCTAssertEqual(origin, after)
    }
    
    func testRemoveGivenElement() {
        let origin: [Int] = [1,2,3,4,5,6,7,8,9,0]
        let element: Int = 5
        let after: [Int] = [1,2,3,4,6,7,8,9,0]
        
        let result = origin.remove(object: element)
        
        XCTAssertEqual(result, after)
    }
    
    func testRemoveDuplicateElement() {
        let origin: [Int] = [1,1,3,3,5,5,7,7,9,9]
        let after: [Int] = [1,3,5,7,9]
        
        let result = origin.removeDuplicate()
        
        XCTAssertEqual(result, after)
    }
    
    func testUniqueElement() {
        let origin: [Int] = [1,1,3,3,5,5,7,7,9,9]
        let after: [Int] = [1,3,5,7,9]
        
        let result = origin.unique
        
        XCTAssertEqual(result, after)
    }
    
    
    func testStringLenght() {
        let origin: String = "string"
        let after: Int = 6
        
        let result: Int = origin.length
        
        XCTAssertEqual(result, after)
    }
    
    func testMD5String() {
        let origin: String = "md5string"
        let after: String = "ECDE697067DD080B187996A22550F6F3"
        
        let result = origin.md5.uppercased()
        
        XCTAssertEqual(result, after)
    }
    
    func testSubstringFrom() {
        let origin: String = "testSubstringFrom"
        let after: String = "SubstringFrom"
        
        let result = origin.substring(from: 4)
        
        XCTAssertEqual(result, after)
    }
    
    func testSubstringTo() {
        let origin: String = "testSubstringFrom"
        let after: String = "test"
        
        let result = origin.substring(to: 4)
        
        XCTAssertEqual(result, after)
    }
    
    func testSubstringRange() {
        let origin: String = "testSubstringFrom"
        let after: String = "Substring"
        
        let result = origin.substring(range: NSRange(location: 4, length: 9))
        
        XCTAssertEqual(result, after)
    }
    
    func testReplaceString() {
        let origin: String = "testSubstringFrom"
        let after: String = "testReplaceFrom"
        
        let result = origin.replace(range: NSRange(location: 4, length: 9), place: "Replace")
        
        XCTAssertEqual(result, after)
    }
    
    func testContainsString() {
        let origin: String = "testContainsString"
        let string: String = "Contains"
        
        let result = origin.contains(string)
        
        XCTAssert(result)
    }

    func testMatchesString() {
        let origin: String = "abc abbc abbbc abbbbc abbbbbc abbbbbbc"
        let after: [String] = ["abbc", "abbbc", "abbbbc", "abbbbbc"]
        
        let result = origin.matches(for: "ab{2,5}c")
        
        XCTAssertEqual(result, after)
    }

    
    func testAppVersionCompare() {
        
        XCTAssert("0010".compareVersion(with: "0010.1") == -1)

        XCTAssert("1.01".compareVersion(with: "1.001") == 0)

        XCTAssert("2.2.1".compareVersion(with: "2.2.0") == 1)
        XCTAssert("2.2.1".compareVersion(with: "2.1.9") == 1)
        XCTAssert("2.2.1".compareVersion(with: "2.2.1") == 0)
        XCTAssert("2.2".compareVersion(with: "2.1.1") == 1)
        XCTAssert("2.2".compareVersion(with: "2.2.1") == -1)
        XCTAssert("2.2.3.1".compareVersion(with: "2.2.3.5") == -1)

        XCTAssert("2.2.3.1".compareVersion(with: "2.2.3.0") == 1)
        XCTAssert("2.2".compareVersion(with: "2.2.1.4.5") == -1)
        XCTAssert("2.2.3.4".compareVersion(with: "2.2.4.4.5") == -1)
        XCTAssert("3.0.0.1".compareVersion(with: "3.0.0.0.1") == 1)

        XCTAssert("2.2.1".compareVersion(with: "2.2.01") == 0)
        XCTAssert("2.2.3.4.5.6".compareVersion(with: "2.2.3.4.5.12") == -1)
        XCTAssert("2.2.3.4.5.6".compareVersion(with: "2.2.2.4.5.12") == 1)
        
    }

}
