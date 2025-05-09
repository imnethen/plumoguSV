import {
    readFileSync,
    writeFileSync,
    rmSync,
    existsSync,
    renameSync,
} from "fs";
import { getFilesRecursively } from "./getFilesRecursively.js";

export default async function transpiler() {
    let output = "";

    function addToOutput(str) {
        output = `${output}\n\n${str}`;
    }

    const files = getFilesRecursively("./src");

    const ignoredFiles = ["classes.lua", "intellisense.lua"];

    files.forEach((file) => {
        if (ignoredFiles.some((f) => file.includes(f))) return;
        const fileData = getFile(file)
            .split("\n")
            .filter((str) => str); // Filter out empty lines
        addToOutput(fileData.join("\n"));
    });

    if (existsSync("plugin.lua")) rmSync("plugin.lua");
    writeFileSync("temp.lua", output.replaceAll("\n\n", "\n"));
    renameSync("temp.lua", "plugin.lua");
}

transpiler();

function getFile(relPath) {
    return readFileSync(relPath, "utf-8");
}

export async function sleep(ms) {
    return new Promise((resolve) => setTimeout(resolve, ms));
}

export function locateIndices(arr, searchTerm) {
    const indices = [];

    arr.forEach((item, idx) => {
        if (item.includes(searchTerm)) indices.push(idx);
    });

    return indices;
}
