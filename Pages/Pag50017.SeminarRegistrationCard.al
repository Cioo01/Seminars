page 50017 "Seminar Registration Card"
{
    Caption = 'Seminar Registration Card';
    PromotedActionCategories = 'Issue Invoice';
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Seminar Registration Header";

    layout
    {

        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Starting Date"; Rec."Starting Date")
                {
                    ApplicationArea = All;
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
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field("Seminar Duration"; Rec."Seminar Duration")
                {
                    ApplicationArea = All;
                }
                field("Minimum Participants"; Rec."Minimum Participants")
                {
                    ApplicationArea = All;
                }
                field("Maximum Participants"; Rec."Maximum Participants")
                {
                    ApplicationArea = All;
                }
                field("Seminar Price"; Rec."Seminar Price")
                {
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                }
            }
            group("Seminary Room")
            {
                Caption = 'Seminary Room';
                field("Seminar Room Code"; Rec."Seminar Room Code")
                {
                    ApplicationArea = All;
                }
                field("Seminar Room Name"; Rec."Seminar Room Name")
                {
                    ApplicationArea = All;
                }
                field("Seminar Room Address"; Rec."Seminar Room Address")
                {
                    ApplicationArea = All;
                }
                field("Seminar Room Address 2"; Rec."Seminar Room Address 2")
                {
                    ApplicationArea = All;
                }
                field("Seminar Room Post Code"; Rec."Seminar Room Post Code")
                {
                    ApplicationArea = All;
                }
                field("Seminar Room City"; Rec."Seminar Room City")
                {
                    ApplicationArea = All;
                }
                field("Seminar Room Phone No."; Rec."Seminar Room Phone No.")
                {
                    ApplicationArea = All;
                }
            }
            part(Rows; "Seminar Registration Subpage")
            {
                Caption = 'Rows';
                SubPageLink = "Seminar Registration No." = field("No.");
            }
        }
    }

    actions
    {
        area(Reporting)
        {
            action("Issue Invoice")
            {
                Promoted = true;
                PromotedCategory = New;
                Caption = 'Issue Invoice';
                ApplicationArea = All;
                Image = CreateDocument;

                trigger OnAction()
                var
                    RunObject: Codeunit "Seminar Management";
                    regHeader: Record "Seminar Registration Header";
                begin
                    regHeader.Get(Rec."No.");
                    RunObject.CreateSalesInvoice(regHeader);
                end;

            }
        }
    }

}