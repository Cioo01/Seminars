pageextension 50016 "Sales Receivables Setup Ext" extends "Sales & Receivables Setup"
{
    layout
    {
        addlast(Content)
        {
            group("Seminar Module")
            {
                Caption = 'Seminar Module';
                field("G/L Account No."; Rec."G/L Account No.")
                {
                    ApplicationArea = All;
                }
            }
        }
    }


    var
        myInt: Integer;
}