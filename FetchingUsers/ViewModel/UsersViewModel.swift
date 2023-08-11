//
//  UsersViewModel.swift
//  FetchingUsersMVVM
//
//  Created by Alex Murphy on 27.06.2023.
//

import Foundation

final class UsersViewModel {

//	enum UserFetchError: Error {
//		case invalidUrl
//		case unknown
//	}

//	let sourceURL = URL(string: "https://jsonplaceholder.typicode.com/users")!
//	var usersModel: DataModel?
	var usersArray: [Users]?

	// MARK: - Fetch users
	func fetchUsers(completion: @escaping (Result<[Users], Error>) -> Void) throws {
		guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else {
			throw UserFetchError.invalidUrl
		}
		let task = URLSession.shared.dataTask(with: url) { /*[weak self]*/ data, _, error in
			if let error = error {
				completion(.failure(error))
			}
			else if let data = data {
				do {
//					let decoder = JSONDecoder()
//					let allUsers = try decoder.decode([Users].self, from: data)
					let result = try JSONDecoder().decode([Users].self, from: data)
					self.usersArray? = result
//					print(result.count)
					completion(.success(result))
				} catch {
					completion(.failure(error))
				}
			} else {
				completion(.failure(UserFetchError.unknown))
			}
		}
		task.resume()
	}
}
