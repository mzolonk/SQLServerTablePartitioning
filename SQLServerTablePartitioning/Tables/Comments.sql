CREATE TABLE [dbo].[Comments] (
    [Id]           INT            IDENTITY (1, 1) NOT NULL,
    [CreationDate] INT            NOT NULL,
    [PostId]       INT            NOT NULL,
    [Score]        TINYINT        NULL,
    [Comment]      NVARCHAR (700) NOT NULL,
    [UserId]       INT            NULL,
    CONSTRAINT [PK_Comments_Id] PRIMARY KEY CLUSTERED 
    (
       [CreationDate] , [Id] 
    ) ON [DateAsIntPartSCH] ([CreationDate])
) ON [DateAsIntPartSCH] ([CreationDate]);

