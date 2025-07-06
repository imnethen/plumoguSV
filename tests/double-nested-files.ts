import chalk = require("chalk")
import { getFilesRecursively } from '../transpiler/getFilesRecursively'

export default function checkDoubleNestedFiles() {
    const files = getFilesRecursively("./src")
    files.forEach(file => {
        const str = file.replaceAll(".lua", "").split("/").slice(-2)
        if (str[0] == str[1]) {
            console.log(chalk.red(`${file} has a double name.`))
        }
    })
}
