pageextension 50100 CustomerExt extends "Customer Card"
{
    actions
    {
        addafter(NewBlanketSalesOrder)
        {
            action(Copilot)
            {
                RunObject = Page "Copilot";
                Caption = 'Copilot';
                ApplicationArea = All;
                Image = Sparkle;
            }
        }
    }

}