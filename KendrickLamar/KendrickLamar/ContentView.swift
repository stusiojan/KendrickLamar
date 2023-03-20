//
//  ContentView.swift
//  KendrickLamar
//
//  Created by Jan Stusio on 21/03/2023.
//

import SwiftUI

struct Response: Codable {
    var results: [Result]
}

struct Result: Codable {
    var trackId: Int
    var trackName: String
    var collectionName: String
}


struct ContentView: View {
    @State private var results = [Result]()
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: "https://www.cgm.pl/wp-content/uploads/2022/05/Kendrick-Lamar-771x450.jpg")) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .scaledToFit()
                } else if phase.error != nil {
                    Text("Error in loading the image.")
                } else {
                    ProgressView()
                }
            }
            .frame(maxWidth: .infinity)
            
            Text("Source: youtube.com")
                .font(.system(size: 10))
                .fontWeight(.light)
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom)
            
            Text("Kendrick")
                .font(.largeTitle) +
            Text("Lamar")
                .font(.largeTitle)
                .bold()
            
            List(results, id:\.trackId) { result in
                VStack(alignment: .leading) {
                    Text(result.trackName)
                        .font(.headline)
                    Text(result.collectionName)
                }
            }
            .listStyle(.plain)
            .task  {
                await loadData()
            }
        }
        .padding()
    }
    
    func loadData() async {
        //creating an URL
        guard let url = URL(string: "https://itunes.apple.com/search?term=kendrick+lamar&entity=song") else {
            print("Ups, wrong URL")
            return
        }
        //fetching data
        do {
            let (data, _) = try await URLSession.shared.data(from: url)//.shared is OK, because this app has basic needs, but class URLSession can handle data differently
            
            if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data) {
                results = decodedResponse.results
            }
        } catch {
            print("Ups, invalid data")
        }
        //decoding data
    }
}
