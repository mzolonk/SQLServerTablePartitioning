ALTER DATABASE [$(DatabaseName)]
  ADD FILEGROUP [PartirionFG];
GO

ALTER DATABASE [$(DatabaseName)]
  ADD FILE
  (
      NAME = [PartirionFG],
      FILENAME = '$(DefaultDataPath)$(DefaultFilePrefix)_PartirionFG.ndf'
  );
