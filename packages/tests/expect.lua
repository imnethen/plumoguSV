function expect(expr)
    return {
        toBe = function(x) return x == expr end
    }
end
