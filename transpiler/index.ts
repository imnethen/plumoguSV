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
        const fileData = readFileSync(file, 'utf-8')
            .replaceAll(/( *)\<const\> */g, '$1')
            .replaceAll(/\-\-\[\[.*?\-\-\]\][ \r\n]*/gs, '')
            .split('\n')
            .filter((l) => !l.includes('require('))
            .map((l) =>
                l.replaceAll(
                    /^([^\-\r\n]*)[\-]{2}([\-]{2,})?[^\-\r\n].+[ \r\n]*/g,
                    '$1'
                )
            ); // Removes <const> tag, removes --[[ --]] comments, removes double dash comments (not triple dash) from lines with code
        output = `${output}\n${fileData
            .map((str) => str.replace(/\s+$/, ''))
            .filter((str) => str)
            .join('\n')}`;
        fileCount++;
    });

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
            splitOutput.splice(startIdx, endIdx - startIdx + 1);
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
