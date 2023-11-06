page 50100 Copilot
{
    PageType = PromptDialog;
    SourceTableTemporary = true;
    Extensible = false;
    ApplicationArea = All;
    SourceTable = Customer;
    Caption = 'Copilot Fps';
    IsPreview = true;

    layout
    {
        area(Prompt)
        {
            field(UserInput; UserInput)
            {
                ShowCaption = false;
                MultiLine = true;
                ApplicationArea = All;

                trigger OnValidate()
                begin
                    CurrPage.Update();
                end;
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
                begin
                    Response := Copilot.Generate(UserInput);
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
                ToolTip = 'Discard suggestio proposed by Dynamics 365 Copilot.';
            }
            systemaction(Regenerate)
            {
                Caption = 'Regenerate';
                ToolTip = 'Regenerate Item Substitutions proposal with Dynamics 365 Copilot.';
                trigger OnAction()
                var
                    Copilot: Codeunit "Copilot";
                begin
                    Response := Copilot.Generate(UserInput);
                    CurrPage.Update();
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        Copilot: Codeunit "Copilot";
    begin
        Copilot.RegisterCapability();
    end;

    var
        UserInput: Text;
        Response: Text;
}