page 50102 "Cust Ledger Entries Copilot"
{
    PageType = ListPart;
    ApplicationArea = All;
    SourceTable = "Copilot Cust Ledger Entries";
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(DocumentType; rec."Document Type")
                {
                    Editable = false;
                }
                field(DocumentNo; rec."Document No.")
                {
                    Editable = false;
                }
                field(DOcumentDate; rec."Document Date")
                {
                    Editable = false;
                }
                field(DueDate; rec."Due Date")
                {
                    Editable = false;
                }
                field(ClosedatDate; rec."Closed at Date")
                {
                    Editable = false;
                }
                field(Select; rec.Select)
                {

                }
            }
        }
    }
    procedure Load(CustomerNo: Code[20]; Open: Boolean);
    var
        CustLedgerEntries: Record "Cust. Ledger Entry";
        i: Integer;
    begin
        Rec.Reset();
        Rec.DeleteAll();

        CustLedgerEntries.SetCurrentKey("Customer No.", "Open", "Document Type", "Document No.");
        CustLedgerEntries.SetRange("Customer No.", CustomerNo);
        CustLedgerEntries.SetRange("Open", Open);
        CustLedgerEntries.SetRange("Document Type", CustLedgerEntries."Document Type"::Invoice);
        CustLedgerEntries.SetAscending("Document No.", false);
        if CustLedgerEntries.FindSet() then
            repeat
                i := i + 1;
                rec."Entry No." := CustLedgerEntries."Entry No.";
                rec."Document Type" := CustLedgerEntries."Document Type";
                rec."Document No." := CustLedgerEntries."Document No.";
                rec."Document Date" := CustLedgerEntries."Document Date";
                rec."Due Date" := CustLedgerEntries."Due Date";
                rec."Closed at Date" := CustLedgerEntries."Closed at Date";
                if (i > 10) or Open then
                    rec.Select := false
                else
                    rec.Select := true;

                rec.Insert();
            until CustLedgerEntries.Next() = 0;

        CurrPage.Update(false);
    end;

    procedure GetRecords(var CopilotCustLedgerEntries: Record "Copilot Cust Ledger Entries");
    begin
        rec.SetRange(Select, true);
        If rec.FindSet() then
            repeat
                CopilotCustLedgerEntries.TransferFields(rec);
                CopilotCustLedgerEntries.Insert();
            until rec.Next() = 0;
    end;
}