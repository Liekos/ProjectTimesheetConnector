namespace MDV.Timesheet;

using Microsoft.Foundation.NoSeries;
using Microsoft.Projects.Project.Job;
using Microsoft.Projects.Project.Journal;
using Microsoft.Projects.Resources.Resource;
using Microsoft.Utilities;

/// <summary>
/// Grants an API client (e.g. a Microsoft Entra app registration used service-to-service) access to the Timesheet Connector API pages and their source tables.
/// </summary>
permissionset 60100 "Timesheet API"
{
    Assignable = true;
    Caption = 'Timesheet Connector API', Locked = true;

    Permissions =
        codeunit "MDV Time Entry Mgt. TSC" = X,
        page "MDV Project API TSC" = X,
        page "MDV Project Task API TSC" = X,
        page "MDV Resource API TSC" = X,
        page "MDV Time Entry API TSC" = X,
        page "MDV Work Type API TSC" = X,
        tabledata Job = R,
        tabledata "Job Journal Batch" = r,
        tabledata "Job Journal Line" = RI,
        tabledata "Job Journal Template" = r,
        tabledata "Job Task" = R,
        tabledata "MDV TS Connector Setup TSC" = r,
        tabledata "No. Series" = r,
        tabledata "No. Series Line" = r,
        tabledata Resource = R,
        tabledata "Work Type" = R;
}
