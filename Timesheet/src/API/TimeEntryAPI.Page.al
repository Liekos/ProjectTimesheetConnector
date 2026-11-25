namespace MDV.Timesheet;

using Microsoft.Projects.Project.Journal;

/// <summary>
/// API for creating time entries as project journal lines in the journal defined in Timesheet Connector Setup.
/// Lines can be read back (e.g. filtered on externalId) but not modified or deleted.
/// </summary>
page 60105 "MDV Time Entry API TSC"
{
    APIGroup = 'timesheet';
    APIPublisher = 'soeren';
    APIVersion = 'v1.0';
    Caption = 'timeEntries', Locked = true;
    DelayedInsert = true;
    DeleteAllowed = false;
    EntityName = 'timeEntry';
    EntitySetName = 'timeEntries';
    InsertAllowed = true;
    ModifyAllowed = false;
    ODataKeyFields = SystemId;
    PageType = API;
    SourceTable = "Job Journal Line";

    layout
    {
        area(Content)
        {
            repeater(Records)
            {
                field(id; Rec.SystemId)
                {
                    Caption = 'id', Locked = true;
                    Editable = false;
                }
                field(externalId; Rec."External Document No.")
                {
                    Caption = 'externalId', Locked = true;
                }
                field(projectNumber; ProjectNo)
                {
                    Caption = 'projectNumber', Locked = true;
                }
                field(projectTaskNumber; ProjectTaskNo)
                {
                    Caption = 'projectTaskNumber', Locked = true;
                }
                field(resourceNumber; ResourceNo)
                {
                    Caption = 'resourceNumber', Locked = true;
                }
                field(workTypeCode; WorkTypeCode)
                {
                    Caption = 'workTypeCode', Locked = true;
                }
                field(postingDate; PostingDate)
                {
                    Caption = 'postingDate', Locked = true;
                }
                field(quantity; EntryQuantity)
                {
                    Caption = 'quantity', Locked = true;
                }
                field(description; EntryDescription)
                {
                    Caption = 'description', Locked = true;
                }
                field(documentNumber; Rec."Document No.")
                {
                    Caption = 'documentNumber', Locked = true;
                    Editable = false;
                }
                field(lineNumber; Rec."Line No.")
                {
                    Caption = 'lineNumber', Locked = true;
                    Editable = false;
                }
                field(lastModifiedDateTime; Rec.SystemModifiedAt)
                {
                    Caption = 'lastModifiedDateTime', Locked = true;
                    Editable = false;
                }
            }
        }
    }

    var
        TimeEntryMgt: Codeunit "MDV Time Entry Mgt. TSC";
        ProjectNo: Code[20];
        ProjectTaskNo: Code[20];
        ResourceNo: Code[20];
        WorkTypeCode: Code[10];
        PostingDate: Date;
        EntryQuantity: Decimal;
        EntryDescription: Text[100];

    trigger OnOpenPage()
    begin
        TimeEntryMgt.SetJournalFilter(Rec);
    end;

    trigger OnAfterGetRecord()
    begin
        ProjectNo := Rec."Job No.";
        ProjectTaskNo := Rec."Job Task No.";
        ResourceNo := Rec."No.";
        WorkTypeCode := Rec."Work Type Code";
        PostingDate := Rec."Posting Date";
        EntryQuantity := Rec.Quantity;
        EntryDescription := Rec.Description;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        TimeEntryMgt.PrepareTimeEntry(Rec, ProjectNo, ProjectTaskNo, ResourceNo, WorkTypeCode, PostingDate, EntryQuantity, EntryDescription);
        exit(true);
    end;
}
