UNIT CreateAndWriteList;
INTERFACE
PROCEDURE CreateFile(VAR Fin: TEXT; VAR FOut: TEXT; VAR FTemp: TEXT);

IMPLEMENTATION
USES
  WorkWithWord;

Const
  MaxWords = 1000;   
  IndexLastWord = 0;
TYPE
  RecArray = ARRAY [1..MaxWords] OF
            RECORD
              Word: STRING;
              Count: INTEGER;
              Next: 0 .. MaxWords
            END;

FUNCTION CheckMax(MaxWords: INTEGER; CountArrWords: INTEGER): BOOLEAN;
BEGIN {CheckMax}
  IF CountArrWords >= MaxWords
  THEN
    CheckMax := TRUE
  ELSE
    CheckMax := FALSE  
END;{CheckMax}

PROCEDURE DuplicateWord(VAR List: RecArray; VAR FlagDuplicateWord: BOOLEAN; VAR Count: INTEGER; Curr: INTEGER);
BEGIN 
  FlagDuplicateWord := TRUE;
  List[Curr].Count := List[Curr].Count + 1;
  Count := Count - 1
END;

PROCEDURE InsertList(VAR List: RecArray; VAR Word: STRING; VAR Count: INTEGER; VAR First: INTEGER);
VAR
  Curr, Prev: 0 .. MaxWords;
  Found, FlagDuplicateWord: BOOLEAN;
BEGIN {InsertList}
  Prev := 0;
  Curr := First;
  Found := FALSE;
  FlagDuplicateWord := FALSE;
  WHILE (Curr <> 0) AND (NOT Found)
  DO
    BEGIN
      IF List[Curr].Word < Word
      THEN
        BEGIN
          Prev := Curr;
          Curr := List[Curr].Next
        END
      ELSE
        BEGIN
          Found := TRUE;
          IF List[Curr].Word = Word
          THEN
            DuplicateWord(List, FlagDuplicateWord, Count, Curr)
        END
    END;
  IF NOT FlagDuplicateWord
  THEN
    BEGIN
      IF Prev = 0
      THEN
        First := Count
      ELSE
        List[Prev].Next := Count;
      List[Count].Next := Curr;
      List[Count].Word := Word;
      List[Count].Count := 1
    END
END; {InsertList}

PROCEDURE CreateList(VAR FIn: TEXT; VAR List: RecArray; VAR First: INTEGER; VAR CountAllWords: INTEGER);
VAR
  Word: STRING;
  Prev, Curr: 0 .. MaxWords;
  CountArrWords, Count: INTEGER;
  Found, FlagMaxWords, DuplicateWord: BOOLEAN;
BEGIN {CreateList}
  First := 0;
  Count := 0;
  CountArrWords := 0;
  WHILE (NOT EOF(FIn)) AND (NOT CheckMax(MaxWords, CountArrWords))
  DO
    BEGIN
      IF NOT EOLN(FIn)
      THEN
        BEGIN
          Word := '';
          CreateWord(FIn, Word);
          IF Word <> '' 
          THEN
            BEGIN
              Count := Count + 1;
              CountAllWords := CountAllWords + 1;
              CountArrWords := CountArrWords + 1;
              InsertList(List, Word, Count, First)
            END
        END
      ELSE
        READLN(FIn)
    END
END; {CreateList}

PROCEDURE ReadFileAndCompareWithWordArr(VAR FIn: TEXT; VAR FOut: TEXT; VAR List: RecArray; VAR Count: INTEGER;  VAR First: INTEGER; VAR NodeOfFile: NodeFromFile; VAR FindPlaceNodeFile: BOOLEAN);
BEGIN {ReadFileAndCompareWithWordArr}
  IF FindPlaceNodeFile
  THEN 
    BEGIN
      NodeOfFile.Word := '';
      NodeOfFile.Count := 0;
      ReadWordAndCountFromFile(FIn, NodeOfFile)
    END;
  IF NodeOfFile.Word <> ''
  THEN
    BEGIN
      IF List[Count].Word >= NodeOfFile.Word
      THEN
        BEGIN
          IF List[Count].Word = NodeOfFile.Word
          THEN
            BEGIN
              NodeOfFile.Count := NodeOfFile.Count + List[Count].Count;
              Count := List[Count].Next 
            END;
          WRITELN(FOut, NodeOfFile.Word, ' ', NodeOfFile.Count);
          FindPlaceNodeFile := TRUE;
          NodeOfFile.Word := '';
          NodeOfFile.Count := 0
        END
      ELSE
        BEGIN
          WRITELN(FOut, List[Count].WORD, ' ', List[Count].Count);
          Count := List[Count].Next;
          FindPlaceNodeFile := FALSE
        END
    END
  ELSE
    BEGIN
      WRITELN(FOut, List[Count].Word, ' ', List[Count].Count);
      Count := List[Count].Next
    END
