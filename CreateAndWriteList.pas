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
