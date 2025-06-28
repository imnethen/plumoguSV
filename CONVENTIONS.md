- The indent width in this codebase is 4.
- Use `camelCase` whenever possible. While many other projects use `snake_case` for Lua, since the exposed globals from Quaver use `camelCase`, it makes sense to follow this paradigm.
- Avoid using `k` or `v` as parameters in `pairs(tbl)`, unless iterating over a generic table.
- Acronyms that are not game objects, like SVs, SSFs, or TGs, should only have their first letter capitalized (like `scrollGroupId`)
- Any variable with `UPPER_SNAKE_CASE` is a constant. Treat it as such.
- Avoid anonymous functions unless passing them as the parameter to another function.
- Any variable prefixed with `_` is not meant to be used.
- Avoid writing comments explaining code unless the logic within the code is unclear.
- Use double quotes for strings, unless they contain a double quote themselves; in that case, use single quotes.
- Avoid using bracket notation for tables unless the key is not known beforehand (e.g. during runtime)
- Try to either have all variables necessary assigned at the top of a function, or have their first assignment be - as close to their next call as possible.
- Use the existing conventions within the repository if they're not listed here.


