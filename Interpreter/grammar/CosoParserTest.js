import antlr4 from 'antlr4';
import CosoLexer from './CosoLexer.js'
import CosoParser from './CosoParser.js'
import fs from 'node:fs';

fs.readFile('test.coso', 'utf8', function(err, input) {
    if (err) throw err;
    var chars = new antlr4.InputStream(input);
    var lexer = new CosoLexer(chars);
    var tokens  = new antlr4.CommonTokenStream(lexer);
    var parser = new CosoParser(tokens);
    parser.buildParseTrees = true;   
    var tree = parser.main();
    console.log(tree.toStringTree());
});

