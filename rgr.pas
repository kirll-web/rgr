PROGRAM CountWords(INPUT, OUTPUT);
USES
  CreateAndWriteList;
VAR
  FileWithText, FileForOutpup, FileTemt: TEXT;
  Node: STRING;
  List: RecArray;
  First: INTEGER;
  CountAllWards: INTEGER;
BEGIN {CountWords}
  ASSIGN(FileWithText, 'INPUT.txt');
  ASSIGN(FileForOutpup, 'OUTPUT.txt');
  ASSIGN(FileTemt, 'TEMP.txt');
  RESET(FileWithText);
  REWRITE(FileForOutpup);
  REWRITE(FileTemt);
  CreateFile(FileWithText, FileForOutpup, FileTemt, List, First, CountAllWards);
END.  {CountWords}
