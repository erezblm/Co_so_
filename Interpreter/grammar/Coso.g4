grammar Coso;

tokens {
	INDENT,
    DEDENT
}

@lexer::header {
    import CosoParser from './CosoParser.js';
}

@lexer::members {
    this.indentationLevel = 0;
    this.tokenQueue = [];
    this.nextToken = () => {
        let tk = {};
        if(this.tokenQueue.length > 0) {
            tk = this.tokenQueue.shift();
        } else {
            tk = super.nextToken();
        }
        return tk;
    }
}

main: object;

value:  SPACE TEXT NEWLINE? 
    |   NEWLINE INDENT object DEDENT;

object: (TEXT value)+;

NEWLINE: '\r'? '\n' ' '* {
    let spaces = this.text.length - (this.text.indexOf('\n')+1);
    let currentIndentation = spaces / 2;
    if(currentIndentation == this.indentationLevel + 1) {
        this.tokenQueue.push(new antlr4.CommonToken(this._tokenFactorySourcePair, CosoParser.INDENT, antlr4.Lexer.DEFAULT_TOKEN_CHANNEL, this.getCharIndex()-1, this.getCharIndex()-1));
    }
    else if(currentIndentation < this.indentationLevel) {
        for(let i = 0 ; i < this.indentationLevel - currentIndentation ; ++i) {
            this.tokenQueue.push(new antlr4.CommonToken(this._tokenFactorySourcePair, CosoParser.DEDENT, antlr4.Lexer.DEFAULT_TOKEN_CHANNEL, this.getCharIndex()-1, this.getCharIndex()-1));
        }
    }
    this.indentationLevel = currentIndentation;

};

TEXT: [a-zA-Z]+;
SPACE: ' '+;