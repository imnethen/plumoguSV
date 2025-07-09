import {
    readFileSync,
    writeFileSync,
    rmSync,
    existsSync,
    renameSync,
} from "fs";
import { getFilesRecursively } from "./getFilesRecursively.js";
import * as chalk from "chalk";

const brainrotInit = readFileSync("./assets/brainrot.csv", "utf-8").split("\n")
const brainrotList = []

const alphabetArray = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".split("")

for (let i = 0; i < 5; i++) {
    brainrotList.push(...brainrotInit.map((x) => `${x}##${i}`))
    brainrotList.push(...alphabetArray.map((x) => `${x}##${i}`))
    brainrotList.push(...alphabetArray.map((x) => `${x.toLowerCase()}##${i}`))
}

export default async function transpiler(devMode = false, fuckify = false) {
    let fileCount = 0;
    let output = "";

    const files = getFilesRecursively("./packages");
    files.push(...getFilesRecursively("./src"));

    const ignoredFiles = ["classes.lua", "intellisense.lua"];

    if (!devMode) ignoredFiles.push("src\\dev")

    files.forEach((file: string) => {
        if (ignoredFiles.some((f) => file.includes(f)) || !file.endsWith(".lua")) return;
        const fileData = readFileSync(file, "utf-8").replaceAll(/( *)\<const\> */g, "$1").replaceAll(/\-\-\[\[.*?\-\-\]\][ \r\n]*/gs, "").split("\n").map((l) => l.replaceAll(/^([^\-\r\n]*)[\-]{2}([\-]{2,})?[^\-\r\n].+[ \r\n]*/g, "$1")) // Removes <const> tag, removes --[[ --]] comments, removes double dash comments (not triple dash) from lines with code
        output = `${output}\n${fileData.map(str => str.replace(/\s+$/, "")).filter((str) => str).join("\n")}`;
        fileCount++;
    });

    if (fuckify) {
        const matchList = []
        const matches = [...new Set(output.match(/(["]).+?(["])/g))]
        for (let i = 0; i < matches.length; i++) {

            const bannedWords = ["ctrl", "shift", "alt", "string", "boolean", "true", "false", "userdata", "table", "number"]
            const match = matches[i]

            if (!/^"([ A-z0-9_\(\)':\.\+\/]|##)*"$/g.test(match) || match.length == 3 || bannedWords.some((v) => match.toLowerCase().includes(v)) || matchList.includes(match) || brainrotList.length < 1) continue
            matchList.push(match)
            const randomWord = brainrotList.splice(Math.min(Math.floor(Math.random() * brainrotList.length), brainrotList.length - 1), 1)[0]
            // const randomWord = brainrotList[Math.min(Math.floor(Math.random() * brainrotList.length), brainrotList.length - 1)]
            output = output.replaceAll(match, `"${randomWord}"`)
        }
        console.log(chalk.red(`Fuckified ${matches.length} terms.`))
    }

    if (existsSync("plugin.lua")) rmSync("plugin.lua");
    writeFileSync("temp.lua", output.replaceAll("\n\n", "\n").trimStart());
    renameSync("temp.lua", "plugin.lua");

    return fileCount;
}

transpiler();
