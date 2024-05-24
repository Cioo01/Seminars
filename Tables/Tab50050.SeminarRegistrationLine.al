Table 50050 "Seminar Registration Line"
{

    /*
        4.5.1 - ZROBIONE I PRZETESTOWANE
        4.5.2 - ZROBIONE I PRZETESTOWANE
        4.5.3 - ZROBIONE I PRZETESTOWANE
        4.5.4 - ZROBIONE I PRZETESTOWANE
        4.5.5 - ZROBIONE I PRZETESTOWANE
        4.5.6 - ZROBIONE I PRZETESTOWANE
    */

    fields
    {
        field(1; "Seminar Registration No."; Code[20])
        {
            Caption = 'Seminar Registration No.';
            TableRelation = "Seminar Registration Header";
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
            AutoIncrement = true;
        }
        field(3; "Bill-to Customer No."; Code[20])
        {
            Caption = 'Bill-to Customer No.';
            TableRelation = "Customer";
        }
        field(4; "Participant Contact No."; Code[20])
        {
            Caption = 'Participant Contact No.';
            TableRelation = "Contact";

            trigger OnLookup()
            var
                contactBusinessRelation: Record "Contact Business Relation";
                contact: Record Contact;
            begin
                contactBusinessRelation.Reset();
                contactBusinessRelation.SetRange("Link to Table", contactBusinessRelation."Link to Table"::Customer);
                contactBusinessRelation.SetRange("No.", "Bill-to Customer No.");
                if contactBusinessRelation.FindFirst() then begin
                    contact.Reset();
                    contact.SetRange("Company No.", contactBusinessRelation."Contact No.");
                    if Page.RunModal(5052, contact) = Action::LookupOK then begin
                        "Participant Contact No." := contact."No.";
                        "Participant Name" := contact.Name;
                    end;
                end;
            end;
        }
        field(5; "Participant Name"; Text[100])
        {
            Caption = 'Participant Name';
            FieldClass = FlowField;
            CalcFormula = lookup(Contact.Name);
        }
        field(6; "Register Date"; Date)
        {
            Caption = 'Register Date';
            Editable = false;
        }
        field(7; "To Invoice"; Boolean)
        {
            Caption = 'To Invoice';
            InitValue = false;
        }
        field(8; Participated; Boolean)
        {
            Caption = 'Participated';
        }
        field(9; "Confirmation Date"; Date)
        {
            Caption = 'Confirmation Date';
        }
        field(10; "Seminar Price"; Decimal)
        {
            Caption = 'Seminar Price';
            AutoFormatType = 2;
            trigger OnValidate()
            begin
                "Line Discount Amount" := Round("Seminar Price" * "Line Discount %" / 100, 0.01);
                Amount := "Seminar Price" - "Line Discount Amount";
            end;
        }
        field(11; "Line Discount %"; Decimal)
        {
            Caption = 'Line Discount %';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
            MaxValue = 100;
            //4.5.2
            trigger OnValidate();
            begin
                "Line Discount Amount" := Round("Seminar Price" * "Line Discount %" / 100, 0.01);
                Amount := "Seminar Price" - "Line Discount Amount";
            end;
        }
        field(12; "Line Discount Amount"; Decimal)
        {
            Caption = 'Line Discount Amount';
            AutoFormatType = 1;
            //4.5.2
            trigger OnValidate();
            begin
                if "Seminar Price" <> 0 then
                    "Line Discount %" := Round("Line Discount Amount" / "Seminar Price" * 100, 0.00001);
                Amount := "Seminar Price" - "Line Discount Amount";
            end;
        }
        field(13; Amount; Decimal)
        {
            Caption = 'Amount';
            AutoFormatType = 1;
        }
        field(14; Registered; Boolean)
        {
            Caption = 'Registered';
            //4.5.5
            trigger OnValidate()
            begin
                if Registered then
                    if "Register Date" = 0D then
                        "Register Date" := WorkDate();
            end;
        }
        field(15; "Invoice No."; Code[20])
        {
            Caption = 'Invoice No.';
            Editable = false;
            TableRelation = "Sales Header" where("Document Type" = FILTER("Invoice"));
        }
    }

    keys
    {
        key(Key1; "Seminar Registration No.", "Line No.")
        {
            Clustered = true;
            SumIndexFields = Amount;
        }
    }
    //4.5.1
    trigger OnInsert();
    var
        SeminarRegistrationHeader: Record "Seminar Registration Header";
    begin
        if SeminarRegistrationHeader.Get("Seminar Registration No.") then begin
            "Seminar Price" := SeminarRegistrationHeader."Seminar Price";
            Amount := "Seminar Price";
        end;
    end;
    //4.5.4
    trigger OnModify();
    begin
        if not xRec.Registered then
            Validate("Bill-to Customer No.", xRec."Bill-to Customer No.");
        if (xRec."Bill-to Customer No." <> "Bill-to Customer No.") and (Registered or xRec.Registered) then
            Error(SRLCantModifyBTCBcsRegisteredRecord);
    end;
    //4.5.3
    trigger OnDelete();
    begin
        if Registered then
            Error(SRLCantDeleteRegisteredRecord);
    end;


    var
        SRLCantDeleteRegisteredRecord: Label 'You cannot delete this record because it is registered';
        SRLCantModifyBTCBcsRegisteredRecord: Label 'You cannot modify the Bill-to Customer No. because the record is registered';
}