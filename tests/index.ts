import * as fs from "fs"
import checkUnusedFunctions from "./unused-functions"
import checkDoubleNestedFiles from './double-nested-files'
import checkDuplicatedLines from './duplicated-lines'

const plugin = fs.readFileSync("plugin.lua", "utf-8").replaceAll("\r", "").split("\n")

checkDoubleNestedFiles()
checkUnusedFunctions(plugin)
checkDuplicatedLines(plugin)
