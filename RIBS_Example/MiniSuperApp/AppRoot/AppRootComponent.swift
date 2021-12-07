//
//  AppRootComponent.swift
//  MiniSuperApp
//
//  Created by kakao on 2021/12/08.
//

import Foundation
import AppHome
import FinanceHome
import ProfileHome
import FinanceRepository
import ModernRIBs
import TransportHome
import TransportHomeImp

final class AppRootComponent: Component<AppRootDependency>, AppHomeDependency, FinanceHomeDependency, ProfileHomeDependency, TransportHomeDependency  {
    
    lazy var transportHomeBuildable: TransportHomeBuildable = {
        return TransportHomeBuilder(dependency: self)
    }()
  
  // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}
