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
PROCEDURE CreateList(VAR FIn: TEXT; VAR List: RecArray; VAR First: INTEGER);
PROCEDURE PrintList(VAR FOut: TEXT; VAR List: RecArray; VAR First: INTEGER);

IMPLEMENTATION
USES
  WorkWithWord;

FUNCTION CheckMax(MaxWords: INTEGER; CountAllWards: INTEGER): BOOLEAN;
BEGIN
  IF CountAllWards >= MaxWords
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

PROCEDURE CreateList(VAR FIn: TEXT; VAR List: RecArray; VAR First: INTEGER);
VAR
  Node: STRING;
  CountAllWards, Prev, Curr: 0 .. MaxWords;
  Count: INTEGER;
  Found, FlagMaxWords, DuplicateWord: BOOLEAN;
BEGIN {CreateList}
  First := 0;
  Count := 0;
  CountAllWards := 0;
  //FlagMaxWords := FALSE;
  WHILE (NOT EOF(FIn)) AND (NOT CheckMax(MaxWords, CountAllWards))
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
              InsertList(List, Node, Count, First)
            END
        END
      ELSE
        READLN(FIn)
    END; 
    WRITELN('All: ', CountAllWards, '.Unic: ', Count) 
END; {CreateList}



PROCEDURE UpdateList(VAR FOut: TEXT; VAR ListFout: RecArray; VAR ListFIn: RecArray; VAR First: INTEGER);
VAR
  ListFOut: RecArray;
  Node: STRING;
  CheckAllWords: INTEGER;

PROCEDURE ReadCountOfFOutNode(VAR List: RecArray; VAR Count: INTEGER);
BEGIN
  IF (NOT EOLN) AND (NOT EOF)
  THEN
    BEGIN
      WHILE (NOT EOLN()) OR (NOT Count IN INTEGER)
      DO
        BEGIN 
          READ(Count);
        END
    END
END;
PROCEDURE CreateListOfFOut(VAR FOut: TEXT;VAR List: RecArray);
VAR 
  Count: INTEGER;
  CountList: INTEGER;
  Node: STRING;
BEGIN
  CountList := 0;
  Node := '';
  Count := 1;
  IF (NOT EOLN(FOut)) AND (NOT EOF(FOut))
  THEN
    BEGIN
      WHILE (NOT EOF(FOut)) OR (Count <> MaxWords)
      DO
        BEGIN
          IF NOT EOLN(FOut)
          THEN
            CreateNode(FOut, Node);
            IF Node <> ''
            THEN
              BEGIN
                ReadCountOfFOutNode(FOut, Count);
                List[Count].Node := Node;
                List[Count].Count := Count;
                Count := Count + 1
              END
          ELSE
            IF NOT EOF(FOut)
            THEN
              READLN(FOut)
        END
    END

END;

PROCEDURE AddCount(VAR ListFIn: RecArray; VAR ListFOut: RecArray; VAR CheckAllWords: INTEGER);
VAR 
  Count: INTEGER;
  
BEGIN
  Count := 0;
  CheckAllWords := 0
  WHILE Count <> MaxWords
  DO
    BEGIN
      IF ListFIn[Count].Node = ListFOut[Count].Node
      THEN
        BEGIN
          ListFOut[Count].Count := ListFOut[Count].Count + 1;
          CheckAllWords := CheckAllWords + 1;
        END
      Count := Count + 1;
    END
END
BEGIN {UpdateList}
  // CreateList(FIn, RecArray, First);
  CreateListOfFOut(FOut, ListFOut);
  AddCount(ListFOut, ListFIn, CheckAllWords);
    
END; {UpdateList}

// FUNCTION CheckElemArray(List: RecArray): BOOLEAN;
// VAR
//   Count: INTEGER;
//   Found: BOOLEAN;
// BEGIN
//   Found := TRUE;
//   Count := 1;
//   WHILE  (Count <> 137000) AND (Found = TRUE)
//   DO
//     BEGIN
//       IF List[Count].Node = ''
//       THEN
//         CheckElemArray := FALSE
//     END;
//   CheckElemArray := Found
// END;

PROCEDURE PrintList(VAR FOut: TEXT; VAR List: RecArray; VAR First: INTEGER);
VAR
  Count: INTEGER;
BEGIN {PrintList}
  Count := First;
  WHILE Count <> 0
  DO
    BEGIN
      WRITELN(FOut, List[Count].Node, ' ', List[Count].Count);
      Count := List[Count].Next
    END
END; {PrintList}

BEGIN {sort}
END. {sort}
