class Kot {
    
    let straatnaam: String
    let huisnummer: String
    let plaats: String
    let type: String
    let contractDuration: String
    let contractType: String
    let status: String
    let huurprijs: String
    let prijsAfvalverwerking: String
    let prijsInternet: String
    let prijsKabeltv: String
    let totalePrijs: String
    let waarborg: String
    let opties: String
    let betalingWaarborg: String
    
    init(straatnaam: String, huisnummer: String, plaats: String, type: String, contractDuration: String, contractType: String, status: String, huurprijs: String, prijsAfvalverwerking: String, prijsInternet: String, prijsKabeltv: String, totalePrijs: String, waarborg: String, opties: String, betalingWaarborg: String) {
        self.straatnaam = straatnaam
        self.huisnummer = huisnummer
        self.plaats = plaats
        self.type = type
        self.contractDuration = contractDuration
        self.contractType = contractType
        self.status = status
        self.huurprijs = huurprijs
        self.prijsAfvalverwerking = prijsAfvalverwerking
        self.prijsInternet = prijsInternet
        self.prijsKabeltv = prijsKabeltv
        self.totalePrijs = totalePrijs
        self.waarborg = waarborg
        self.opties = opties
        self.betalingWaarborg = betalingWaarborg
    }
}

extension Kot: CustomStringConvertible {
    var description: String {
        return straatnaam + "\(huisnummer)"
    }
}

extension Kot {
    
    convenience init(json: [String: Any]) throws {
        
        guard let street = json["Straat"] as? String else {
            throw Service.Error.missingJsonProperty(name: "Straat")
        }
        guard let number = json["Huisummer"] as? String else { // Bug in backend, huisnummer is huisummer, n ontbreekt
            throw Service.Error.missingJsonProperty(name: "Huisnummer")
        }
        guard let place = json["Plaats"] as? String else {
            throw Service.Error.missingJsonProperty(name: "Plaats")
        }
        guard let type = json["Type"] as? String else {
            throw Service.Error.missingJsonProperty(name: "Type")
        }
        guard let duration = json["Contract duur"] as? String else {
            throw Service.Error.missingJsonProperty(name: "Contractduur")
        }
        guard let contracttype = json["Contract type"] as? String else {
            throw Service.Error.missingJsonProperty(name: "Contracttype")
        }
        guard let status = json["Status"] as? String else {
            throw Service.Error.missingJsonProperty(name: "Status")
        }
        guard let huurprijs = json["Huurprijs"] as? String else {
            throw Service.Error.missingJsonProperty(name: "Huurprijs")
        }
        guard let prijsAfval = json["Prijs afvalverwerking"] as? String else {
            throw Service.Error.missingJsonProperty(name: "Prijs afvalverwerking")
        }
        guard let prijsInternet = json["Prijs internet"] as? String else {
            throw Service.Error.missingJsonProperty(name: "Prijs internet")
        }
        guard let prijsKabel = json["Prijs kabeltv"] as? String else {
            throw Service.Error.missingJsonProperty(name: "Prijs kabeltv")
        }
        guard let totalePrijs = json["Totale prijs"] as? String else {
            throw Service.Error.missingJsonProperty(name: "Totale prijs")
        }
        guard let waarborg = json["Waarborg"] as? String else {
            throw Service.Error.missingJsonProperty(name: "Waarborg")
        }
        guard let opties = json["Opties"] as? String else {
            throw Service.Error.missingJsonProperty(name: "Opties")
        }
        guard let betalingWaarborg = json["Betaling waarborg"] as? String else {
            throw Service.Error.missingJsonProperty(name: "Betaling waarborg")
        }
        self.init(
            straatnaam: street,
            huisnummer: number,
            plaats: place,
            type: type,
            contractDuration: duration,
            contractType: contracttype,
            status: status,
            huurprijs: huurprijs,
            prijsAfvalverwerking: prijsAfval,
            prijsInternet: prijsInternet,
            prijsKabeltv: prijsKabel,
            totalePrijs: totalePrijs,
            waarborg: waarborg,
            opties: opties,
            betalingWaarborg: betalingWaarborg
        )
    }
}
