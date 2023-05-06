PROGRAM CountWords(INPUT, OUTPUT);
USES
  CreateAndWriteList;
VAR
  FileWithText, FileForOutpup: TEXT;
  Node: STRING;
  List: RecArray;
  First: INTEGER;
BEGIN {CountWords}
  ASSIGN(FileWithText, 'INPUT.txt');
  ASSIGN(FileForOutpup, 'OUTPUT.txt');
  RESET(FileWithText);
  CreateList(FileWithText, List, First);
  REWRITE(FileForOutpup);
  PrintList(FileForOutpup, List, First)
END.  {CountWords}
