UNIT WorkWithMatchingWords;
INTERFACE
PROCEDURE CreateFileWithMatchingWords(VAR Fin: TEXT; VAR FOut: TEXT; VAR FEndings: TEXT);

IMPLEMENTATION
USES
  WorkWithWord;

TYPE
  RecArray = ARRAY [0..1000] OF
            STRING;
PROCEDURE CreateArrOfEndings(VAR FEndings: TEXT; VAR ArrOfEndingsFile: RecArray; VAR NumOfEndings: INTEGER);
VAR
  Ch: CHAR;
  Ending: STRING;
  Count: INTEGER;
  EndArr: INTEGER;
BEGIN
  RESET(FEndings);
  Count := 0;
  WHILE NOT EOF(FEndings)
  DO
    BEGIN
      Ending := '';
      Count := Count + 1;
      WHILE NOT EOLN(FEndings)
      DO
        BEGIN
          READ(FEndings,Ch);
          Ending := Ending + Ch
        END;
      ArrOfEndingsFile[Count] := Ending;
      WRITELN(Ending);
      IF EOLN(FEndings) AND (NOT EOF(FEndings))
      THEN
        READLN(FEndings)
    END;
  NumOfEndings := Count
END;

PROCEDURE CreateEndingFromWord(Word: STRING; VAR OneLetterEnding: STRING; VAR TwoLetterEnding: STRING);
BEGIN
  IF Length(Word) < 3
  THEN
    BEGIN
      OneLetterEnding := '';
      TwoLetterEnding := '';
    END
  ELSE
    BEGIN
      IF Length(Word) = 3
      THEN
        BEGIN
          OneLetterEnding := Word[Length(Word)];
          TwoLetterEnding := ''
        END
      ELSE
        BEGIN
          OneLetterEnding := Word[Length(Word)];
          TwoLetterEnding := Word[Length(Word)-1] + Word[Length(Word)]
        END
    END
END;


PROCEDURE ParseWordWithoutEnding(Word: STRING; VAR WordWithoutEnding: STRING; EndWord: INTEGER);
VAR
  Count: INTEGER;
BEGIN
  FOR Count:= 1 TO EndWord
  DO
    BEGIN
      IF WordWithoutEnding = ''
      THEN
        WordWithoutEnding := Word[Count]
      ELSE
        WordWithoutEnding := WordWithoutEnding +  Word[Count]
    END
END;

FUNCTION CreateWordWithoutEnding(Word: STRING; VAR ArrOfEndingsFile: RecArray; NumOfEndings: INTEGER): STRING;
VAR 
  OneLetterEnding: STRING; 
  TwoLetterEnding: STRING;
  Count: INTEGER;
  WordWithoutEnding: STRING;
BEGIN
  CreateEndingFromWord(Word, OneLetterEnding, TwoLetterEnding);
  WordWithoutEnding := ''; 
  IF (OneLetterEnding <> '')
  THEN
    BEGIN
      FOR Count:= 1 TO NumOfEndings
      DO
        BEGIN
          IF OneLetterEnding = ArrOfEndingsFile[Count]
          THEN
            BEGIN
              WordWithoutEnding := '';
              ParseWordWithoutEnding(Word, WordWithoutEnding, (Length(Word)-1));
            END
        END;
      FOR Count:= 1 TO NumOfEndings
      DO
        BEGIN
          IF TwoLetterEnding = ArrOfEndingsFile[Count]
          THEN
            BEGIN
              WordWithoutEnding := '';
              ParseWordWithoutEnding(Word, WordWithoutEnding, (Length(Word)-2));
              WRITELN(Word, WordWithoutEnding)
            END
        END
    END;
  WRITELN(Word, WordWithoutEnding)  ;
  IF WordWithoutEnding <> ''
  THEN
    CreateWordWithoutEnding := WordWithoutEnding
  ELSE 
    CreateWordWithoutEnding := Word
END;

PROCEDURE StartFindingMatchingWords(VAR FIn: TEXT; VAR FirstMatchingNodeOfFile: NodeFromFile; VAR FirstTempWord: STRING; VAR ArrOfEndingsFile: RecArray; VAR NumOfEndings: INTEGER; VAR FinallyNode: NodeFromFile; VAR FindMatchingWord: BOOLEAN);
BEGIN
  FindMatchingWord := FALSE;
  ReadWordAndCountFromFile(FIn, FirstMatchingNodeOfFile);
  FirstTempWord := CreateWordWithoutEnding(FirstMatchingNodeOfFile.Word, ArrOfEndingsFile, NumOfEndings);
  FinallyNode.Word := '';
  FinallyNode.Count := 0
