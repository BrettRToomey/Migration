import XCTest
import Fluent

@testable import Migration

final class MigrationTests: XCTestCase {
    func testCanCompareDescAndField() {
        let desc = ColumnDesc(
            name: "testField",
            type: "VARCHAR(255)",
            isNullable: false,
            defaultVal: ""
        )

        let field = Field(
            name: "testField",
            type: .string(length: 255),
            optional: false,
            unique: false,
            default: nil,
            primaryKey: false
        )

        XCTAssertTrue(desc.comp(field: field))
    }

    func testCanCompareDescAndFieldInt() {
        let desc = ColumnDesc(
            name: "testField",
            type: "int(11)",
            isNullable: false,
            defaultVal: ""
        )

        let field = Field(
            name: "testField",
            type: .int,
            optional: false,
            unique: false,
            default: nil,
            primaryKey: false
        )

        XCTAssertTrue(desc.comp(field: field))
    }

    func testCanCompareDescAndFieldIdentifier() {
        let desc = ColumnDesc(
            name: "testField",
            type: "int(10) unsigned",
            isNullable: false,
            defaultVal: ""
        )

        let field = Field(
            name: "testField",
            type: .id(type: .int),
            optional: false,
            unique: false,
            default: nil,
            primaryKey: false
        )

        XCTAssertTrue(desc.comp(field: field))
    }

    func testCanCompareDescAndFieldIdentifierPrimary() {
        let desc = ColumnDesc(
            name: "testField",
            type: "int(10) unsigned primary key auto_increment",
            isNullable: false,
            defaultVal: ""
        )

        let field = Field(
            name: "testField",
            type: .id(type: .int),
            optional: false,
            unique: false,
            default: nil,
            primaryKey: true
        )

        XCTAssertTrue(desc.comp(field: field))
    }

    func testCanCompareDescAndFieldBool() {
        let desc = ColumnDesc(
            name: "testField",
            type: "tinyint(1) unsigned",
            isNullable: false,
            defaultVal: ""
        )

        let field = Field(
            name: "testField",
            type: .bool,
            optional: false,
            unique: false,
            default: nil,
            primaryKey: false
        )

        XCTAssertTrue(desc.comp(field: field))
    }

    func testCanCompareDescAndFieldCustom() {
        let desc = ColumnDesc(
            name: "testField",
            type: "smalltext",
            isNullable: false,
            defaultVal: ""
        )

        let field = Field(
            name: "testField",
            type: .custom(type: "SMALLTEXT"),
            optional: false,
            unique: false,
            default: nil,
            primaryKey: false
        )

        XCTAssertTrue(desc.comp(field: field))
    }
}