END; {ReadFileAndCompareWithWordArr}

PROCEDURE PrintList(VAR FIn: TEXT; VAR FOut: TEXT; VAR List: RecArray; VAR First: INTEGER; VAR FinallyRewrite: BOOLEAN);
VAR
  Count: INTEGER;
  NodeOfFile: NodeFromFile;
  FindPlaceNodeFile: BOOLEAN;
BEGIN {PrintList}
  IF NOT FinallyRewrite
  THEN
    BEGIN
      FindPlaceNodeFile := TRUE;
      Count := First;
      NodeOfFile.Word := '';
      NodeOfFile.Count := 0;
      WHILE Count <> IndexLastWord
      DO
        BEGIN
          IF NOT EOF(FIn)
          THEN
            ReadFileAndCompareWithWordArr(FIn, FOut, List, Count, First, NodeOfFile, FindPlaceNodeFile)
          ELSE
            BEGIN
              WRITELN(FOut, List[Count].Word, ' ', List[Count].Count);
              Count := List[Count].Next
            END
        END;
      IF NodeOfFile.Word <> ''
      THEN
        WRITELN(FOut, NodeOfFile.Word, ' ', NodeOfFile.Count);
    END;
  WHILE NOT EOF(FIn)
  DO
    BEGIN
      NodeOfFile.Word := '';
      NodeOfFile.Count := 0;
      ReadWordAndCountFromFile(FIn, NodeOfFile);
      IF NodeOfFile.Word <> ''
      THEN
        WRITELN(FOut, NodeOfFile.Word, ' ', NodeOfFile.Count)
    END
END; {PrintList}

PROCEDURE PrintListInFile(VAR FOut: TEXT; VAR FTemp: TEXT; VAR List: RecArray; VAR First: INTEGER; VAR FinallyRewrite: BOOLEAN; VAR WriteFOut1: BOOLEAN);
BEGIN
  IF WriteFOut1
  THEN
    BEGIN
      RESET(FTemp);
      REWRITE(FOut);
      PrintList(FTemp, FOut, List, First, FinallyRewrite);
      WriteFOut1 := FALSE
    END
  ELSE
    BEGIN
      RESET(FOut);
      REWRITE(FTemp);
      PrintList(FOut, FTemp, List, First, FinallyRewrite);
      WriteFOut1 := TRUE
    END 
END;

PROCEDURE CreateFile(VAR Fin: TEXT; VAR FOut: TEXT; VAR FTemp: TEXT);
VAR
  WriteFOut1: BOOLEAN;
  FinallyRewrite: BOOLEAN;
  List: RecArray;
  First: INTEGER;
  CountAllWords: INTEGER;
BEGIN {CreateFile}
  FinallyRewrite := FALSE;
  CountAllWords := 0;
  WriteFOut1 := TRUE;

  WHILE NOT EOF(FIn) 
  DO
    BEGIN
      CreateList(FIn, List, First, CountAllWords);
      PrintListInFile(FOut, FTemp, List, First, FinallyRewrite, WriteFOut1) 
    END;
  IF WriteFOut1
  THEN
    BEGIN
      FinallyRewrite := TRUE;
      RESET(FTemp);
      REWRITE(FOut);
      PrintList(FOut, FOut, List, First, FinallyRewrite);
    END;
  REWRITE(FTemp);
  WRITELN(FTemp, 'Пусто');
  WRITELN('All: ', CountAllWords) 
END; {CreateFile}

BEGIN  {CreateAndWriteList}
END. {sort}
