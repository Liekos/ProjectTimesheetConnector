namespace MDV.Timesheet;

using Microsoft.Projects.Resources.Resource;

/// <summary>
/// Read-only API exposing non-blocked resources.
/// </summary>
page 60103 "MDV Resource API TSC"
{
    APIGroup = 'timesheet';
    APIPublisher = 'soeren';
    APIVersion = 'v1.0';
    Caption = 'resources', Locked = true;
    DataAccessIntent = ReadOnly;
    DelayedInsert = true;
    DeleteAllowed = false;
    Editable = false;
    EntityName = 'resource';
    EntitySetName = 'resources';
    InsertAllowed = false;
    ModifyAllowed = false;
    ODataKeyFields = SystemId;
    PageType = API;
    SourceTable = Resource;
    SourceTableView = where(Blocked = const(false));

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
                field(name; Rec.Name)
                {
                    Caption = 'name', Locked = true;
                }
                field(type; Rec.Type)
                {
                    Caption = 'type', Locked = true;
                }
                field(baseUnitOfMeasure; Rec."Base Unit of Measure")
                {
                    Caption = 'baseUnitOfMeasure', Locked = true;
                }
                field(blocked; Rec.Blocked)
                {
                    Caption = 'blocked', Locked = true;
                }
                field(lastModifiedDateTime; Rec.SystemModifiedAt)
                {
                    Caption = 'lastModifiedDateTime', Locked = true;
                }
            }
        }
    }
}
