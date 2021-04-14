/*
Post-Deployment Script Template                            
--------------------------------------------------------------------------------------
 This file contains SQL statements that will be appended to the build script.        
 Use SQLCMD syntax to include a file in the post-deployment script.            
 Example:      :r .\myfile.sql                                
 Use SQLCMD syntax to reference a variable in the post-deployment script.        
 Example:      :setvar TableName MyTable                            
               SELECT * FROM [$(TableName)]                    
--------------------------------------------------------------------------------------
*/

 :setvar JobName "SplitAndMergePartitions"
 :setvar RedeployJobs "NO"

PRINT 'Deploying job: $(JobName)';
DECLARE @JobId  UNIQUEIDENTIFIER;

SELECT  @JobId = job_id
FROM    msdb.dbo.sysjobs
WHERE   name = '$(JobName)';

/*
 * First we check existence of the specified job name and whether the RedeployJobs parameter
 * has been set to "YES".
 */
IF UPPER('$(RedeployJobs)') = 'YES'   /* Redeploy the job */
OR @JobId IS NULL                   /* It does not exist so deploy it anyway */
BEGIN;
    /*
     * Either this is a new job or the RedeployJobs parameter is set to YES.  If its an existing job
     * we need to remove it so that we can "redeploy" it.
     */
    IF @JobId IS NOT NULL
    BEGIN;
        PRINT ' Deleting existing job';
        EXEC msdb.dbo.sp_delete_job @job_id = @JobId;

        /*
         * Set the @JobId variable to NULL for the sp_add_job command later on.  If it is not null the
         * server things the job is from a MSX server
         */
        SET @JobId = NULL;
    END;
     
    /*
     * Add the job
     */
  EXEC msdb.dbo.sp_add_job @job_name=N'$(JobName)', 
  @enabled=1, 
  @notify_level_eventlog=0, 
  @notify_level_email=0, 
  @notify_level_netsend=0, 
  @notify_level_page=0, 
  @delete_level=0, 
  @description=N'This job creates new partition and deletes data from the oldest and merge', 
  @category_name=N'Database Maintenance', 
  @owner_login_name=N'sa', 
  @job_id = @jobId OUTPUT;

    /*
     * Add the job step(s)
     */
  EXEC msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Split and Merge', 
  @step_id=1, 
  @cmdexec_success_code=0, 
  @on_success_action=1, 
  @on_success_step_id=0, 
  @on_fail_action=2, 
  @on_fail_step_id=0, 
  @retry_attempts=0, 
  @retry_interval=0, 
  @os_run_priority=0, @subsystem=N'TSQL', 
  @command=N'/* @PartitionsToKeep => how much data we want to keep on the table, 
                                    each partition is approximately 1 million rows */

            EXEC [dbo].[SplitAndMergePartition] @PartitionsToKeep = 10', 
  @database_name=N'$(DatabaseName)', 
  @flags=0;

    EXEC msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1;

    /*
     * Add the job schedule
     */
EXEC msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'$(JobName)', 
     @enabled=1, 
     @freq_type=4, 
     @freq_interval=1, 
     @freq_subday_type=1, 
     @freq_subday_interval=0, 
     @freq_relative_interval=0, 
     @freq_recurrence_factor=0, 
     @active_start_date=20210128, 
     @active_end_date=99991231, 
     @active_start_time=3000, 
     @active_end_time=235959

    /*
     * Add the job server
     */
    EXEC msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)';

    PRINT ' Created the job "$(JobName)"';
END;
ELSE
BEGIN;
    PRINT ' Bypassing job "$(JobName)" deployment as job exists and RedeployJob parameter is "$(RedeployJobs)"';
END;
GO
