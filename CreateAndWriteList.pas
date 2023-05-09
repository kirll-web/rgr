UNIT CreateAndWriteList;
INTERFACE
Const 
  MaxWords = 1000;
  IndexLastWord = 0;
TYPE
  RecArray = ARRAY [1..MaxWords] OF
            RECORD
              Node: STRING;
              Count: INTEGER;
              Next: 0 .. MaxWords
            END;
  Node = RECORD
          Node: STRING;
          Count: INTEGER;
        END;
PROCEDURE CreateFile(VAR Fin: TEXT; VAR Fout1: TEXT; VAR Fout2: TEXT; VAR List: RecArray; VAR First: INTEGER; VAR CountAllWards: INTEGER);

IMPLEMENTATION
USES
  WorkWithWord;

FUNCTION CheckMax(MaxWords: INTEGER; CountArrWords: INTEGER): BOOLEAN;
BEGIN
  IF CountArrWords >= MaxWords
  THEN
    BEGIN
     CheckMax := TRUE;
     WRITELN('MaxWords')
    END
  ELSE
    CheckMax := FALSE  
END;

PROCEDURE DuplicateWord(VAR List: RecArray; VAR FlagDuplicateWord: BOOLEAN; VAR Count: INTEGER; Curr: INTEGER);
BEGIN
  FlagDuplicateWord := TRUE;
  List[Curr].Count := List[Curr].Count + 1;
  Count := Count - 1
END;


PROCEDURE InsertList(VAR List: RecArray; VAR Node: STRING; VAR Count: INTEGER; VAR First: INTEGER);
VAR
  Curr, Prev: 0 .. MaxWords;
  Found, FlagDuplicateWord: BOOLEAN;
BEGIN
  Prev := 0;
  Curr := First;
  Found := FALSE;
  FlagDuplicateWord := FALSE;
  WHILE (Curr <> 0) AND (NOT Found)
  DO
    BEGIN
      IF List[Curr].Node < Node
      THEN
        BEGIN
          Prev := Curr;
          Curr := List[Curr].Next
        END
      ELSE
        BEGIN
          Found := TRUE;
          IF List[Curr].Node = Node
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
      List[Count].Node := Node;
      List[Count].Count := 1
    END;
END;

PROCEDURE CreateList(VAR FIn: TEXT; VAR List: RecArray; VAR First: INTEGER; VAR CountAllWards: INTEGER);
VAR
  Node: STRING;
  Prev, Curr: 0 .. MaxWords;
  CountArrWords, Count: INTEGER;
  Found, FlagMaxWords, DuplicateWord: BOOLEAN;
BEGIN {CreateList}
  First := 0;
  Count := 0;
  CountArrWords := 0;
  //FlagMaxWords := FALSE;
  WHILE (NOT EOF(FIn)) AND (NOT CheckMax(MaxWords, CountArrWords))
  DO
    BEGIN
      IF NOT EOLN(FIn)
      THEN
        BEGIN
          Node := '';
          CreateNode(FIn, Node);
          IF Node <> '' 
          THEN
            BEGIN
              Count := Count + 1;
              CountAllWards := CountAllWards + 1;
              CountArrWords := CountArrWords + 1;
              InsertList(List, Node, Count, First)
            END
        END
      ELSE
        READLN(FIn)
    END; 
  WRITELN('All: ', CountAllWards, '.Unic: ', Count) 
END; {CreateList}


PROCEDURE ReadWordAndCountOfFile(VAR FIn: TEXT; VAR NodeFile: Node);
VAR
  Ch: CHAR;
BEGIN
  IF (NOT EOLN(FIn)) AND (NOT EOF(FIn)) 
  THEN
    BEGIN
      READ(FIn, Ch);
      WHILE (Ch <> ' ') 
      DO
        BEGIN
          NodeFile.Node := NodeFile.Node + Ch;
          READ(FIn, Ch);
        END;
      READ(FIn, NodeFile.Count);
      READLN(FIn)
    END;
END;

