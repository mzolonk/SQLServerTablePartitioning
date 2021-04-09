CREATE PARTITION FUNCTION [DateAsIntPartPFN](INT)
    AS RANGE
    FOR VALUES (
                 --OffLine Partitions
                 CONVERT(INT, CONVERT( VARCHAR, GETDATE() - 5, 112)),
                 CONVERT(INT, CONVERT( VARCHAR, GETDATE() - 4, 112)),
                 CONVERT(INT, CONVERT( VARCHAR, GETDATE() - 3, 112)),
                 CONVERT(INT, CONVERT( VARCHAR, GETDATE() - 2, 112)),
                 CONVERT(INT, CONVERT( VARCHAR, GETDATE() - 1, 112)),
                 --Today's Partition/ Live partition
  				 CONVERT(INT, CONVERT( VARCHAR, GETDATE(), 112)),
                 -- Future Partition
  				 CONVERT(INT, CONVERT( VARCHAR, GETDATE() + 1, 112)),
                 CONVERT(INT, CONVERT( VARCHAR, GETDATE() + 2, 112)),
  				 CONVERT(INT, CONVERT( VARCHAR, GETDATE() + 3, 112)),
  				 CONVERT(INT, CONVERT( VARCHAR, GETDATE() + 4, 112)),
  				 CONVERT(INT, CONVERT( VARCHAR, GETDATE() + 5, 112))
                )
