namespace MDV.Timesheet;

using Microsoft.Projects.Project.Job;

/// <summary>
/// Read-only API exposing project tasks of type Posting. Used standalone and as the projectTasks part of the projects API.
/// </summary>
page 60102 "MDV Project Task API TSC"
{
    APIGroup = 'timesheet';
    APIPublisher = 'soeren';
    APIVersion = 'v1.0';
    Caption = 'projectTasks', Locked = true;
    DataAccessIntent = ReadOnly;
    DelayedInsert = true;
    DeleteAllowed = false;
    Editable = false;
    EntityName = 'projectTask';
    EntitySetName = 'projectTasks';
    InsertAllowed = false;
    ModifyAllowed = false;
    ODataKeyFields = SystemId;
    PageType = API;
    SourceTable = "Job Task";
    SourceTableView = where("Job Task Type" = const(Posting));

    layout
    {
        area(Content)
        {
            repeater(Records)
            {
                field(id; Rec.SystemId)
                {
                    Caption = 'id', Locked = true;
                }
                field(projectNumber; Rec."Job No.")
                {
                    Caption = 'projectNumber', Locked = true;
                }
                field(number; Rec."Job Task No.")
                {
                    Caption = 'number', Locked = true;
                }
                field(description; Rec.Description)
                {
                    Caption = 'description', Locked = true;
                }
                field(taskType; Rec."Job Task Type")
                {
                    Caption = 'taskType', Locked = true;
                }
                field(lastModifiedDateTime; Rec.SystemModifiedAt)
                {
                    Caption = 'lastModifiedDateTime', Locked = true;
                }
            }
        }
    }
}
