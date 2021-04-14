﻿CREATE PARTITION FUNCTION [IntPartPFN](BIGINT)
    AS RANGE LEFT
    FOR VALUES (
                  1000000,
                  2000000,
                  3000000,
                  4000000,
                  5000000,
                  6000000,
                  7000000,
                  8000000,
                  9000000,
                  10000000
                )
