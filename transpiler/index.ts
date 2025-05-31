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
    files.push(...getFilesRecursively("./packages"));

    const ignoredFiles = ["classes.lua", "intellisense.lua"];

    if (!devMode) ignoredFiles.push("src\\dev")

    files.forEach((file: string) => {
        if (ignoredFiles.some((f) => file.includes(f)) || !file.endsWith(".lua")) return;
        const fileData = readFileSync(file, "utf-8").replaceAll(/( *)\<const\> */g, "$1").replaceAll(/\-\-\[\[.*?\-\-\]\][ \r\n]*/gs, "").split("\n").map((l) => l.replaceAll(/^([^\-\r\n]*)[\-]{2}([\-]{2,})?[^\-\r\n].+[ \r\n]*/g, "$1")) // Removes <const> tag, removes --[[ --]] comments, removes double dash comments (not triple dash) from lines with code
        output = `${output}\n${fileData.map(str => str.replace(/\s+$/, "")).filter((str) => str).join("\n")}`;
        fileCount++;
    });

    if (existsSync("plugin.lua")) rmSync("plugin.lua");
    writeFileSync("temp.lua", output.replaceAll("\n\n", "\n"));
    renameSync("temp.lua", "plugin.lua");

    return fileCount;
}

transpiler();
