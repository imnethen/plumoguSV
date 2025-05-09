import AdmZip = require("adm-zip");
import transpiler from ".";
import * as chalk from "chalk";
import * as fs from "fs";

console.log(
    chalk.blueBright(
        chalk.bold(`Transpiling ${chalk.redBright("plugin.lua")}...`)
    )
);
transpiler();

const versionNumber = `v${fs.readFileSync(".version", "utf-8")}`;

const readme = fs.readFileSync("README.md", "utf-8");

if (
    readme.split("\n")[0].replaceAll("\r", "").split("plumoguSV ")[1] !==
    versionNumber
) {
    const readmeLines = readme.split("\n");
    readmeLines[0] = `# plumoguSV ${versionNumber}`;
    fs.writeFileSync("README.md", readmeLines.join("\n"));
}

const packageJSON = fs.readFileSync("package.json", "utf-8");
const idx = packageJSON
    .replaceAll("\r", "")
    .split("\n")
    .findIndex((l) => l.includes(`"version": `));
const packageVer = packageJSON
    .replaceAll("\r", "")
    .split("\n")
    [idx].split(': "')[1]
    .replaceAll(/\"\,/g, "");

if (packageVer !== versionNumber.slice(1)) {
    const packageLines = packageJSON.split("\n");
    packageLines[idx] = packageLines[idx].replace(
        packageVer,
        versionNumber.slice(1)
    );
    fs.writeFileSync("package.json", packageLines.join("\n"));
}

const packageName = `plumoguSV-${versionNumber}`

const zip = new AdmZip();

if (!fs.existsSync("builds")) fs.mkdirSync("builds")
if (!fs.existsSync(`build-temp`)) fs.mkdirSync(`build-temp`)

fs.copyFileSync("plugin.lua", `build-temp/plugin.lua`);
fs.copyFileSync("settings.ini", "build-temp/settings.ini");

zip.addLocalFolder("build-temp")

zip.writeZip(`builds/${packageName}.zip`);

fs.rmSync("build-temp", { recursive: true, force: true })