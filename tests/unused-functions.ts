import chalk = require("chalk")

export default function checkUnusedFunctions(file: string[]) {
    const functions = file.reduce((idxs, line) => {
        if (line.includes("function ") && line.includes("(")) idxs.push(line.split("function ")[1].split("(")[0])
        return idxs
    }, [])

    const fns = []

    functions.forEach((fn) => {
        if (file.join("\n").match(new RegExp(String.raw`${fn}`, "gd"))?.length == 1) {
            console.log(chalk.red(`${fn} is an unused function.`))
            fns.push(fn)
        }
    })
    return fns
}