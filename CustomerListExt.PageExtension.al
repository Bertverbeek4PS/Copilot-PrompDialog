pageextension 50100 CustomerExt extends "Customer Card"
{
    actions
    {
        addafter(WordTemplate)
        {
            action(Copilot)
            {
                Caption = 'Copilot';
                ApplicationArea = All;
                Image = Sparkle;

                trigger OnAction()
                var
                    Copilot: Page "Copilot";
                    CustLedgerEntriesCopilot: Page "Cust Ledger Entries Copilot";
                begin
                    Copilot.SetCustomerNo(Rec."No.");
                    Copilot.RunModal();
                end;
            }
        }
    }

}