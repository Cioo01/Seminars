xmlport 50000 "Sem. Particip. List Export XML"
{
    Direction = Export;
    Format = Xml;
    UseRequestPage = true;

    schema
    {
        textelement(Seminar_Registration_Participant_List)
        {
            tableelement(Seminar; "Seminar Registration Header")
            {
                fieldelement(Registration_No; Seminar."No.")
                {
                }
                fieldelement(Seminar_Code; Seminar."Seminar Code")
                {
                }
                fieldelement(Seminar_Name; Seminar."Seminar Name")
                {
                }
                fieldelement(Starting_Date; Seminar."Starting Date")
                {
                }
                fieldelement(Seminar_Duration; Seminar."Seminar Duration")
                {
                }
                fieldelement(Instructor_Name; Seminar."Instructor Name")
                {
                }
                fieldelement(Room_Name; Seminar."Seminar Room Name")
                {
                }
                tableelement(Participant; "Seminar Registration Line")
                {
                    LinkTable = Seminar;
                    LinkFields = "Seminar Registration No." = Field("No.");
                    fieldelement(Customer_No; Participant."Bill-to Customer No.")
                    {
                    }
                    textelement(Customer)
                    {
                        XmlName = 'Customer_Name';
                        trigger OnBeforePassVariable()
                        var
                            XDXDXD: Record Customer;
                        begin
                            if XDXDXD.Get(Participant."Bill-to Customer No.") then
                                Customer := XDXDXD.Name;

                        end;
                    }
                    fieldelement(Contact_No; Participant."Participant Contact No.")
                    {
                    }
                    fieldelement(Participant_Name; Participant."Participant Name")
                    {
                    }
                }
            }
        }
    }
}