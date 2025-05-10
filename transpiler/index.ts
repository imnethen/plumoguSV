import {
    readFileSync,
    writeFileSync,
    rmSync,
    existsSync,
    renameSync,
} from "fs";
import { getFilesRecursively } from "./getFilesRecursively.js";

export default async function transpiler() {
    let fileCount = 0
    let output = "";

    function addToOutput(str) {
        output = `${output}\n\n${str}`;
    }

    const files = getFilesRecursively("./src");

    const ignoredFiles = ["classes.lua", "intellisense.lua"];

    files.forEach((file) => {
        if (ignoredFiles.some((f) => file.includes(f))) return;
        const fileData = readFileSync(file, "utf-8")
            .split("\n")
            .filter((str) => str); // Filter out empty lines
        output = `${output}\n${fileData.join("\n")}`
        fileCount++
    });

    if (existsSync("plugin.lua")) rmSync("plugin.lua");
    writeFileSync("temp.lua", output.replaceAll("\n\n", "\n"));
    renameSync("temp.lua", "plugin.lua");

    return fileCount
}

transpiler();