import {
    readFileSync,
    writeFileSync,
    rmSync,
    existsSync,
    renameSync,
} from "fs";
import { getFilesRecursively } from "./getFilesRecursively.js";

export default async function transpiler(devMode = false) {
    let fileCount = 0;
    let output = "";

    const files = getFilesRecursively("./src");

    const ignoredFiles = ["classes.lua", "intellisense.lua"];

    if (!devMode) ignoredFiles.push("src\\dev")

    files.forEach((file) => {
        if (ignoredFiles.some((f) => file.includes(f))) return;
        const fileData = readFileSync(file, "utf-8").split("\n");
        output = `${output}\n${fileData.filter((str) => str).join("\n")}`;
        fileCount++;
    });

    if (existsSync("plugin.lua")) rmSync("plugin.lua");
    writeFileSync("temp.lua", output.replaceAll("\n\n", "\n"));
    renameSync("temp.lua", "plugin.lua");

    return fileCount;
}

transpiler();
