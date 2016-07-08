import libc
import Console
import Foundation
import VaporToolbox

let terminal: Console = Terminal(arguments: Process.arguments)

var iterator = Process.arguments.makeIterator()

guard let executable = iterator.next() else {
    throw ConsoleError.noExecutable
}


do {
    try terminal.run(executable: executable, commands: [
        New(console: terminal),
        Build(console: terminal),
        Run(console: terminal),
        Fetch(console: terminal),
        Clean(console: terminal),
        Xcode(console: terminal),
        Version(console: terminal, version: "0.6.1"),
        Group(id: "self", commands: [
            SelfInstall(console: terminal, executable: executable),
            SelfUpdate(console: terminal, executable: executable),

        ], help: [
            "Commands that affect the toolbox itself."
        ]),
        Group(id: "heroku", commands: [
            HerokuInit(console: terminal)
        ], help: [
            "Commands to help deploy to Heroku."
        ])
    ], arguments: Array(iterator), help: [
        "Join our Slack if you have questions, need help,",
        "or want to contribute: http://slack.qutheory.io"
    ])
} catch Error.general(let message) {
    terminal.error("Error: ", newLine: false)
    terminal.print(message)
    exit(1)
} catch ConsoleError.insufficientArguments {
    terminal.error("Error: ", newLine: false)
    terminal.print("Insufficient arguments.")
} catch ConsoleError.help {
    exit(0)
} catch ConsoleError.cancelled {
    exit(2)
} catch ConsoleError.noCommand {
    terminal.error("Error: ", newLine: false)
    terminal.print("No command supplied.")
} catch ConsoleError.commandNotFound(let id) {
    terminal.error("Error: ", newLine: false)
    terminal.print("Command \"\(id)\" not found.")
} catch {
    terminal.error("Error: ", newLine: false)
    terminal.print("\(error)")
    exit(1)
}
