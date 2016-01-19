//
//  Errors.swift
//  ISAS
//
//  Created by Adam Salih on 12/01/16.
//  Copyright © 2016 Adam Salih. All rights reserved.
//

enum SyncError:ErrorType{
    case connectionError 
    case communicationError
    case serverIsDown
    case badLogins
}

extension SyncError:CustomStringConvertible{
    var description: String {
        switch self {
        case .connectionError: return "Vyskytly se potíže se síťí. Zkontrolujte si připojení."
        case .communicationError: return "Vyskytla se chyba při komunikaci se serverem."
        case .serverIsDown: return "Server je přetížen, zkuste to prosím za chvíli."
        case .badLogins: return "Špatné přihlašovací údaje."
        }
    }
}

enum ParseError:ErrorType{
    case ivalidData
    case invalidLogin
}

extension ParseError:CustomStringConvertible{
    var description: String {
        switch self {
            case .ivalidData: return "Neočekávaná odpověď serveru."
            case .invalidLogin: return "Špatné přihlašovací údaje."
        }
    }
}