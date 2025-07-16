export default function getUnusedFunctions(
    file: string[],
    functions: [string[], number[]]
) {
    const globals = ['awake', 'draw'];

    const unusedFunctions = [];
    const unusedIndexes = [];
    functions[0].forEach((fn, idx) => {
        if (
            file.join('\n').match(new RegExp(String.raw`${fn}[\(,\)]`, 'gd'))
                ?.length == 1 &&
            !globals.includes(fn)
        ) {
            unusedFunctions.push(functions[0][idx]);
            unusedIndexes.push(functions[1][idx]);
        }
    });
    return [unusedFunctions, unusedIndexes];
}
