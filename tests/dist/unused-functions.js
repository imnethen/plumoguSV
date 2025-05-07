"use strict";
var __makeTemplateObject = (this && this.__makeTemplateObject) || function (cooked, raw) {
    if (Object.defineProperty) { Object.defineProperty(cooked, "raw", { value: raw }); } else { cooked.raw = raw; }
    return cooked;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.default = checkUnusedFunctions;
var chalk = require("chalk");
function checkUnusedFunctions(file) {
    var functions = file.reduce(function (idxs, line) {
        if (line.includes("function ") && line.includes("("))
            idxs.push(line.split("function ")[1].split("(")[0]);
        return idxs;
    }, []);
    var fns = [];
    functions.forEach(function (fn) {
        var _a;
        if (((_a = file.join("\n").match(new RegExp(String.raw(templateObject_1 || (templateObject_1 = __makeTemplateObject(["", ""], ["", ""])), fn), "gd"))) === null || _a === void 0 ? void 0 : _a.length) == 1) {
            console.log(chalk.red("".concat(fn, " is an unused function.")));
            fns.push(fn);
        }
    });
    return fns;
}
var templateObject_1;
