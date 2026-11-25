namespace MDV.Timesheet;

using Microsoft.Projects.Project.Job;

/// <summary>
/// Read-only API exposing open, non-blocked projects with their posting tasks.
/// </summary>
page 60101 "MDV Project API TSC"
{
    APIGroup = 'timesheet';
    APIPublisher = 'soeren';
    APIVersion = 'v1.0';
    Caption = 'projects', Locked = true;
    DataAccessIntent = ReadOnly;
    DelayedInsert = true;
    DeleteAllowed = false;
    Editable = false;
    EntityName = 'project';
    EntitySetName = 'projects';
    InsertAllowed = false;
    ModifyAllowed = false;
    ODataKeyFields = SystemId;
    PageType = API;
    SourceTable = Job;
    SourceTableView = where(Status = const(Open), Blocked = const(" "));

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
                field(number; Rec."No.")
                {
                    Caption = 'number', Locked = true;
                }
                field(description; Rec.Description)
                {
                    Caption = 'description', Locked = true;
                }
                field(customerNumber; Rec."Bill-to Customer No.")
                {
                    Caption = 'customerNumber', Locked = true;
                }
                field(customerName; Rec."Bill-to Name")
                {
                    Caption = 'customerName', Locked = true;
                }
                field(status; Rec.Status)
                {
                    Caption = 'status', Locked = true;
                }
                field(personResponsible; Rec."Person Responsible")
                {
                    Caption = 'personResponsible', Locked = true;
                }
                field(blocked; Rec.Blocked)
                {
                    Caption = 'blocked', Locked = true;
                }
                field(lastModifiedDateTime; Rec.SystemModifiedAt)
                {
                    Caption = 'lastModifiedDateTime', Locked = true;
                }
                part(projectTasks; "MDV Project Task API TSC")
                {
                    Caption = 'projectTasks', Locked = true;
                    EntityName = 'projectTask';
                    EntitySetName = 'projectTasks';
                    SubPageLink = "Job No." = field("No.");
                }
            }
        }
    }
}
