Table 50040 "Seminar Registration Header"
{
    /*
        4.4.1 - ZROBIONE I PRZETESTOWANE
        4.4.2 - ZROBIONE I PRZETESTOWANE
        4.4.3 - ZROBIONE I PRZETESTOWANE
        4.4.4 - ZROBIONE I PRZETESTOWANE
        4.4.5 - ZROBIONE I PRZETESTOWANE
        4.4.6 - ZROBIONE I PRZETESTOWANE
        4.4.7 - ZROBIONE I PRZETESTOWANE
        4.4.8 - ZROBIONE I PRZETESTOWANE
    */
    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            //4.4.4
            trigger OnValidate()
            begin
                if xRec."No." <> '' then
                    Error(SRHCantEditRecordNameErr);
            end;
        }
        field(2; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
            //4.4.5
            trigger OnValidate()
            begin
                if Status <> Status::Planning then
                    Error(SRHCantModifyStartingDateIfStatusNotPlanningErr);
            end;
        }
        field(3; "Seminar Code"; Code[20])
        {
            Caption = 'Seminar Code';
            TableRelation = Seminar;
            //4.4.1.1
            trigger OnValidate()
            var
                Seminarr: Record Seminar;
                SeminarRegLine: Record "Seminar Registration Line";
            begin
                if Seminarr.Get("Seminar Code") then begin
                    Seminarr.TestField(Seminarr.Blocked, false);
                    "Seminar Name" := Seminarr.Name;
                    "Seminar Duration" := Seminarr."Seminar Duration";
                    "Minimum Participants" := Seminarr."Minimum Participants";
                    "Maximum Participants" := Seminarr."Maximum Participants";
                    Validate("Seminar Price", Seminarr."Seminar Price");
                end else begin
                    "Seminar Name" := '';
                    "Seminar Duration" := 0;
                    "Minimum Participants" := 0;
                    "Maximum Participants" := 0;
                    "Seminar Price" := 0;
                end;
                //4.4.6
                SeminarRegLine.Reset();
                SeminarRegLine.SetRange(SeminarRegLine."Seminar Registration No.", "No.");
                if SeminarRegLine.FindSet() then
                    repeat
                        if SeminarRegLine.Registered then
                            Error(SeminarWithRegisteredLinesModifyErr);
                    until SeminarRegLine.Next() = 0;
            end;
        }
        field(4; "Seminar Name"; Text[50])
        {
            Caption = 'Seminar Name';

        }
        field(5; "Instructor Code"; Code[20])
        {
            Caption = 'Instructor Code';
            TableRelation = "Instructor";
            //4.4.7
            trigger OnValidate()
            var
                DedykowanaFunkcja: Record Instructor;
            begin
                DedykowanaFunkcja.Get("Instructor Code");
                "Instructor Name" := DedykowanaFunkcja.Name;
            end;
        }
        field(6; "Instructor Name"; Text[100])
        {
            Caption = 'Instructor Name';
            FieldClass = FlowField;
            CalcFormula = lookup(Instructor.Name where(Code = Field("Instructor Code")));
            Editable = false;
        }
        field(7; Status; Option)
        {
            Caption = 'Status';
            OptionMembers = Planning,Registration,Finished,Cancelled;
            OptionCaption = 'Planning,Registration,Finished,Cancelled';
        }
        field(8; "Seminar Duration"; Decimal)
        {
            Caption = 'Seminar Duration';
            DecimalPlaces = 0 : 1;
        }
        field(9; "Minimum Participants"; Integer)
        {
            Caption = 'Minimum Participants';
        }
        field(10; "Maximum Participants"; Integer)
        {
            Caption = 'Maximum Participants';
        }
        field(11; "Seminar Room Code"; Code[20])
        {
            Caption = 'Seminar Room Code';
            TableRelation = "Seminar Room";

            //4.4.1.2
            trigger OnValidate()
            var
                SeminarRoom: Record "Seminar Room";
            begin
                if SeminarRoom.Get("Seminar Room Code") then begin
                    "Seminar Room Name" := SeminarRoom.Name;
                    "Seminar Room Address" := SeminarRoom.Address;
                    "Seminar Room Address 2" := SeminarRoom."Address 2";
                    "Seminar Room Post Code" := SeminarRoom."Post Code";
                    "Seminar Room City" := SeminarRoom.City;
                    "Seminar Room Phone No." := SeminarRoom."Phone No.";
                end else begin
                    "Seminar Room Name" := '';
                    "Seminar Room Address" := '';
                    "Seminar Room Address 2" := '';
                    "Seminar Room Post Code" := '';
                    "Seminar Room City" := '';
                    "Seminar Room Phone No." := '';
                end;
            end;
        }
        field(12; "Seminar Room Name"; Text[50])
        {
            Caption = 'Seminar Room Name';
        }
        field(13; "Seminar Room Address"; Text[50])
        {
            Caption = 'Seminar Room Address';
        }
        field(14; "Seminar Room Address 2"; Text[50])
        {
            Caption = 'Seminar Room Address 2';
        }
        field(15; "Seminar Room Post Code"; Code[20])
        {
            Caption = 'Seminar Room Post Code';
            TableRelation = "Post Code";
        }
        field(16; "Seminar Room City"; Text[30])
        {
            Caption = 'Seminar Room City';
        }
        field(17; "Seminar Room Phone No."; Text[30])
        {
            Caption = 'Seminar Room Phone No';
        }
        field(18; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(19; "Seminar Price"; Decimal)
        {
            Caption = 'Seminar Price';
            //4.4.8
            trigger OnValidate()
            var
                SeminarRegLine: Record "Seminar Registration Line";
                ConfirmUpdatePrice: Boolean;
            begin
                if Status <> Status::Cancelled then begin
                    ConfirmUpdatePrice := Confirm('Do you want to update the "Seminar Price" for all unregistered records?');
                    if ConfirmUpdatePrice then begin
                        SeminarRegLine.Reset();
                        SeminarRegLine.SetRange("Seminar Registration No.", "No.");
                        SeminarRegLine.SetFilter(Registered, '0');
                        if SeminarRegLine.FindSet() then
                            repeat
                                SeminarRegLine."Seminar Price" := "Seminar Price";
                                SeminarRegLine."Line Discount Amount" := Round("Seminar Price" * SeminarRegLine."Line Discount %" / 100, 0.01);
                                SeminarRegLine.Amount := "Seminar Price" - (Round("Seminar Price" * SeminarRegLine."Line Discount %" / 100, 0.01));
                                SeminarRegLine.Modify();
                            until SeminarRegLine.Next() = 0;
                    end;
                end;
            end;
        }
        field(20; Amount; Decimal)
        {
            Caption = 'Amount';
            FieldClass = FlowField;
            CalcFormula = sum("Seminar Registration Line".Amount where("Seminar Registration No." = Field("No.")));
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }

    //4.4.2
    trigger OnInsert()
    begin
        "Posting Date" := WorkDate();
    end;

    //4.4.3
    trigger OnDelete()
    begin
        if Status <> "Status"::Planning then
            Error(SRHCantDeleteRecordIfStatusIsEqualPlanningErr);
    end;

    var
        SRHCantEditRecordNameErr: Label 'Cant Edit Record Name';
        SRHCantDeleteRecordIfStatusIsEqualPlanningErr: Label 'Cant Delete Record If Status Is Equal to Planning';
        SeminarWithRegisteredLinesModifyErr: Label 'Seminars with registered lines cannot be modified';
        SRHCantModifyStartingDateIfStatusNotPlanningErr: Label 'Cant Modify Starting Date If Status Is Different Than Planning';
}