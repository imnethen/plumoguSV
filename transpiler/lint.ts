import { getFilesRecursively } from "./getFilesRecursively";
import * as fs from "fs"

const files = getFilesRecursively("./src");
files.push(...getFilesRecursively("./packages"));

const ignoredFiles = ["classes.lua", "intellisense.lua"];

ignoredFiles.push("src\\dev")

files.forEach((path) => {
    const fileData = fs.readFileSync(path, "utf-8")
    fs.writeFileSync(path, fileData.trim())
})
