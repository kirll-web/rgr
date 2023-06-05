UNIT WorkWithWord;
INTERFACE

TYPE
  NodeFromFile = RECORD
                   Word: STRING;
                   Count: INTEGER
                 END;

PROCEDURE CreateWord(VAR FIn: TEXT; VAR Word: STRING);
PROCEDURE ReadWordAndCountFromFile(VAR FIn: TEXT; VAR NodeOfFile: NodeFromFile);
IMPLEMENTATION
CONST 
  CapitalizeLetters = ['A' .. 'Z', 'À'..'ß'];
  CharsRange = ['à' .. 'ÿ', 'a' .. 'z', '-', '¸'];
  CodeLetterToLowerCase = 32; 


PROCEDURE ReadLetter(VAR FIn: TEXT; VAR Letter: CHAR);
BEGIN{ReadLetter}
  Letter := '';
  IF (NOT EOF(FIn)) OR (NOT EOLN(FIn))
  THEN
    BEGIN
      READ(FIn, Letter); 
      IF Letter IN CapitalizeLetters
      THEN
        Letter := CHR(ORD(Letter)+ CodeLetterToLowerCase)
      ELSE 
        BEGIN
          IF Letter = '¨'
          THEN
            Letter := '¸'
        END
    END;
END;{ReadLetter}

PROCEDURE WorkWithDash(VAR FIn: TEXT; VAR Letter: CHAR; VAR Count: INTEGER; VAR Word: STRING; VAR FoundDash: BOOLEAN; VAR FoundWordWrap: BOOLEAN);
BEGIN
  IF NOT(((Count = 1) OR (Word[POS('-', Word)] = '-')) OR FoundDash)
  THEN
    BEGIN
      FoundDash := TRUE;
      IF EOLN(FIn)
      THEN
        BEGIN
          READLN(FIn);
          FoundWordWrap := TRUE;
        END
    END
  ELSE
    BEGIN
      Letter := '';
      FoundDash := FALSE
    END
END;

PROCEDURE MergeLetterWithStr(VAR FIn: TEXT; VAR Letter: CHAR; VAR Count: INTEGER; VAR Word: STRING; VAR FoundDash: BOOLEAN; VAR FoundWordWrap: BOOLEAN);
BEGIN {CreateWord}
  IF Letter IN CharsRange
  THEN
    BEGIN
      IF Letter = '-'
      THEN
        WorkWithDash(FIn, Letter, Count, Word, FoundDash, FoundWordWrap)
      ELSE
        BEGIN
          IF FoundDash AND (NOT FoundWordWrap)
          THEN
            BEGIN
              Word := Word + '-' + Letter;
              FoundDash := FALSE
            END
          ELSE
            BEGIN
              Word := Word + Letter;
              FoundWordWrap := FALSE;
              FoundDash := FALSE
            END
        END;
      Count := Count + 1
    END
END; {CreateWord}

PROCEDURE CreateWord(VAR FIn: TEXT; VAR Word: STRING);
VAR
  Count: INTEGER;
  Letter: CHAR;
  FoundDash: BOOLEAN;
  FoundWordWrap: BOOLEAN;

BEGIN {CreateNode}
  Letter := '';
  Word := '';
  Count := 1;
  FoundDash := FALSE;
  FoundWordWrap := FALSE;
  REPEAT
    ReadLetter(FIn, Letter);
    MergeLetterWithStr(FIn, Letter, Count, Word, FoundDash, FoundWordWrap);   
  UNTIL NOT((Letter IN CharsRange) AND ((NOT EOLN(FIn)) OR (NOT EOF(FIn))));
END; {ReadWord}

PROCEDURE ReadWordAndCountFromFile(VAR FIn: TEXT; VAR NodeOfFile: NodeFromFile);
VAR
  Ch: CHAR;
BEGIN
  NodeOfFile.Word := '';
  IF (NOT EOLN(FIn)) AND (NOT EOF(FIn)) 
  THEN
    BEGIN
      READ(FIn, Ch);
      WHILE (Ch <> ' ') 
      DO
        BEGIN
          IF NodeOfFile.Word = ''
          THEN
            NodeOfFile.Word := Ch
          ELSE
            NodeOfFile.Word := NodeOfFile.Word + Ch;
          READ(FIn, Ch)
        END;
      READ(FIn, NodeOfFile.Count);
      READLN(FIn)
    END
END;

BEGIN {WorkWithWords}
END. {WorkWithWords}


  


