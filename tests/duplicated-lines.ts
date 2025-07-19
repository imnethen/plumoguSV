import chalk = require('chalk');

export default function checkDuplicatedLines(plugin: string[]) {
    const hashmap = {};
    let failedTests = 0;
    let testCount = 0;

    const trimmedPlugin = plugin.map((l) => l.trim());
    trimmedPlugin.forEach((line, idx) => {
        if (line.startsWith('--')) return;
        if (line.startsWith('return')) return;
        if (line.startsWith('imgui')) return;
        if (line.startsWith('}')) return;
        if (line.startsWith('"')) return;
        if (/^[a-zA-Z0-9_]+ = [-a-zA-Z0-9_\.\[\(\)\{\}]+,?$/.test(line)) return;
        if (!hashmap[line]) hashmap[line] = 0;
        hashmap[line]++;
    });

    Object.keys(hashmap).forEach((k) => {
        if (hashmap[k] < 2) {
            delete hashmap[k];
            return;
        }
        hashmap[k] = trimmedPlugin.indexOf(k);
    });

    const dupeArr = [];
    let pluginCursor = 0;
    let savedLines = [];

    Object.entries(hashmap).forEach(([line, idx]: [string, number]) => {
        if (idx === pluginCursor + 1) {
            savedLines.push(line);
        } else {
            if (savedLines.length > 4) {
                dupeArr.push(savedLines.join('\n'));
            }
            savedLines = [];
        }
        pluginCursor = idx;
    });

    dupeArr.forEach((dupe) => {
        console.log(
            chalk.bgRedBright(
                chalk.black(
                    '\nThe following code block is found multiple times:\n'
                )
            )
        );
        console.log(chalk.blueBright(dupe));
    });

    return [failedTests, testCount];
}
