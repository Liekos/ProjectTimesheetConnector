namespace MDV.Timesheet;

using Microsoft.Utilities;

/// <summary>
/// Read-only API exposing work types.
/// </summary>
page 60104 "MDV Work Type API TSC"
{
    APIGroup = 'timesheet';
    APIPublisher = 'soeren';
    APIVersion = 'v1.0';
    Caption = 'workTypes', Locked = true;
    DataAccessIntent = ReadOnly;
    DelayedInsert = true;
    DeleteAllowed = false;
    Editable = false;
    EntityName = 'workType';
    EntitySetName = 'workTypes';
    InsertAllowed = false;
    ModifyAllowed = false;
    ODataKeyFields = SystemId;
    PageType = API;
    SourceTable = "Work Type";

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
                field(code; Rec.Code)
                {
                    Caption = 'code', Locked = true;
                }
                field(description; Rec.Description)
                {
                    Caption = 'description', Locked = true;
                }
                field(unitOfMeasureCode; Rec."Unit of Measure Code")
                {
                    Caption = 'unitOfMeasureCode', Locked = true;
                }
                field(lastModifiedDateTime; Rec.SystemModifiedAt)
                {
                    Caption = 'lastModifiedDateTime', Locked = true;
                }
            }
        }
    }
}
