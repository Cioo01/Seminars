page 50018 "Seminar Registration List"
{
    Caption = 'Seminar Registration List';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Seminar Registration Header";
    Editable = false;
    CardPageId = "Seminar Registration Card";

    layout
    {
        area(Content)
        {
            repeater(Repeater1)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Starting Date"; Rec."Starting Date")
                {
                    ApplicationArea = all;
                }

                field("Seminar Code"; Rec."Seminar Code")
                {
                    ApplicationArea = All;
                }
                field("Seminar Name"; Rec."Seminar Name")
                {
                    ApplicationArea = All;
                }
                field("Instructor Code"; Rec."Instructor Code")
                {
                    ApplicationArea = All;
                }
                field("Instructor Name"; Rec."Instructor Name")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        Area(Processing)
        {
            action("Export Seminars and Participants to  XML")
            {
                Caption = 'Export Seminars and Participants to XML';
                ApplicationARea = All;
                Image = XMLFile;
                trigger OnAction()
                begin
                    XMLport.run(Xmlport::"Sem. Particip. List Export XML")
                end;
            }
        }

    }
}