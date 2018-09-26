//
//  Observable+Ext.swift
//  MVVMC-SplitViewController
//
//  Created by Mathew Gacy on 12/27/17.
//  Copyright © 2017 Mathew Gacy. All rights reserved.
//
//  From:
//  https://github.com/sergdort/CleanArchitectureRxSwift
//  Copyright (c) 2017 Sergey Shulga
//

import RxSwift
import RxCocoa

extension ObservableType {

    func asDriverOnErrorJustComplete() -> Driver<E> {
        return asDriver { _ in
            return Driver.empty()
        }
    }

    func mapToVoid() -> Observable<Void> {
        return map { _ in }
    }
}

extension PrimitiveSequenceType where TraitType == SingleTrait {

    func asDriverOnErrorJustComplete() -> Driver<ElementType> {
        return self.primitiveSequence.asDriver { _ in
            return Driver.empty()
        }
    }

}
