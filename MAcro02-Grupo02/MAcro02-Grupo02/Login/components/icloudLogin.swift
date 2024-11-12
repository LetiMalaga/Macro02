//
//  icloudLogin.swift
//  MAcro02-Grupo02
//
//  Created by Felipe Porto on 03/10/24.
//

import CloudKit
import UIKit

class iCloudLogin {
    
    // Função pública para verificar o status da conta iCloud
    func checkiCloudAccountStatus(from viewController: UIViewController) {
        CKContainer.default().accountStatus { status, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Erro ao verificar status da conta: \(error.localizedDescription)")
                    return
                }

                switch status {
                case .available:
                    print("Usuário está logado no iCloud.")
                case .noAccount:
                    print("Usuário não está logado no iCloud.")
                    self.promptUserToLoginToiCloud(from: viewController)
                case .restricted:
                    print("O acesso ao iCloud está restrito.")
                case .couldNotDetermine:
                    print("Não foi possível determinar o status da conta iCloud.")
                case .temporarilyUnavailable:
                    print("O acesso ao iCloud está temporariamente indisponível.")
                @unknown default:
                    print("Status desconhecido da conta.")
                }
            }
        }
    }

    // Função privada para exibir o alerta solicitando login no iCloud
    private func promptUserToLoginToiCloud(from viewController: UIViewController) {
        let alert = UIAlertController(title: "Login iCloud Necessário",
                                      message: "Esse aplicativo utiliza-se do iCloud para acessar uma lista de funcionalidades do aplicativo, por favor, faça login para poder utilizar o aplicativo ao seu máximo.",
                                      preferredStyle: .alert)

        let settingsAction = UIAlertAction(title: "Abrir Configurações", style: .default) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }

        alert.addAction(settingsAction)

        // Apresenta o alerta usando a view controller passada como parâmetro
        viewController.present(alert, animated: true, completion: nil)
    }
}