END;


PROCEDURE CreateFinallyNode(VAR FinallyNode: NodeFromFile; VAR FirstMatchingNodeOfFile: NodeFromFile; VAR SecondMatchingNodeOfFile: NodeFromFile; VAR FindMatchingWord: BOOLEAN);
BEGIN
  FindMatchingWord := TRUE;
  IF FinallyNode.Word = ''
  THEN
    BEGIN
        FinallyNode.Word := FirstMatchingNodeOfFile.Word;
        FinallyNode.Count := FirstMatchingNodeOfFile.Count
    END;
  FinallyNode.Word := FinallyNode.Word + ', ' + SecondMatchingNodeOfFile.Word;
  FinallyNode.Count := FinallyNode.Count + SecondMatchingNodeOfFile.Count
END;

PROCEDURE OutputFinallyNode(VAR FOut: TEXT; VAR FinallyNode: NodeFromFile; VAR FindMatchingWord: BOOLEAN);
BEGIN
  WRITELN(FOut, FinallyNode.Word, ' ', FinallyNode.Count);
  FindMatchingWord := FALSE;
END;

PROCEDURE CreateFileWithMatchingWords(VAR Fin: TEXT; VAR FOut: TEXT; VAR FEndings: TEXT);
VAR
  NodeOfFile: NodeFromFile;
  FirstMatchingNodeOfFile: NodeFromFile;
  SecondMatchingNodeOfFile: NodeFromFile;
  EndingFirstMatchingNodeOfFile: STRING;
  EndIngSecondMatchingNodeOfFile: STRING;
  FindMatchingWord: BOOLEAN;
  ArrOfEndingsFile: RecArray;
  NumOfEndings: INTEGER;
  Count: INTEGER;
  FirstTempWord: STRING;
  SecondTempWord: STRING;
  FinallyNode: NodeFromFile;
BEGIN
  CreateArrOfEndings(FEndings, ArrOfEndingsFile, NumOfEndings);
  RESET(FIn);
  REWRITE(FOut);
  IF NOT EOF(FIn)
  THEN
    BEGIN
       StartFindingMatchingWords(FIn, FirstMatchingNodeOfFile, FirstTempWord, ArrOfEndingsFile, NumOfEndings, FinallyNode, FindMatchingWord);
      WHILE NOT EOF(FIn)
      DO
        BEGIN
            ReadWordAndCountFromFile(FIn, SecondMatchingNodeOfFile);
            SecondTempWord := CreateWordWithoutEnding(SecondMatchingNodeOfFile.Word, ArrOfEndingsFile, NumOfEndings);
            IF (Length(FirstMatchingNodeOfFile.Word) < 2)
            THEN
              BEGIN
                FirstMatchingNodeOfFile := SecondMatchingNodeOfFile;
                FirstTempWord := SecondTempWord
              END
            ELSE
              BEGIN
                IF FirstTempWord = SecondTempWord
                THEN
                  CreateFinallyNode(FinallyNode, FirstMatchingNodeOfFile, SecondMatchingNodeOfFile, FindMatchingWord)
                ELSE
                  BEGIN
                    IF FindMatchingWord = TRUE
                    THEN
                      OutputFinallyNode(FOut, FinallyNode, FindMatchingWord);
                    FinallyNode.Word := '';
                    FinallyNode.Count := 0;
                    FirstMatchingNodeOfFile := SecondMatchingNodeOfFile;
                    FirstTempWord := SecondTempWord
                  END
              END
         END
    END
END;

BEGIN  {CreateAndWriteList}
END. {sort}






{ ????????? ?????
  IF (Length(SecondMatchingNodeOfFile.Word)>= 3)
            THEN
              BEGIN
                FOR Count := 1 TO (Length(SecondMatchingNodeOfFile.Word)-1)
                DO
                  BEGIN
                    IF TempWord = ''
                    THEN
                      TempWord := SecondMatchingNodeOfFile.Word[Count]
                    ELSE
                      TempWord := TempWord + SecondMatchingNodeOfFile.Word[Count]
                  END;
                WRITELN(TempWord);
              END; 
}










