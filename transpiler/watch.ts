import transpiler from ".";
import * as chokidar from "chokidar"
import * as chalk from "chalk"

console.log(chalk.blueBright(chalk.bold("Watcher initialized. Make a change to a file to transpile.")))

chokidar.watch("src", {ignoreInitial: true}).on('all', (event, path) => {
    const startTime = Date.now();
  console.log(`\nEvent ${chalk.red(event)} detected on file ${chalk.red(path)}. Now retranspiling...`);
  transpiler()
  const endTime = Date.now();
  console.log(`Successfully transpiled in ${chalk.green(`${endTime - startTime}ms`)}.\n`);
});