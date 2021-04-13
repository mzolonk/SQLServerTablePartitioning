CREATE TABLE [dbo].[Comments] (
    [Id]           BIGINT            IDENTITY (1, 1) NOT NULL,
    [CreationDate] DATETIME       NOT NULL,
    [PostId]       INT            NOT NULL,
    [Score]        TINYINT        NULL,
    [Comment]      NVARCHAR (700) NOT NULL,
    [UserId]       INT            NULL,
    CONSTRAINT [PK_Comments_Id] PRIMARY KEY CLUSTERED 
    (
      [Id] 
    ) ON [IntPartSCH] ([Id])
) ON [IntPartSCH] ([Id]);

