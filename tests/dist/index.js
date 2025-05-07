"use strict";
// UNUSED FUNCTION TEST
Object.defineProperty(exports, "__esModule", { value: true });
var fs = require("fs");
var unused_functions_1 = require("./unused-functions");
var plugin = fs.readFileSync("plugin.lua", "utf-8").replaceAll("\r", "").split("\n");
(0, unused_functions_1.default)(plugin);
