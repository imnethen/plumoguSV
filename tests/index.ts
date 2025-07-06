// UNUSED FUNCTION TEST

import * as fs from "fs"
import checkUnusedFunctions from "./unused-functions"
import checkDoubleNestedFiles from './double-nested-files'

const plugin = fs.readFileSync("plugin.lua", "utf-8").replaceAll("\r", "").split("\n")

checkDoubleNestedFiles()
checkUnusedFunctions(plugin)
