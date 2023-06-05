PROGRAM CountWords(INPUT, OUTPUT);
USES
  CreateAndWriteList;
USES
  WorkWithMatchingWords;
VAR
  FileWithText, FileForOutpup, FileTemt, FEndings, FMatchingWords: TEXT;
BEGIN {CountWords}
  ASSIGN(FileWithText, 'INPUT44.txt');
  ASSIGN(FileForOutpup, 'OUTPUT.txt');
  ASSIGN(FileTemt, 'TEMP.txt');
  ASSIGN(FEndings, 'endings.txt');
  ASSIGN(FMatchingWords, 'MatchingWords.txt');
  RESET(FileWithText);
  REWRITE(FileForOutpup);
  REWRITE(FileTemt);
  CreateFile(FileWithText, FileForOutpup, FileTemt);
  CreateFileWithMatchingWords(FileForOutpup, FMatchingWords, FEndings);
END.  {CountWords}

