namespace MDV.Timesheet;

using Microsoft.Projects.Project.Journal;

/// <summary>
/// Stores which project journal template and batch the Timesheet Connector API inserts time entries into.
/// </summary>
table 60100 "MDV TS Connector Setup TSC"
{
    Caption = 'Timesheet Connector Setup';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            AllowInCustomizations = Never;
        }
        field(2; "Journal Template Name"; Code[10])
        {
            Caption = 'Journal Template Name';
            ToolTip = 'Specifies the project journal template that time entries from the API are inserted into.';
            TableRelation = "Job Journal Template";

            trigger OnValidate()
            begin
                if Rec."Journal Template Name" <> xRec."Journal Template Name" then
                    Rec."Journal Batch Name" := '';
            end;
        }
        field(3; "Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
            ToolTip = 'Specifies the project journal batch that time entries from the API are inserted into.';
            TableRelation = "Job Journal Batch".Name where("Journal Template Name" = field("Journal Template Name"));
        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }
}
