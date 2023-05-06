PROGRAM CountWords(INPUT, OUTPUT);
USES
  CreateAndWriteList;
VAR
  FileWithText, FileForOutpup, FileTemt: TEXT;
  Node: STRING;
  List: RecArray;
  First: INTEGER;
BEGIN {CountWords}
  ASSIGN(FileWithText, 'INPUT.txt');
  ASSIGN(FileForOutpup, 'OUTPUT.txt');
  ASSIGN(FileTemt, 'TEMP.txt');
  RESET(FileWithText);
  WHILE NOT EOF(FileWithText)
  DO
    BEGIN
      CreateList(FileWithText, List, First);
      REWRITE(FileForOutpup);
      PrintList(FileForOutpup, List, First);
      CreateList(FileWithText, List, First);
      REWRITE(FileTemt);
      PrintList(FileTemt, List, First);
    END
END.  {CountWords}
