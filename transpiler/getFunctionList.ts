export default function getFunctionList(file: string[]): [string[], number[]] {
    return file.reduce(
        (fns, line, idx) => {
            if (
                !line.startsWith('---') &&
                line.includes('function ') &&
                line.includes('(')
            ) {
                fns[0].push(line.split('function ')[1].split('(')[0]);
                fns[1].push(idx);
            }
            return fns;
        },
        [[], []]
    );
}
