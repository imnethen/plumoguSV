import {
    readFileSync,
    writeFileSync,
    rmSync,
    existsSync,
    renameSync,
    copyFileSync,
} from 'fs';
import { getFilesRecursively } from './getFilesRecursively.js';
import fuckifyOutput from './fuckify.js';
import getFunctionList from './getFunctionList.js';
import getUnusedFunctions from './getUnusedFunctions.js';

export default async function transpiler(
    devMode = false,
    fuckify = false,
    lint = true
) {
    let fileCount = 0;
    let rootLocalCount = 0;

    let output = '';

    const files = getFilesRecursively('packages');
    files.push(...getFilesRecursively('src'));

    const ignoredFiles = ['classes.lua', 'intellisense.lua'];

    if (!devMode) ignoredFiles.push('src\\dev');

    files.forEach((file: string) => {
        if (
            ignoredFiles.some((f) => file.includes(f)) ||
            !file.endsWith('.lua')
        )
            return;
        let fileData = readFileSync(file, 'utf-8')
            .replaceAll(/( *)\<const\> */g, '$1')
            .replaceAll(/\-\-\[\[.*?\-\-\]\][ \r\n]*/gs, '')
            .split('\n')
            .map((l) => {
                l = l.replace(/\s+$/, '');
                l = l.replaceAll(
                    /^([^\-\r\n]*)[\-]{2}([\-]{2,})?[^\-\r\n].+[ \r\n]*/g,
                    '$1'
                ); // Removes <const> tag, removes --[[ --]] comments, removes double dash comments (not triple dash) from lines with code
                l = l.replaceAll(
                    /table\.insert\(([a-zA-Z0-9\[\]_\.]+), ([^,\r\n]+)\)( end)?$/g,
                    '$1[$1 + 1] = $2$3'
                ); // Replace table insert for performance
                l = l.replaceAll(
                    /^function ([a-zA-Z0-9_]+)\(/g,
                    'local function $1('
                ); // Reduce global hashmap size with local root functions
                l = l.replaceAll(/^(?!local)([a-z0-9_]+) = /g, `local $1 = `); // Reduce global hashmap size with local root variables
                return l;
            });

        fileData.forEach((line, idx) => {
            if (!/^local/.test(line)) return;
            rootLocalCount++;
            if (rootLocalCount > 200) {
                fileData[idx] = line.replace(/^local /, '');
            }
        }); // Limit root locals to 200 due to lua restriction

        output = `${output}\n${fileData
            .map((str) => str.replace(/\s+$/, ''))
            .filter((str) => str)
            .join('\n')}`;
        fileCount++;
    });

    output = output.replaceAll(
        /\("([^"]+?)" \.\. (.+) \.\. (.+)\)/g,
        '(table.concat({"$1", $2, $3}))'
    );

    output = output.replaceAll(
        /for _, ([a-zA-Z0-9_]+) in ipairs\(([a-zA-Z0-9_\.\(\), ]+)\) do\n( *)/g,
        'for k = 1, #$2 do\n$3local $1 = $2[k]\n$3'
    ); // Reduce function overhead by removing ipairs

    for (let i = 2; i <= 9; i++) {
        const regex = new RegExp(` ([^\\)]) \\^ ${i}`, 'g');
        output = output.replaceAll(
            regex,
            ` $1${Array(i - 1)
                .fill(' * $1')
                .join('')}`
        );
    } // Remove integer exponentiation and replace with repeated multiplication

    if (fuckify) output = fuckifyOutput(output);

    output = output.replaceAll('\n\n', '\n').trimStart();
    if (lint) {
        const splitOutput = output.split('\n');

        let [functions, fnIndices] = getFunctionList(splitOutput);
        functions = functions.filter((fn, idx) => {
            const cond = fn.startsWith('string') || fn.startsWith('table');
            if (cond) fnIndices.splice(idx, 1);
            return !cond;
        });
        const [_, unusedIndexes] = getUnusedFunctions(splitOutput, [
            functions,
            fnIndices,
        ]);

        unusedIndexes.reverse().forEach((idx) => {
            let startIdx = idx;
            let endIdx = idx;
            while (/^---/.test(splitOutput[startIdx - 1]) && startIdx > 0)
                startIdx--;
            while (!/^end/.test(splitOutput[endIdx])) endIdx++;
            // splitOutput.splice(startIdx, endIdx - startIdx + 1);
        });

        output = splitOutput.join('\n');
    }

    if (existsSync('plugin.lua')) rmSync('plugin.lua');
    writeFileSync('temp.lua', output);
    renameSync('temp.lua', 'plugin.lua');
    if (existsSync('quinsight/intellisense.lua'))
        copyFileSync('quinsight/intellisense.lua', 'intellisense.lua');

    return fileCount;
}

transpiler();
