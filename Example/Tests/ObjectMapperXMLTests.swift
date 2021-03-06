//
//  XMLObjectMapperTests.swift
//  Moya-Pretty_Tests
//
//  Created by Kao Ming-Hsiu on 2018/7/8.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import Quick
import Nimble
import Moya
import Moya_Pretty
import ObjectMapper
import XMLDictionary
import PromiseKit
import RxSwift
import RxNimble

class ObjectMapperXMLSpec: QuickSpec {
  let newXmlMappablePet = XMLMappablePet(JSON: ["id": "1", "name":"Obi"])!
  override func spec() {
    describe("XMLDictionary") {
      
      it ("Can add pet") {
        waitUntil(timeout: 10, action: { (done) in
          MoyaProvider.xml.requestXmlModel(PetService.AddPetMappableXML(body: self.newXmlMappablePet), completion: { (result) in
            switch result {
            case .success(let pet):
              expect(pet.id).to(equal(self.newXmlMappablePet.id))
              expect(pet.name).to(equal(self.newXmlMappablePet.name))
            case .failure(let error):
              fail(error.localizedDescription)
            }
            done()
          }).cauterize()
        })
      }
      
      it ("Can add pet using RxSwift") {
        let provider = MoyaProvider<PetService.AddPetMappableXML>.xml
        let addPet = provider.rx.requestXmlModel(PetService.AddPetMappableXML(body: self.newXmlMappablePet))
        expect(addPet.asObservable()).first.notTo(beNil())
      }
      
      it ("Can add pet using PromiseKit") {
        waitUntil(timeout: 10, action: { (done) in
          firstly {
            MoyaProvider.xml.requestXmlModel(PetService.AddPetMappableXML(body: self.newXmlMappablePet))
            }.done({ (pet) in
              expect(pet.id).to(equal(self.newXmlMappablePet.id))
              expect(pet.name).to(equal(self.newXmlMappablePet.name))
            }).catch({ (error) in
              fail(error.localizedDescription)
            }).finally {
              done()
          }
        })
      }
      
    }
  }
}
