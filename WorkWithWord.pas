UNIT WorkWithWord;
INTERFACE
PROCEDURE CreateNode(VAR FIn: TEXT; VAR Node: STRING);

IMPLEMENTATION
PROCEDURE ReadLetter(VAR FIn: TEXT; VAR Letter: CHAR);
BEGIN{ReadLetter}
  Letter := '';
  IF (NOT EOF(FIn)) OR (NOT EOLN(FIn))
  THEN
    BEGIN
      READ(FIn, Letter); 
      IF Letter IN ['A' .. 'Z', 'À'..'ß'] 
      THEN
        Letter := CHR(ORD(Letter)+32)
      ELSE 
        BEGIN
          IF Letter = '¨'
          THEN
            Letter := '¸'
        END
    END;
END;{ReadLetter}

PROCEDURE CreateNode(VAR FIn: TEXT; VAR Node: STRING);
CONST
  CharsRange = ['à' .. 'ÿ', 'a' .. 'z', '-', '¸'];
VAR
  Count: INTEGER;
  Letter: CHAR;
  FoundDash: BOOLEAN;
  FoundWordWrap: BOOLEAN;


PROCEDURE WorkWithDash(VAR FIn: TEXT; VAR Letter: CHAR; VAR Count: INTEGER; VAR Node: STRING; VAR FoundDash: BOOLEAN; VAR FoundWordWrap: BOOLEAN);
BEGIN
  IF NOT(((Count = 1) OR (Node[POS('-', Node)] = '-')) OR FoundDash)
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

PROCEDURE CreateWord(VAR FIn: TEXT; VAR Letter: CHAR; VAR Count: INTEGER; VAR Node: STRING; VAR FoundDash: BOOLEAN; VAR FoundWordWrap: BOOLEAN);
BEGIN {CreateWord}
  IF Letter IN CharsRange
  THEN
    BEGIN
      IF Letter = '-'
      THEN
        WorkWithDash(FIn, Letter, Count, Node, FoundDash, FoundWordWrap)
      ELSE
        BEGIN
          IF FoundDash AND (NOT FoundWordWrap)
          THEN
            BEGIN
              Node := Node + '-' + Letter;
              FoundDash := FALSE
            END
          ELSE
            BEGIN
              Node := Node + Letter;
              FoundWordWrap := FALSE;
              FoundDash := FALSE
            END
        END;
      Count := Count + 1
    END
END; {CreateWord}


BEGIN {CreateNode}
  Letter := '';
  Node := '';
  Count := 1;
  FoundDash := FALSE;
  FoundWordWrap := FALSE;
  REPEAT
    ReadLetter(FIn, Letter);
    CreateWord(FIn, Letter, Count, Node, FoundDash, FoundWordWrap);
    
  UNTIL NOT((Letter IN CharsRange) AND ((NOT EOLN(FIn)) OR (NOT EOF(FIn))));
END; {ReadWord}

BEGIN {WorkWithWords}
END. {WorkWithWords}


  


