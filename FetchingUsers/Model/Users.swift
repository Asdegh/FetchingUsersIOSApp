//
//  Users.swift
//  FetchingUsers
//
//  Created by Alex Murphy on 25.10.2022.
//
import Foundation

public struct Users: Codable {
    public let name: String
    public let username: String
    public let email: String
    public let address: Address
    public let phone: String
}
public struct Address: Codable {
    public let street: String
    public let suite: String
    public let city: String
}

enum UserFetchError: Error {
	case invalidUrl
	case unknown
}
