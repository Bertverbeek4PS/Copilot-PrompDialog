page 50100 Copilot
{
    PageType = PromptDialog;
    Extensible = false;
    ApplicationArea = All;
    SourceTable = "Customer";
    SourceTableTemporary = true;
    Caption = 'Copilot Fps';
    IsPreview = true;

    layout
    {
        area(Prompt)
        {

            part(custLedgerEntries; "Cust Ledger Entries Copilot")
            {
                Caption = 'Closed Entries';
            }
            part(custLedgerEntriesOpen; "Cust Ledger Entries Copilot")
            {
                Caption = 'Select open entry';
            }
        }
        area(Content)
        {
            field(Response; Response)
            {
                ShowCaption = false;
                MultiLine = true;
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(SystemActions)
        {
            systemaction(Generate)
            {
                Caption = 'Generate';
                trigger OnAction()
                var
                    Copilot: Codeunit "Copilot";
                    CopilotCustLedgerEntries: Record "Copilot Cust Ledger Entries";
                    CopilotCustLedgerEntriesOpen: Record "Copilot Cust Ledger Entries";
                begin
                    CurrPage.custLedgerEntries.Page.GetRecords(CopilotCustLedgerEntries);
                    CurrPage.custLedgerEntriesOpen.Page.GetRecords(CopilotCustLedgerEntriesOpen);
                    Response := Copilot.Generate(CopilotCustLedgerEntries, CopilotCustLedgerEntriesOpen);
                    CurrPage.Update();
                end;
            }
            systemaction(OK)
            {
                Caption = 'Confirm';
                ToolTip = 'Add suggestion to the database.';
            }
            systemaction(Cancel)
            {
                Caption = 'Discard';
                ToolTip = 'Discard suggestion proposed by Dynamics 365 Copilot.';
            }
            systemaction(Regenerate)
            {
                Caption = 'Regenerate';
                ToolTip = 'Regenerate proposal with Dynamics 365 Copilot.';
                trigger OnAction()
                var
                    Copilot: Codeunit "Copilot";
                    CopilotCustLedgerEntries: Record "Copilot Cust Ledger Entries";
                    CopilotCustLedgerEntriesOpen: Record "Copilot Cust Ledger Entries";
                begin
                    CurrPage.custLedgerEntries.Page.GetRecords(CopilotCustLedgerEntries);
                    CurrPage.custLedgerEntriesOpen.Page.GetRecords(CopilotCustLedgerEntriesOpen);
                    Response := Copilot.Generate(CopilotCustLedgerEntries, CopilotCustLedgerEntriesOpen);
                    CurrPage.Update();
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        Copilot: Codeunit "Copilot";
        CustLedgerEntries: Record "Cust. Ledger Entry";
        CustLedgerEntriesCopilot: Page "Cust Ledger Entries Copilot";
    begin
        Copilot.RegisterCapability();
        CurrPage.custLedgerEntries.Page.Load(CustomerNo, false);
        CurrPage.custLedgerEntriesOpen.Page.Load(CustomerNo, true);
    end;

    var
        UserInput: Text;
        Response: Text;
        CustomerNo: text;

    internal procedure SetCustomerNo(_CustomerNo: Code[20])
    begin
        CustomerNo := _CustomerNo;
    end;
}