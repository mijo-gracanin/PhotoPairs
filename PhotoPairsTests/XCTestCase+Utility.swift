//
//  XCTestCase+Utility.swift
//  PhotoPairsTests
//
//

import Foundation
import XCTest
import Combine

extension XCTestCase {
    //  https://www.swiftbysundell.com/articles/writing-testable-code-when-using-swiftui/
    func waitUntil<T: Equatable>(
        _ propertyPublisher: Published<T>.Publisher,
        equals expectedValue: T,
        timeout: TimeInterval = 5,
        file: StaticString = #file,
        line: UInt = #line
    ) ->  XCTestExpectation {
        let expectation = expectation(
            description: "Awaiting value \(expectedValue)"
        )
        
        var cancellable: AnyCancellable?

        cancellable = propertyPublisher
            .dropFirst()
            .first(where: { $0 == expectedValue })
            .sink { value in
                XCTAssertEqual(value, expectedValue, file: file, line: line)
                cancellable?.cancel()
                expectation.fulfill()
            }

        return expectation
    }
}
