//===----------------------------------------------------------------------===//
//
// This source file is part of the SwiftOpenAPIGenerator open source project
//
// Copyright (c) 2023 Apple Inc. and the SwiftOpenAPIGenerator project authors
// Licensed under Apache License v2.0
//
// See LICENSE.txt for license information
// See CONTRIBUTORS.txt for the list of SwiftOpenAPIGenerator project authors
//
// SPDX-License-Identifier: Apache-2.0
//
//===----------------------------------------------------------------------===//
import XCTest
import OpenAPIKit30
@testable import _OpenAPIGeneratorCore

final class Test_ContentSwiftName: Test_Core {

    func testExisting() throws {
        let nameMaker = makeTranslator(featureFlags: []).contentSwiftName
        let cases: [(String, String)] = [
            ("application/json", "json"),
            ("application/x-www-form-urlencoded", "binary"),
            ("multipart/form-data", "binary"),
            ("text/plain", "text"),
            ("*/*", "binary"),
            ("application/xml", "binary"),
            ("application/octet-stream", "binary"),
            ("application/myformat+json", "json"),
            ("foo/bar", "binary"),
        ]
        try _testIdentifiers(cases: cases, nameMaker: nameMaker)
    }

    func testProposed() throws {
        let nameMaker = makeTranslator(featureFlags: [.multipleContentTypes]).contentSwiftName
        let cases: [(String, String)] = [
            ("application/json", "unsupported"),
            ("application/x-www-form-urlencoded", "unsupported"),
            ("multipart/form-data", "unsupported"),
            ("text/plain", "unsupported"),
            ("*/*", "unsupported"),
            ("application/xml", "unsupported"),
            ("application/octet-stream", "unsupported"),
            ("application/myformat+json", "unsupported"),
            ("foo/bar", "unsupported"),
        ]
        try _testIdentifiers(cases: cases, nameMaker: nameMaker)
    }

    func _testIdentifiers(cases: [(String, String)], nameMaker: (ContentType) -> String) throws {
        for item in cases {
            let contentType = try XCTUnwrap(ContentType(item.0))
            XCTAssertEqual(nameMaker(contentType), item.1, "Case \(item.0) failed")
        }
    }
}
