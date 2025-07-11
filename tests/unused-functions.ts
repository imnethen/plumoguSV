import chalk = require('chalk');

export default function checkUnusedFunctions(file: string[]) {
    const functions = file.reduce((idxs, line) => {
        if (
            !line.startsWith('---') &&
            line.includes('function ') &&
            line.includes('(')
        )
            idxs.push(line.split('function ')[1].split('(')[0]);
        return idxs;
    }, []);

    const globals = ['awake', 'draw'];

    const testCount = functions.length;
    let failedTests = 0;

    functions.forEach((fn) => {
        if (
            file.join('\n').match(new RegExp(String.raw`${fn}[\(,\)]`, 'gd'))
                ?.length == 1 &&
            !globals.includes(fn)
        ) {
            console.log(`${chalk.red(fn)} is an unused function.`);
            failedTests++;
        }
    });

    return [failedTests, testCount];
}
