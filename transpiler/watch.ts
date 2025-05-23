import transpiler from ".";
import * as chokidar from "chokidar";
import * as chalk from "chalk";

console.log(
    chalk.blueBright(
        chalk.bold("Watcher initialized. Make a change to a file to transpile.")
    )
);

let devMode = false

chokidar
    .watch("src", { ignoreInitial: true })
    .on("all", async (event, path) => {
        const startTime = Date.now();
        console.log(
            `\nEvent ${chalk.red(event)} detected on file ${chalk.red(
                path
            )}. Now retranspiling...`
        );
        if (path.includes("src\\dev\\unlock")) {
            devMode = true
        }
        if (path.includes("src\\dev\\lock")) {
            devMode = false
        }
        const fileCount = await transpiler(devMode);
        const endTime = Date.now();
        console.log(
            `Successfully transpiled ${chalk.green(
                fileCount
            )} files in ${chalk.green(`${endTime - startTime}ms`)}.\n`
        );
    });
