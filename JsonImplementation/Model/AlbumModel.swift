//
//  AlbumModel.swift
//  JsonImplementation
//
//  Created by Siva Mouniker  on 25/07/23.
//

import Foundation

struct Album : Decodable {
    let userId: Int
    let id: Int
    let title: String
}

class AlbumModel {
    
    var albums: [Album] = []
    var userAlbums: [Int: [(id: Int, title: String)]] = [:]
    var sortedUserIds: [Int] = [] // To store sorted UserIDs
    
    func fetchAlbums(completion: @escaping (Error?) -> Void) {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/albums") else {
            completion(NSError(domain: "Invalid URL", code: 0, userInfo: nil))
            return
        }
        
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
    
    private func sortAlbumsAndGroup() {
        albums.sort(by: { $0.userId < $1.userId })
        
        for album in albums {
            if var userAlbums = userAlbums[album.userId] {
                userAlbums.append((id: album.id, title: album.title))
                self.userAlbums[album.userId] = userAlbums
            } else {
                userAlbums[album.userId] = [(id: album.id, title: album.title)]
            }
        }
        sortedUserIds = userAlbums.keys.sorted()
    }
}
