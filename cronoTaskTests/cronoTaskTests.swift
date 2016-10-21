//
//  cronoTaskTests.swift
//  cronoTaskTests
//
//  Created by Alberto Banet on 20/10/16.
//  Copyright © 2016 Alberto Banet Masa. All rights reserved.
//

import XCTest
@testable import cronoTask

class cronoTaskTests: XCTestCase {
    var reloj1:Reloj
    var reloj2:Reloj
    
    override init() {
        reloj1 = Reloj(tiempo: "01:17:08")
        reloj2 = Reloj(tiempo: "00:01:72")
    }
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
            }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    

    func testSumarTiempos(){
        let resultado = Reloj.sumarTiempos(t1: reloj1.tiempo, t2: reloj2.tiempo)
        XCTAssert(resultado == "01:18:80")
    }
    
    func testRelojSumar() {
        let resultado = Reloj.sumar(reloj1: reloj1, reloj2: reloj2)
        XCTAssert(resultado.tiempo == "01:18:80")
    }
    
}
