//
//  ParametresLLMView.swift
//  TestLMStudioV2
//
//  Created by Constant Lesfargues on 11/05/2025.
//

import SwiftUI

struct ParametresLLMView: View {
    @Environment(\.dismiss) var dismiss

    enum ProfilLLM: String, CaseIterable, Identifiable {
        case local = "Local"
        case reseau = "Réseau"
        case custom = "Personnalisé"

        var id: String { rawValue }

        var configuration: (url: String, endpoint: String, model: String, useAPIKey: Bool, apiKey: String, chatFormat: Bool) {
            switch self {
            case .local:
                return ("http://localhost:1234", "/v1/chat/completions", "meta-llama-3.1-8b-instruct", false, "", true)
            case .reseau:
                return (
                    "http://iachat.univ-pau.fr:11434",
                    "/v1/chat/completions",
                    "incept5/llama3.1-claude:latest",
                    true,
                    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6ImY3NTYwODhkLTI1NjEtNGEyYy1hY2YzLTM5ODc0ZTJiNzNjOSJ9.J9iPvhQqOAyylJa_uDt9qv9lFLfqxfC7uvqqX5-wxDg",
                    true
                )
            case .custom:
                return ("", "", "", false, "", true)
            }
        }
    }

    @AppStorage("apiURL") var apiURL: String = "http://localhost:1234"
    @AppStorage("endpoint") var endpoint: String = "/v1/chat/completions"
    @AppStorage("modelName") var modelName: String = "meta-llama-3.1-8b-instruct"
    @AppStorage("useChatFormat") var useChatFormat: Bool = true
    @AppStorage("useAPIKey") var useAPIKey: Bool = false
    @AppStorage("apiKey") var apiKey: String = ""

    @State private var selectedProfile: ProfilLLM = .custom
    @State private var testResponse: String = ""
    @State private var isLoading = false

    var body: some View {
        NavigationView {
            ZStack {
                Color.clear // pour capter le tap

                Form {
                    Section(header: Text("Choix du profil")) {
                        Picker("Profil", selection: $selectedProfile) {
                            ForEach(ProfilLLM.allCases) { profil in
                                Text(profil.rawValue).tag(profil)
                            }
                        }
                        .onChange(of: selectedProfile) { newProfil in
                            let config = newProfil.configuration
                            apiURL = config.url
                            endpoint = config.endpoint
                            modelName = config.model
                            useAPIKey = config.useAPIKey
                            apiKey = config.apiKey
                            useChatFormat = config.chatFormat
                        }
                    }

                    Section(header: Text("Paramètres de connexion")) {
                        TextField("URL du serveur", text: $apiURL)
                        TextField("Endpoint", text: $endpoint)
                        TextField("Nom du modèle", text: $modelName)
                        Toggle("Format Chat (messages)", isOn: $useChatFormat)
                    }

                    Section(header: Text("Authentification")) {
                        Toggle("Utiliser une clé API", isOn: $useAPIKey)
                        if useAPIKey {
                            SecureField("Clé API", text: $apiKey)
                        }
                    }

                    Section {
                        Button("Tester la connexion") {
                            testerConnexion()
                        }
                        if !testResponse.isEmpty {
                            Text(testResponse)
                                .font(.footnote)
                                .foregroundColor(.gray)
                        }
                    }

                    Section {
                        Button("✅ Appliquer et revenir") {
                            dismiss()
                        }
                    }
                }
            }
            .dismissKeyboardOnTap() // tap global actif
            .navigationTitle("Paramètres LLM")
            .onAppear {
                detectProfilActuel()
            }
        }
    }

    func detectProfilActuel() {
        if apiURL == ProfilLLM.local.configuration.url &&
            modelName == ProfilLLM.local.configuration.model {
            selectedProfile = .local
        } else if apiURL == ProfilLLM.reseau.configuration.url &&
                    modelName == ProfilLLM.reseau.configuration.model {
            selectedProfile = .reseau
        } else {
            selectedProfile = .custom
        }
    }

    func testerConnexion() {
        testResponse = ""
        isLoading = true

        guard let url = URL(string: apiURL + endpoint) else {
            testResponse = "❌ URL invalide"
            isLoading = false
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        if useAPIKey && !apiKey.isEmpty {
            request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        }

        let json: [String: Any] = useChatFormat
            ? [
                "model": modelName,
                "messages": [["role": "user", "content": "Dis juste OK."]],
                "temperature": 0.5
            ]
            : [
                "model": modelName,
                "prompt": "Dis juste OK.",
                "temperature": 0.5
            ]

        guard let body = try? JSONSerialization.data(withJSONObject: json) else {
            testResponse = "❌ Erreur JSON"
            isLoading = false
            return
        }

        request.httpBody = body

        URLSession.shared.dataTask(with: request) { data, _, error in
            DispatchQueue.main.async {
                isLoading = false
                guard error == nil, let data = data else {
                    testResponse = "❌ Erreur de connexion"
                    return
                }

                if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let choices = json["choices"] as? [[String: Any]] {
                    if let message = choices.first?["message"] as? [String: Any],
                       let content = message["content"] as? String {
                        testResponse = "✅ Réponse : \(content)"
                    } else if let text = choices.first?["text"] as? String {
                        testResponse = "✅ Réponse : \(text)"
                    } else {
                        testResponse = "⚠️ Format inattendu"
                    }
                } else {
                    testResponse = "❌ Réponse illisible"
                }
            }
        }.resume()
    }
}

#Preview {
    ParametresLLMView()
}
