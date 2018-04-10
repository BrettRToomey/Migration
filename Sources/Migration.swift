import Fluent
import MySQLDriver

final class __DumyEntity: Entity {
    let storage: Storage

    func makeRow() throws -> Row {
        fatalError()
    }

    init(row: Row) throws {
        fatalError()
    }
}

final class ColumnDesc: NodeInitializable {
    let name: String
    let type: String
    let isNullable: Bool
    let defaultVal: String

    init(name: String, type: String, isNullable: Bool, defaultVal: String) {
        self.name = name
        self.type = type
        self.isNullable = isNullable
        self.defaultVal = defaultVal
    }

    init(node: Node) throws {
        name = try node.get("column_name")
        type = try node.get("column_type")
        let isNullableString: String = try node.get("is_nullable")
        isNullable = isNullableString == "YES"
        defaultVal = try node.get("column_default")
    }
}

extension ColumnDesc {
    func comp(field: Field) -> Bool {
        __DumyEntity.database = Database.init(PreparationDriver())
        let serializer = try! MySQLSerializer.init(__DumyEntity.makeQuery())

        guard
            name == field.name,
            type.lowercased() == serializer.type(field.type, primaryKey: field.primaryKey).lowercased(),
            isNullable == field.optional,
            defaultVal == field.default?.mySQLDefaultValue ?? ""
        else {
            return false
        }

        return true
    }
}

extension Node {
    // NOTE: pulled out of Fluent's internals
    var mySQLDefaultValue: String {
        switch wrapped {
        case .number(let n):
            return "'\(n.description)'"
        case .null:
            return "NULL"
        case .bool(let b):
            return  b ? "TRUE" : "FALSE"
        default:
            return  "'\((self.string ?? ""))'"
        }
    }
}

extension Database {
    var lastGeneratedSchema: Schema? {
        if let driver = self.driver as? PreparationDriver {
            return driver.schema
        }

        return nil
    }
}

final class PreparationDriver: Fluent.Driver {
    final class Con: Fluent.Connection {
        var schema: Schema?

        func query<E>(_ query: RawOr<Query<E>>) throws -> Node where E : Entity {
            if
                case let .some(query) = query,
                case let .schema(schema) = query.action
            {
                self.schema = schema
            }

            return Node.null
        }

        var queryLogger: QueryLogger?
        var isClosed: Bool { return false }
    }

    var idKey: String { return "id" }
    var idType: IdentifierType { return .int }
    var keyNamingConvention: KeyNamingConvention { return .camelCase }
    var queryLogger: QueryLogger?

    var con: Con?
    var schema: Schema? {
        return con?.schema
    }

    func makeConnection(_ type: ConnectionType) throws -> Fluent.Connection {
        let con = Con()
        self.con = con
        return con
    }
}

enum Fluent2 {
    func getSchema(_ preparation: Preparation.Type) -> Schema? {
        let db = Database(PreparationDriver())
        try? preparation.prepare(db)
        return db.lastGeneratedSchema
    }

    func getSchemas(_ preparations: [Preparation.Type]) -> [Schema] {
        return preparations.compactMap(getSchema)
    }
}
