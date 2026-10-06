-- Decompiled with Potassium's decompiler.

return {
    FindDescendantWithTag = function(p1: userdata, p2: string) -- Line: 5, Name: FindDescendantWithTag
        return p1:QueryDescendants((`.{p2}`))[1];
    end
};