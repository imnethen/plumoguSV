// UNUSED FUNCTION TEST

import * as fs from "fs"
import checkUnusedFunctions from "./unused-functions"

const plugin = fs.readFileSync("plugin.lua", "utf-8").replaceAll("\r", "").split("\n")

checkUnusedFunctions(plugin)