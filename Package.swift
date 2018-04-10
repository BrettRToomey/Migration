//https://github.com/vapor-community/mysql-provider.git
import PackageDescription

let package = Package(
    name: "Migration",
    dependencies: [
        .Package(url: "https://github.com/vapor-community/mysql-provider.git", majorVersion: 2)
    ]
)
