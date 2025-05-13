//
//  ContentView.swift
//  TestLMStudioV2
//
//  Created by Constant Lesfargues on 11/05/2025.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("apiURL") private var apiURL: String = "http://localhost:1234"
    @AppStorage("endpoint") private var endpoint: String = "/v1/chat/completions"
    @AppStorage("modelName") private var modelName: String = "meta-llama-3.1-8b-instruct"
    @AppStorage("useChatFormat") private var useChatFormat: Bool = true
    @AppStorage("useAPIKey") private var useAPIKey: Bool = false
    @AppStorage("apiKey") private var apiKey: String = ""
    
    @State private var prompt: String = ""
    @State private var response: String = ""
    @State private var isLoading = false
    @State private var showParameters = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                TextField("Pose ta question ici", text: $prompt)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                if isLoading {
                    ProgressView("Réflexion en cours…")
                } else {
                    ScrollView {
                        Text(response)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                }
                
                Button(action: envoyerAuLLM) {
                    Text("Envoyer")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
            }
            .navigationTitle("Assistant")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showParameters = true }) {
                        Image(systemName: "gearshape")
                    }
                }
            }
            .sheet(isPresented: $showParameters) {
                ParametresLLMView()
            }
            .background(KeyboardDismissTapArea())
        }
    }
    
    func envoyerAuLLM() {
        guard !prompt.isEmpty else { return }
        
        isLoading = true
        response = ""
        
        guard let url = URL(string: apiURL + endpoint) else {
            response = "URL invalide"
            isLoading = false
            return
        }
        
        var request = URLRequest(url: url, timeoutInterval: 120)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if useAPIKey && !apiKey.isEmpty {
            request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        }
        
        let json: [String: Any]
        if useChatFormat {
            json = [
                "model": modelName,
                "messages": [
                    ["role": "system", "content": "Tu es un assistant francophone, clair et utile."],
                    ["role": "user", "content": prompt]
                ],
                "temperature": 0.7
            ]
        } else {
            let instruction = "Tu es un assistant francophone, clair et utile."
            let fullPrompt = "\(instruction)\n\nUtilisateur : \(prompt)\nAssistant :"
            json = [
                "model": modelName,
                "prompt": fullPrompt,
                "temperature": 0.7
            ]
        }
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: json) else {
            response = "Erreur JSON"
            isLoading = false
            return
        }
        
        request.httpBody = httpBody
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            DispatchQueue.main.async {
                isLoading = false
                guard error == nil, let data = data else {
                    response = "Erreur réseau ou serveur injoignable"
                    return
                }
                
                if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let choices = json["choices"] as? [[String: Any]] {
                    if let message = choices.first?["message"] as? [String: Any],
                       let content = message["content"] as? String {
                        response = nettoyerTexte(content)
                    } else if let text = choices.first?["text"] as? String {
                        response = nettoyerTexte(text)
                    } else {
                        response = "Format de réponse inattendu"
                    }
                } else if let str = String(data: data, encoding: .utf8) {
                    response = "Réponse brute : \(str)"
                } else {
                    response = "Réponse illisible"
                }
            }
        }.resume()
    }
    
    func nettoyerTexte(_ texte: String) -> String {
        let balises = ["<|end|>", "<|assistant|>", "<|user|>", "<|system|>", "<|start|>"]
        var resultat = texte
        for balise in balises {
            resultat = resultat.replacingOccurrences(of: balise, with: "")
        }
        return resultat.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

#Preview {
    ContentView()
}
