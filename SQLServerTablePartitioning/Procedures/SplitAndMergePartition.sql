CREATE PROCEDURE [dbo].[SplitAndMergePartition] @PartitionsToKeep INT = 10
AS
BEGIN
  SET NOCOUNT ON;
  
  DECLARE @FuturePartition BIGINT,
          @OlderstPartition BIGINT,
          @LatestPartition BIGINT,
          @PartCount INT,
          @PartitionConstant BIGINT = 1000000;
  
  --This will give incorrect result in a case where you have Non Clustered indexes on the table
  SELECT @PartCount = COUNT(1)
    FROM sys.partition_functions pf 
   JOIN sys.partition_range_values prv
     ON pf.function_id =  prv.function_id
  WHERE pf.name = 'IntPartPFN'

  IF (@PartCount > @PartitionsToKeep)
  BEGIN
    SELECT @OlderstPartition = CONVERT(BIGINT, prv.value)
     FROM sys.partition_functions pf 
     JOIN sys.partition_range_values prv
       ON pf.function_id =  prv.function_id
    WHERE pf.name = 'IntPartPFN'
      AND boundary_id = 1;
      
     --Bets practice is to always keep the last partition empty.
     TRUNCATE TABLE dbo.Comments WITH (PARTITIONS(1, 2));
     
     ALTER PARTITION SCHEME IntPartSCH
      NEXT USED PartirionFG;
     
     ALTER PARTITION FUNCTION IntPartPFN()
     MERGE RANGE (@OlderstPartition);
  END

  --Creating new Partition
  SELECT @LatestPartition =  CONVERT(BIGINT, MAX(prv.value))
   FROM sys.partition_functions pf 
   JOIN sys.partition_range_values prv
     ON pf.function_id =  prv.function_id
  WHERE pf.name = 'IntPartPFN'

  SELECT @FuturePartition = @LatestPartition + @PartitionConstant;

  ALTER PARTITION SCHEME IntPartSCH
    NEXT USED PartirionFG;
  
  ALTER PARTITION FUNCTION IntPartPFN()
  SPLIT RANGE (@FuturePartition);
  
END