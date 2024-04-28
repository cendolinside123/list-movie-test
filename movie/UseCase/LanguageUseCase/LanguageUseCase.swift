//
//  LanguageUseCase.swift
//  movie
//
//  Created by Jan Sebastian on 28/04/24.
//

import Foundation
import RxSwift

protocol LanguageUseCase {
    func doFetchLanguage() -> Single<LanguageItem>
}
