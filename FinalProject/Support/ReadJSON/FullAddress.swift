// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let fullAddress = try? JSONDecoder().decode(FullAddress.self, from: jsonData)

import Foundation

// MARK: - FullAddressElement
class FullAddressElement: Codable {
    let id, code, name: String
    let districts: [District]

    init(id: String, code: String, name: String, districts: [District]) {
        self.id = id
        self.code = code
        self.name = name
        self.districts = districts
    }
}

// MARK: - District
class District: Codable {
    let id, name: String
    let wards, streets: [Street]
    let projects: [Project]

    init(id: String, name: String, wards: [Street], streets: [Street], projects: [Project]) {
        self.id = id
        self.name = name
        self.wards = wards
        self.streets = streets
        self.projects = projects
    }
}

// MARK: - Project
class Project: Codable {
    let id, name, lat, lng: String

    init(id: String, name: String, lat: String, lng: String) {
        self.id = id
        self.name = name
        self.lat = lat
        self.lng = lng
    }
}

// MARK: - Street
class Street: Codable {
    let id, name: String
    let p: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case p = "prefix"
    }

    init(id: String, name: String, p: String) {
        self.id = id
        self.name = name
        self.p = p
    }
}

typealias FullAddress = [FullAddressElement]
