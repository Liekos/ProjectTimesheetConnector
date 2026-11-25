namespace MDV.Timesheet;

/// <summary>
/// Setup card for choosing the project journal that receives time entries from the Timesheet Connector API.
/// </summary>
page 60100 "MDV TS Connector Setup TSC"
{
    ApplicationArea = All;
    Caption = 'Timesheet Connector Setup';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "MDV TS Connector Setup TSC";
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Journal Template Name"; Rec."Journal Template Name") { }
                field("Journal Batch Name"; Rec."Journal Batch Name") { }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;
    end;
}
