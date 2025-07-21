require("packages.tests.expect")
require("packages.table.stringify")
require("packages.truthy")

function add1(x)
    return x + 1
end

print(expect(add1).of(5).toBe(6))
