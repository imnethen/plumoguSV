export default function checkDuplicatedLines(plugin: string[]) {
    const hashmap = {}

    plugin.forEach((line, idx) => {
        line = line.trim()
        const blockLength = 10
        if (idx > plugin.length - blockLength) return
        if (line.startsWith("--")) return
        if (line.startsWith("return")) return
        if (line.startsWith("imgui")) return
        if (line.startsWith("}")) return
        if (line.startsWith('"')) return
        if (/^[a-zA-Z0-9_]+ = [-a-zA-Z0-9_\.\[\(\)\{\}]+,?$/.test(line)) return
        let testStr = line
        for (let i = 1; i < blockLength; i++) {
            testStr = `${testStr}\n${plugin[idx + i].trim()}`
        }
        testStr = `${testStr}\n\n\n`
        if (!hashmap[testStr]) hashmap[testStr] = 0
        hashmap[testStr]++
    })

    Object.keys(hashmap).forEach((k) => {
        if (hashmap[k] > 1) console.log(k)
    })
}
