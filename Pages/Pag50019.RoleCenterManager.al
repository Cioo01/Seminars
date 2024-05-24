profile "Role Center Manager"
{
    Caption = 'Role Center Manager';
    RoleCenter = "Role Center Manager";
}

page 50019 "Role Center Manager"
{
    PageType = RoleCenter;

    layout
    {
    }

    actions
    {
        area(Sections)
        {
            group(Lists)
            {
                Caption = 'Lists';
                action(Seminary)
                {
                    caption = 'Seminars';
                    ApplicationArea = All;
                    RunObject = page "Seminar List";
                }
                action(Instructors)
                {
                    caption = 'Instructors';
                    ApplicationArea = All;
                    RunObject = page "Instructor List";
                }
                action("Seminar Room")
                {
                    caption = 'Seminar Room';
                    ApplicationArea = All;
                    RunObject = page "Seminar Room List";
                }
                action("Seminar Registration")
                {
                    caption = 'Seminar Registration';
                    ApplicationArea = All;
                    RunObject = page "Seminar Registration List";
                }

            }
            group(Tasks)
            {
                caption = 'Tasks';
                action("Export Seminar Participants")
                {
                    caption = 'Export Seminar Participants';
                    ApplicationArea = All;
                    RunObject = xmlport "Sem. Particip. List Export XML";
                }

            }
        }
    }

    var
        myInt: Integer;
}

