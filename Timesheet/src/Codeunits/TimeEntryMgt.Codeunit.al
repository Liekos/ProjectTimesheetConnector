namespace MDV.Timesheet;

using Microsoft.Projects.Project.Job;
using Microsoft.Projects.Project.Journal;
using Microsoft.Projects.Resources.Resource;

/// <summary>
/// Validates and prepares time entries received through the Timesheet Connector API as project journal lines.
/// The lines are not posted; posting is done manually in Business Central.
/// </summary>
codeunit 60100 "MDV Time Entry Mgt. TSC"
{
    Access = Internal;

    var
        DuplicateExternalIdErr: Label 'A time entry with externalId %1 already exists in project journal %2 %3.', Comment = '%1 = External ID, %2 = Journal Template Name, %3 = Journal Batch Name';
        MissingValueErr: Label 'The field %1 must be specified.', Comment = '%1 = API field name';
        ProjectBlockedErr: Label 'Project %1 is blocked.', Comment = '%1 = Project No.';
        ProjectNotFoundErr: Label 'Project %1 does not exist.', Comment = '%1 = Project No.';
        ProjectNotOpenErr: Label 'Project %1 does not have status Open.', Comment = '%1 = Project No.';
        ProjectTaskNotFoundErr: Label 'Project task %2 does not exist on project %1.', Comment = '%1 = Project No., %2 = Project Task No.';
        ProjectTaskNotPostingErr: Label 'Project task %2 on project %1 is not of type Posting.', Comment = '%1 = Project No., %2 = Project Task No.';
        ResourceBlockedErr: Label 'Resource %1 is blocked.', Comment = '%1 = Resource No.';
        ResourceNotFoundErr: Label 'Resource %1 does not exist.', Comment = '%1 = Resource No.';
        SetupMissingErr: Label 'Timesheet Connector Setup has not been set up.';
        ExternalIdTok: Label 'externalId', Locked = true;
        PostingDateTok: Label 'postingDate', Locked = true;
        ProjectNumberTok: Label 'projectNumber', Locked = true;
        ProjectTaskNumberTok: Label 'projectTaskNumber', Locked = true;
        QuantityTok: Label 'quantity', Locked = true;
        ResourceNumberTok: Label 'resourceNumber', Locked = true;

    /// <summary>
    /// Restricts the journal lines to the journal template and batch defined in the setup.
    /// </summary>
    /// <param name="JobJournalLine">The journal line record to filter.</param>
    procedure SetJournalFilter(var JobJournalLine: Record "Job Journal Line")
    var
        TSConnectorSetup: Record "MDV TS Connector Setup TSC";
    begin
        GetSetup(TSConnectorSetup);
        JobJournalLine.FilterGroup(2);
        JobJournalLine.SetRange("Journal Template Name", TSConnectorSetup."Journal Template Name");
        JobJournalLine.SetRange("Journal Batch Name", TSConnectorSetup."Journal Batch Name");
        JobJournalLine.FilterGroup(0);
    end;

    /// <summary>
    /// Validates the received values and fills a new resource journal line in the configured project journal.
    /// The External Document No. already assigned on the line is used as the external ID.
    /// </summary>
    /// <param name="JobJournalLine">The new journal line to fill. It is inserted by the caller.</param>
    /// <param name="ProjectNo">The project number.</param>
    /// <param name="ProjectTaskNo">The project task number.</param>
    /// <param name="ResourceNo">The resource number.</param>
    /// <param name="WorkTypeCode">The work type code. Optional.</param>
    /// <param name="PostingDate">The posting date.</param>
    /// <param name="EntryQuantity">The number of hours.</param>
    /// <param name="EntryDescription">The description. Optional; when empty the resource name is used.</param>
    procedure PrepareTimeEntry(var JobJournalLine: Record "Job Journal Line"; ProjectNo: Code[20]; ProjectTaskNo: Code[20]; ResourceNo: Code[20]; WorkTypeCode: Code[10]; PostingDate: Date; EntryQuantity: Decimal; EntryDescription: Text[100])
    var
        TSConnectorSetup: Record "MDV TS Connector Setup TSC";
        ExternalId: Code[35];
    begin
        ExternalId := JobJournalLine."External Document No.";
        CheckMandatoryValues(ExternalId, ProjectNo, ProjectTaskNo, ResourceNo, PostingDate, EntryQuantity);
        GetSetup(TSConnectorSetup);
        CheckDuplicateExternalId(TSConnectorSetup, ExternalId);
        CheckProject(ProjectNo);
        CheckProjectTask(ProjectNo, ProjectTaskNo);
        CheckResource(ResourceNo);

        InitJournalLine(JobJournalLine, TSConnectorSetup);
        JobJournalLine.Validate("Posting Date", PostingDate);
        JobJournalLine.Validate("Job No.", ProjectNo);
        JobJournalLine.Validate("Job Task No.", ProjectTaskNo);
        JobJournalLine.Validate(Type, JobJournalLine.Type::Resource);
        JobJournalLine.Validate("No.", ResourceNo);
        if WorkTypeCode <> '' then
            JobJournalLine.Validate("Work Type Code", WorkTypeCode);
        JobJournalLine.Validate(Quantity, EntryQuantity);
        if EntryDescription <> '' then
            JobJournalLine.Validate(Description, EntryDescription);
        JobJournalLine.Validate("External Document No.", ExternalId);
    end;

    local procedure GetSetup(var TSConnectorSetup: Record "MDV TS Connector Setup TSC")
    begin
        if not TSConnectorSetup.Get() then
            Error(SetupMissingErr);
        TSConnectorSetup.TestField("Journal Template Name");
        TSConnectorSetup.TestField("Journal Batch Name");
    end;

    local procedure CheckMandatoryValues(ExternalId: Code[35]; ProjectNo: Code[20]; ProjectTaskNo: Code[20]; ResourceNo: Code[20]; PostingDate: Date; EntryQuantity: Decimal)
    begin
        if ExternalId = '' then
            Error(MissingValueErr, ExternalIdTok);
        if ProjectNo = '' then
            Error(MissingValueErr, ProjectNumberTok);
        if ProjectTaskNo = '' then
            Error(MissingValueErr, ProjectTaskNumberTok);
        if ResourceNo = '' then
            Error(MissingValueErr, ResourceNumberTok);
        if PostingDate = 0D then
            Error(MissingValueErr, PostingDateTok);
        if EntryQuantity = 0 then
            Error(MissingValueErr, QuantityTok);
    end;

    local procedure CheckDuplicateExternalId(TSConnectorSetup: Record "MDV TS Connector Setup TSC"; ExternalId: Code[35])
    var
        JobJournalLine: Record "Job Journal Line";
    begin
        JobJournalLine.SetRange("Journal Template Name", TSConnectorSetup."Journal Template Name");
        JobJournalLine.SetRange("Journal Batch Name", TSConnectorSetup."Journal Batch Name");
        JobJournalLine.SetRange("External Document No.", ExternalId);
        if not JobJournalLine.IsEmpty() then
            Error(DuplicateExternalIdErr, ExternalId, TSConnectorSetup."Journal Template Name", TSConnectorSetup."Journal Batch Name");
    end;

    local procedure CheckProject(ProjectNo: Code[20])
    var
        Job: Record Job;
    begin
        Job.SetLoadFields(Status, Blocked);
        if not Job.Get(ProjectNo) then
            Error(ProjectNotFoundErr, ProjectNo);
        if Job.Blocked <> Job.Blocked::" " then
            Error(ProjectBlockedErr, ProjectNo);
        if Job.Status <> Job.Status::Open then
            Error(ProjectNotOpenErr, ProjectNo);
    end;

    local procedure CheckProjectTask(ProjectNo: Code[20]; ProjectTaskNo: Code[20])
    var
        JobTask: Record "Job Task";
    begin
        JobTask.SetLoadFields("Job Task Type");
        if not JobTask.Get(ProjectNo, ProjectTaskNo) then
            Error(ProjectTaskNotFoundErr, ProjectNo, ProjectTaskNo);
        if JobTask."Job Task Type" <> JobTask."Job Task Type"::Posting then
            Error(ProjectTaskNotPostingErr, ProjectNo, ProjectTaskNo);
    end;

    local procedure CheckResource(ResourceNo: Code[20])
    var
        Resource: Record Resource;
    begin
        Resource.SetLoadFields(Blocked);
        if not Resource.Get(ResourceNo) then
            Error(ResourceNotFoundErr, ResourceNo);
        if Resource.Blocked then
            Error(ResourceBlockedErr, ResourceNo);
    end;

    local procedure InitJournalLine(var JobJournalLine: Record "Job Journal Line"; TSConnectorSetup: Record "MDV TS Connector Setup TSC")
    var
        LastJobJournalLine: Record "Job Journal Line";
        NextLineNo: Integer;
    begin
        LastJobJournalLine.SetLoadFields("Posting Date", "Document No.");
        LastJobJournalLine.SetRange("Journal Template Name", TSConnectorSetup."Journal Template Name");
        LastJobJournalLine.SetRange("Journal Batch Name", TSConnectorSetup."Journal Batch Name");
        if LastJobJournalLine.FindLast() then
            NextLineNo := LastJobJournalLine."Line No." + 10000
        else
            NextLineNo := 10000;

        JobJournalLine."Journal Template Name" := TSConnectorSetup."Journal Template Name";
        JobJournalLine."Journal Batch Name" := TSConnectorSetup."Journal Batch Name";
        JobJournalLine."Line No." := NextLineNo;
        JobJournalLine.SetUpNewLine(LastJobJournalLine);
    end;
}
