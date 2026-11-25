namespace MDV.Timesheet;

/// <summary>
/// Grants administrators access to maintain the Timesheet Connector Setup.
/// </summary>
permissionset 60101 "Timesheet Admin"
{
    Assignable = true;
    Caption = 'Timesheet Connector Admin', Locked = true;

    Permissions =
        page "MDV TS Connector Setup TSC" = X,
        table "MDV TS Connector Setup TSC" = X,
        tabledata "MDV TS Connector Setup TSC" = RIMD;
}
