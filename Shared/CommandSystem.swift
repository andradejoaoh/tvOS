//
//  CommandSysten.swift
//  RTS
//
//  Created by Nathalia Melare on 13/07/20.
//  Copyright © 2020 João Henrique Andrade. All rights reserved.
//

public enum Command {
    case start
    case pause
    case `continue`
    case restart
    case end
    case invalid
}

public struct CommandSystem {
    var decode: String

    var command: Command {
        switch decode {
        case "start":
            return .start
        case "pause":
            return .pause
        case "continue":
            return .continue
        case "restart":
            return .restart
        case "end":
            return .end
        default:
            return .invalid
        }
    }
}
