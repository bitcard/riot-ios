// File created from ScreenTemplate
// $ createScreen.sh SecretsSetupRecoveryKey SecretsSetupRecoveryKey
/*
 Copyright 2020 New Vector Ltd
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

import Foundation

final class SecretsSetupRecoveryKeyViewModel: SecretsSetupRecoveryKeyViewModelType {
    
    // MARK: - Properties
    
    // MARK: Private
    
    private let recoveryService: MXRecoveryService
    private let passphrase: String?
    
    // MARK: Public

    weak var viewDelegate: SecretsSetupRecoveryKeyViewModelViewDelegate?
    weak var coordinatorDelegate: SecretsSetupRecoveryKeyViewModelCoordinatorDelegate?
    
    // MARK: - Setup
    
    init(recoveryService: MXRecoveryService, passphrase: String?) {
        self.recoveryService = recoveryService
        self.passphrase = passphrase
    }
    
    // MARK: - Public
    
    func process(viewAction: SecretsSetupRecoveryKeyViewAction) {
        switch viewAction {
        case .loadData:
            self.createSecureKey()
        case .done:
            self.coordinatorDelegate?.secretsSetupRecoveryKeyViewModelDidComplete(self)
        case .errorAlertOk:
            self.coordinatorDelegate?.secretsSetupRecoveryKeyViewModelDidFailed(self)
        case .cancel:
            self.coordinatorDelegate?.secretsSetupRecoveryKeyViewModelDidCancel(self)
        }
    }
    
    // MARK: - Private
    
    private func createSecureKey() {
        self.update(viewState: .loading)
                
        self.recoveryService.createRecovery(forSecrets: nil, withPassphrase: self.passphrase, success: { secretStorageKeyCreationInfo in
            self.update(viewState: .loaded(secretStorageKeyCreationInfo.recoveryKey))
        }, failure: { error in
            self.update(viewState: .error(error))
        })
    }
    
    private func update(viewState: SecretsSetupRecoveryKeyViewState) {
        self.viewDelegate?.secretsSetupRecoveryKeyViewModel(self, didUpdateViewState: viewState)
    }
}
