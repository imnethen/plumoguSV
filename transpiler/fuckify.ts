import chalk = require('chalk');
import { readFileSync } from 'fs';

const brainrotInit = readFileSync('assets/brainrot.csv', 'utf-8').split('\n');
const brainrotList = [];

const alphabetArray = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('');

for (let i = 0; i < 5; i++) {
    brainrotList.push(...brainrotInit.map((x) => `${x}##${i}`));
    brainrotList.push(...alphabetArray.map((x) => `${x}##${i}`));
    brainrotList.push(...alphabetArray.map((x) => `${x.toLowerCase()}##${i}`));
}

export default function fuckifyOutput(output: string) {
    const matchList = [];
    const matches = [...new Set(output.match(/(["]).+?(["])/g))];
    for (let i = 0; i < matches.length; i++) {
        const bannedWords = [
            'ctrl',
            'shift',
            'alt',
            'string',
            'boolean',
            'true',
            'false',
            'userdata',
            'table',
            'number',
        ];
        const match = matches[i];

        if (
            !/^"([ A-z0-9_\(\)':\.\+\/]|##)*"$/g.test(match) ||
            match.length == 3 ||
            bannedWords.some((v) => match.toLowerCase().includes(v)) ||
            matchList.includes(match) ||
            brainrotList.length < 1
        )
            continue;
        matchList.push(match);
        const randomWord = brainrotList.splice(
            Math.min(
                Math.floor(Math.random() * brainrotList.length),
                brainrotList.length - 1
            ),
            1
        )[0];
        // const randomWord = brainrotList[Math.min(Math.floor(Math.random() * brainrotList.length), brainrotList.length - 1)]
        output = output.replaceAll(match, `"${randomWord}"`);
    }
    console.log(chalk.red(`Fuckified ${matches.length} terms.`));
    return output;
}
