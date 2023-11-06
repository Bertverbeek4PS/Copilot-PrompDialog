pageextension 50100 CustomerExt extends "Customer Card"
{
    actions
    {
        addafter(WordTemplate)
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