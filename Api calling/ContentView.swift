//
//  ContentView.swift
//  Api calling
//
//  Created by Jakub Wilk on 4/30/23.

import SwiftUI

struct ContentView: View {
    @State private var facts = [String]()
    @State private var showingAlert = false
    var body: some View {
        NavigationView {
            List(facts, id: \.self) { fact in
                Text(fact)
            }
            .navigationTitle("Random Cat Facts")
            .toolbar {
                Button(action: {
                    Task {
                        await loadData()
                    }
                }, label: {
                    Image(systemName: "arrow.clockwise")
                })
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text("Loading Error"),
                          message: Text("There was a problem loading the API categories"),
                          dismissButton: .default(Text("OK")))
                }
            }
        }
        .task {
            await loadData()
        }
    }
    
    
    func loadData() async {
        if let url = URL(string: "https://meowfacts.herokuapp.com/?count=20")  {
            if let (data, _) = try? await URLSession.shared.data(from: url) {
                if let decodedResponse = try? JSONDecoder().decode(Facts.self, from: data) {
                    facts = decodedResponse.facts
                }
            }
        }
        showingAlert = true
    }
}

    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
    
    struct Facts: Identifiable, Codable {
        var id = UUID()
        var facts: [String]
        
        enum CodingKeys: String, CodingKey {
            case facts = "data"
        }
    }