PROCEDURE ReadFileAndCompareWithWordArr(VAR FIn: TEXT; VAR FOut: TEXT; VAR List: RecArray; VAR Count: INTEGER;  VAR First: INTEGER; VAR NodeFile: Node; VAR FindPlaceNodeFile: BOOLEAN);
BEGIN
  IF FindPlaceNodeFile
  THEN 
    BEGIN
      NodeFile.Node := '';
      NodeFile.Count := 0;
      ReadWordAndCountOfFile(FIn, NodeFile)
    END;
  IF NodeFile.Node <> ''
  THEN
    BEGIN
      IF List[Count].Node >= NodeFile.Node
      THEN
        BEGIN
          IF List[Count].Node = NodeFile.Node
          THEN
            BEGIN
              NodeFile.Count := NodeFile.Count + List[Count].Count;
              Count := List[Count].Next; 
            END;
          WRITELN(FOut, NodeFile.Node, ' ', NodeFile.Count);
          FindPlaceNodeFile := TRUE;
          NodeFile.Node := '';
          NodeFile.Count := 0;
        END
      ELSE
        BEGIN
          WRITELN(FOut, List[Count].Node, ' ', List[Count].Count);
          Count := List[Count].Next;
          FindPlaceNodeFile := FALSE;
        END
    END
  ELSE
    BEGIN
      WRITELN(FOut, List[Count].Node, ' ', List[Count].Count);
      Count := List[Count].Next
    END
END;

PROCEDURE PrintList(VAR FIn: TEXT; VAR FOut: TEXT; VAR List: RecArray; VAR First: INTEGER; VAR FinallyRewrite: BOOLEAN);
VAR
  Count: INTEGER;
  NodeFile: Node;
  FindPlaceNodeFile: BOOLEAN;
BEGIN {PrintList}
  IF NOT FinallyRewrite
  THEN
    BEGIN
      FindPlaceNodeFile := TRUE;
      Count := First;
      NodeFile.Node := '';
      NodeFile.Count := 0;
      WHILE Count <> 0
      DO
        BEGIN
          IF NOT EOF(FIn)
          THEN
            BEGIN
              ReadFileAndCompareWithWordArr(FIn, FOut, List, Count, First, NodeFile, FindPlaceNodeFile);
            END
          ELSE
            BEGIN
              WRITELN(FOut, List[Count].Node, ' ', List[Count].Count);
              Count := List[Count].Next
            END
        END;
      IF NodeFile.Node <> ''
      THEN
        WRITELN(FOut, NodeFile.Node, ' ', NodeFile.Count);
    END;
  WHILE NOT EOF(FIn)
  DO
    BEGIN
      NodeFile.Node := '';
      NodeFile.Count := 0;
      ReadWordAndCountOfFile(FIn, NodeFile);
      IF NodeFile.Node <> ''
      THEN
        WRITELN(FOut, NodeFile.Node, ' ', NodeFile.Count);
    END;
END; {PrintList}

PROCEDURE CreateFile(VAR Fin: TEXT; VAR FOut1: TEXT; VAR FOut2: TEXT; VAR List: RecArray; VAR First: INTEGER; VAR CountAllWards: INTEGER);
VAR
  WriteFOut1: BOOLEAN;
  FinallyRewrite: BOOLEAN;
BEGIN {sort}
  FinallyRewrite := FALSE;
  CountAllWards := 0;
  WriteFOut1 := TRUE;
  WHILE NOT EOF(FIn) 
  DO
    BEGIN
      CreateList(FIn, List, First, CountAllWards);
      IF WriteFOut1
      THEN
        BEGIN
          RESET(FOut2);
          REWRITE(FOut1);
          PrintList(FOut2, FOut1, List, First, FinallyRewrite);
          WriteFOut1 := FALSE
        END
      ELSE
        BEGIN
          RESET(FOut1);
          REWRITE(FOut2);
          PrintList(FOut1, FOut2, List, First, FinallyRewrite);
          WriteFOut1 := TRUE;
        END  
    END;
  IF WriteFOut1
  THEN
    BEGIN
      FinallyRewrite := TRUE;
      RESET(FOut2);
      REWRITE(FOut1);
      PrintList(FOut2, FOut1, List, First, FinallyRewrite);
      REWRITE(FOut2);
      WRITELN(FOut2)
    END
  ELSE
    BEGIN
      REWRITE(FOut2);
      WRITELN(FOut2, 'осярн');
    END;
  WRITELN('All: ', CountAllWards) 
END;
BEGIN
END. {sort}
