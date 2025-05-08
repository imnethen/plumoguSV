import * as fs from "fs";
import * as path from "path";

export function getFilesRecursively(dir) {
  let files = [];

  const filesInDirectory = fs.readdirSync(dir);
  for (const file of filesInDirectory) {
    const absolute = path.join(dir, file);
    if (fs.statSync(absolute).isDirectory()) {
      files = [...files, ...getFilesRecursively(absolute)];
    } else {
      files.push(absolute);
    }
  }

  return files;
}