//
//  cronoTaskTests2.swift
//  cronoTaskTests2
//
//  Created by Alberto Banet on 25/10/16.
//  Copyright © 2016 Alberto Banet Masa. All rights reserved.
//

import XCTest
@testable import cronoTask

class cronoTaskTests2: XCTestCase {
    
    var reloj = Reloj(tiempo:"59:59:59")
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    func siguienteClick() {
        reloj.incrementarTiempoUnaCentesima()
        XCTAssert(reloj.tiempo == "01:00:00")
    }
    
    func tipoDeReloj() {
        XCTAssert(reloj.tipo == TipoReloj.minutosSegundosDecimas)
    }
}
