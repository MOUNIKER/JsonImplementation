//
//  AlbumModel.swift
//  JsonImplementation
//
//  Created by Siva Mouniker  on 25/07/23.
//

import Foundation

// MARK: - Album Model

struct Album : Decodable {
    let userId: Int
    let id: Int
    let title: String
}

class AlbumModel {
    
    // MARK: - Properties
    
    var albums: [Album] = []
    var userAlbums: [Int: [(id: Int, title: String)]] = [:]
    var sortedUserIds: [Int] = [] // To store sorted UserIDs
    
    // MARK: - Fetch Albums
    
    func fetchAlbums(completion: @escaping (Error?) -> Void) {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/albums") else {
            completion(NSError(domain: "Invalid URL", code: 0, userInfo: nil))
            return
        }
        
        // Make a network request to fetch albums data
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let data = data, error == nil else {
                completion(error)
                return
            }
            
            do {
                let albums = try JSONDecoder().decode([Album].self, from: data)
                self?.albums = albums
                self?.sortAlbumsAndGroup()
                completion(nil)
            } catch {
                completion(error)
            }
        }.resume()
    }
    
    // MARK: - Sort Albums and Group
    
    private func sortAlbumsAndGroup() {
        albums.sort(by: { $0.userId < $1.userId }) // Sort the albums array based on User ID
        
        for album in albums {
            if var userAlbums = userAlbums[album.userId] {
                // Append the album to the existing user albums
                userAlbums.append((id: album.id, title: album.title))
                self.userAlbums[album.userId] = userAlbums
            } else {
                // Create a new user album entry
                userAlbums[album.userId] = [(id: album.id, title: album.title)]
            }
        }
        // Store sorted User IDs for table view sections
        sortedUserIds = userAlbums.keys.sorted()
    }
}
